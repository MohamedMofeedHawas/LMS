

namespace SkyLearnApi.Services.Implementation
{
    /// Authentication service for the Air Force Academy closed system.
    /// Implements the complete authentication flow:
    /// - Account verification (check existence and activation status)
    /// - Account activation (first-time password setup)
    /// - Standard login (for activated users)
    /// - Password recovery (without revealing account existence    
    public class AuthService : IAuthService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly IJwtService _jwtService;
        private readonly IActivityService _activityService;
        private readonly AppDbContext _dbContext;
        private readonly IWebHostEnvironment _environment;

        public AuthService(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            IJwtService jwtService,
            IActivityService activityService,
            AppDbContext dbContext,
            IWebHostEnvironment environment)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _jwtService = jwtService;
            _activityService = activityService;
            _dbContext = dbContext;
            _environment = environment;
        }

        #region Account Verification

        /// <inheritdoc />
        public async Task<VerifyAccountResponseDto> VerifyAccountAsync(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);

            if (user == null)
            {
                Log.Information("Account verification: Email {Email} not found in system", email);
                await _activityService.TrackAsync(
                    ActivityActions.AccountVerification,
                    description: "Account verification - email not found",
                    metadata: new { email, exists = false });

                return new VerifyAccountResponseDto
                {
                    Exists = false,
                    IsActivated = false
                };
            }

            Log.Information("Account verification: Email {Email} found, IsActivated={IsActivated}", 
                email, user.IsActivated);

            await _activityService.TrackAsync(
                ActivityActions.AccountVerification,
                userId: user.Id,
                description: "Account verification successful",
                metadata: new { email, exists = true, isActivated = user.IsActivated });

            return new VerifyAccountResponseDto
            {
                Exists = true,
                IsActivated = user.IsActivated
            };
        }

        #endregion

        #region Account Activation

        /// <inheritdoc />
        public async Task<ActivateAccountResponseDto?> ActivateAccountAsync(string email, string password)
        {
            var user = await _userManager.FindByEmailAsync(email);

            // Validate: User must exist
            if (user == null)
            {
                Log.Warning("Activation attempt for non-existent email: {Email}", email);
                await _activityService.TrackAsync(
                    ActivityActions.ActivationFailed,
                    description: "Activation failed - user not found",
                    metadata: new { email, reason = "UserNotFound" });
                return null;
            }

            // Validate: User must not be already activated
            if (user.IsActivated)
            {
                Log.Warning("Activation attempt for already activated account: {Email}", email);
                await _activityService.TrackAsync(
                    ActivityActions.ActivationFailed,
                    userId: user.Id,
                    description: "Activation failed - already activated",
                    metadata: new { email, reason = "AlreadyActivated" });
                return null;
            }

            // Validate: User must be active (not disabled by admin)
            if (!user.IsActive)
            {
                Log.Warning("Activation attempt for inactive account: {Email}", email);
                await _activityService.TrackAsync(
                    ActivityActions.ActivationFailed,
                    userId: user.Id,
                    description: "Activation failed - account is inactive",
                    metadata: new { email, reason = "AccountInactive" });
                return null;
            }

            // Set the password
            var passwordResult = await _userManager.AddPasswordAsync(user, password);

            if (!passwordResult.Succeeded)
            {
                var errors = string.Join(", ", passwordResult.Errors.Select(e => e.Description));
                Log.Warning("Password setup failed for {Email}: {Errors}", email, errors);
                await _activityService.TrackAsync(
                    ActivityActions.ActivationFailed,
                    userId: user.Id,
                    description: "Activation failed - password requirements not met",
                    metadata: new { email, errors });
                return null;
            }

            // Mark as activated
            user.IsActivated = true;
            user.LastLoginAt = DateTime.UtcNow;
            user.UpdatedAt = DateTime.UtcNow;

            var updateResult = await _userManager.UpdateAsync(user);
            if (!updateResult.Succeeded)
            {
                Log.Error("Failed to update user activation status for {Email}", email);
                return null;
            }

            // Get roles and generate JWT
            var roles = await _userManager.GetRolesAsync(user);
            var tokenResult = await _jwtService.GenerateTokenAsync(user);

            // Track successful activation
            await _activityService.TrackAsync(
                ActivityActions.AccountActivated,
                userId: user.Id,
                description: "Account activated successfully",
                metadata: new
                {
                    email,
                    roles,
                    jti = tokenResult.Jti,
                    tokenExpiresAt = tokenResult.ExpiresAt
                });

            Log.Information("Account activated successfully: {Email} (UserId: {UserId})", email, user.Id);

            return new ActivateAccountResponseDto
            {
                Message = "Account activated successfully",
                Token = tokenResult.Token,
                ExpiresIn = tokenResult.ExpiresAt,
                User = MapToUserProfile(user, roles.FirstOrDefault() ?? "Student")
            };
        }

        #endregion

        #region Standard Login

        /// <inheritdoc />
        public async Task<AuthResponseDto?> LoginAsync(string email, string password)
        {
            var user = await _userManager.FindByEmailAsync(email);

            // Validate: User must exist
            if (user == null)
            {
                await _activityService.TrackLoginFailedAsync(email, "UserNotFound");
                return null;
            }

            // Validate: User must be active
            if (!user.IsActive)
            {
                await _activityService.TrackLoginFailedAsync(email, "UserInactive");
                return null;
            }

            // Validate: User must be activated (password set)
            if (!user.IsActivated)
            {
                Log.Warning("Login attempt for non-activated account: {Email}", email);
                await _activityService.TrackLoginFailedAsync(email, "AccountNotActivated");
                return null;
            }

            // Validate password
            var result = await _signInManager.CheckPasswordSignInAsync(user, password, lockoutOnFailure: true);

            if (!result.Succeeded)
            {
                var reason = result.IsLockedOut ? "AccountLockedOut" :
                             result.IsNotAllowed ? "SignInNotAllowed" : "InvalidPassword";

                await _activityService.TrackLoginFailedAsync(email, reason);
                return null;
            }

            var roles = await _userManager.GetRolesAsync(user);
            var tokenResult = await _jwtService.GenerateTokenAsync(user);

            // Update last login time
            user.LastLoginAt = DateTime.UtcNow;
            await _userManager.UpdateAsync(user);

            // Track successful login with session info
            await _activityService.TrackLoginAsync(
                user.Id,
                sessionId: _activityService.GetCurrentSessionId(),
                jti: tokenResult.Jti,
                tokenExpiresAt: tokenResult.ExpiresAt,
                metadata: new
                {
                    email = user.Email,
                    roles,
                    ipAddress = _activityService.GetCurrentIpAddress()
                });

            return new AuthResponseDto
            {
                Token = tokenResult.Token,
                ExpiresIn = tokenResult.ExpiresAt,
                User = new UserDto
                {
                    Id = user.Id,
                    FullName = user.FullName,
                    Email = user.Email ?? "",
                    Role = roles.FirstOrDefault() ?? "Student",
                    Gender = user.Gender,
                    City = user.City,
                    ProfileImageUrl = user.ProfileImageUrl
                }
            };
        }

        #endregion

        #region Logout

        /// <inheritdoc />
        public async Task LogoutAsync(string token)
        {
            var tokenInfo = _jwtService.ParseToken(token);

            if (tokenInfo == null)
            {
                Log.Warning("Logout attempted with invalid token");
                await _activityService.TrackAsync(
                    ActivityActions.LogoutFailed,
                    description: "Invalid or missing token");
                return;
            }

            await _activityService.TrackLogoutAsync(
                tokenInfo.UserId,
                sessionId: _activityService.GetCurrentSessionId(),
                jti: tokenInfo.Jti,
                metadata: new
                {
                    tokenExpiresAt = tokenInfo.ExpiresAt
                });
        }

        #endregion

        #region User Profile

        /// <inheritdoc />
        public async Task<UserProfileDto?> GetCurrentUserProfileAsync(int userId)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());

            if (user == null)
            {
                Log.Warning("Profile request for non-existent user ID: {UserId}", userId);
                return null;
            }

            var roles = await _userManager.GetRolesAsync(user);
            var role = roles.FirstOrDefault() ?? "Student";

            // Load student profile for polymorphic response
            StudentProfile? profile = null;
            if (role == Roles.Student)
            {
                profile = await _dbContext.StudentProfiles
                    .AsNoTracking()
                    .Include(sp => sp.Department)
                    .Include(sp => sp.Year)
                    .Include(sp => sp.Squadron)
                    .FirstOrDefaultAsync(sp => sp.UserId == userId);
            }

            await _activityService.TrackAsync(
                ActivityActions.ProfileViewed,
                userId: user.Id,
                description: "User viewed their profile");

            return MapToUserProfile(user, role, profile);
        }

        public async Task<UserProfileDto?> UpdateProfileAsync(int userId, UpdateProfileRequestDto dto)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null) return null;

            bool isUpdated = false;

            if (dto.DateOfBirth.HasValue)
            {
                user.DateOfBirth = dto.DateOfBirth.Value;
                isUpdated = true;
            }

            if (!string.IsNullOrEmpty(dto.City))
            {
                user.City = dto.City;
                isUpdated = true;
            }

            if (dto.ProfileImage != null)
            {
                if (!string.IsNullOrEmpty(user.ProfileImageUrl))
                    ImageHelper.DeleteImage(user.ProfileImageUrl, _environment);

                user.ProfileImageUrl = await ImageHelper.SaveImageAsync(dto.ProfileImage, "users", _environment);
                isUpdated = true;
            }

            if (isUpdated)
            {
                user.UpdatedAt = DateTime.UtcNow;
                await _userManager.UpdateAsync(user);
                
                // Track update
                await _activityService.TrackAsync(
                    ActivityActions.ProfileUpdated,
                    userId: user.Id,
                    description: "User profile updated",
                    metadata: new { 
                         updatedFields = new[] 
                         { 
                             dto.DateOfBirth.HasValue ? "DateOfBirth" : null,
                             !string.IsNullOrEmpty(dto.City) ? "City" : null,
                             dto.ProfileImage != null ? "ProfileImage" : null
                         }.Where(f => f != null)
                    });
            }

            return await GetCurrentUserProfileAsync(userId);
        }

        #endregion

        #region Password Recovery

        /// <inheritdoc />
        public async Task<ForgotPasswordResponseDto> ForgotPasswordAsync(string email)
        {
            var response = new ForgotPasswordResponseDto
            {
                Message = "If the email exists, password reset instructions will be provided."
            };

            var user = await _userManager.FindByEmailAsync(email);

            // SECURITY: Always return the same message to prevent email enumeration
            if (user == null || !user.IsActive)
            {
                Log.Information("Password reset requested for unknown/inactive email: {Email}", email);
                await _activityService.TrackAsync(
                    ActivityActions.PasswordResetRequested,
                    description: "Password reset request - email not found or inactive",
                    metadata: new { email, found = false });
                return response;
            }

            // Generate password reset token
            var resetToken = await _userManager.GeneratePasswordResetTokenAsync(user);

            // In a production system with email, you would send this via email
            // For this closed system, we return it for admin distribution
            response.ResetToken = resetToken;

            await _activityService.TrackAsync(
                ActivityActions.PasswordResetRequested,
                userId: user.Id,
                description: "Password reset token generated",
                metadata: new { email, tokenGenerated = true });

            Log.Information("Password reset token generated for: {Email}", email);

            return response;
        }

        /// <inheritdoc />
        public async Task<ResetPasswordResponseDto> ResetPasswordAsync(string email, string resetToken, string newPassword)
        {
            var user = await _userManager.FindByEmailAsync(email);

            if (user == null)
            {
                Log.Warning("Password reset attempted for non-existent email: {Email}", email);
                await _activityService.TrackAsync(
                    ActivityActions.PasswordResetFailed,
                    description: "Password reset failed - user not found",
                    metadata: new { email, reason = "UserNotFound" });

                return new ResetPasswordResponseDto
                {
                    Success = false,
                    Message = "Password reset failed. Please verify your email and token."
                };
            }

            if (!user.IsActive)
            {
                Log.Warning("Password reset attempted for inactive user: {Email}", email);
                await _activityService.TrackAsync(
                    ActivityActions.PasswordResetFailed,
                    userId: user.Id,
                    description: "Password reset failed - account inactive",
                    metadata: new { email, reason = "AccountInactive" });

                return new ResetPasswordResponseDto
                {
                    Success = false,
                    Message = "Password reset failed. Your account is not active."
                };
            }

            var result = await _userManager.ResetPasswordAsync(user, resetToken, newPassword);

            if (!result.Succeeded)
            {
                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                Log.Warning("Password reset failed for {Email}: {Errors}", email, errors);
                await _activityService.TrackAsync(
                    ActivityActions.PasswordResetFailed,
                    userId: user.Id,
                    description: "Password reset failed",
                    metadata: new { email, errors });

                return new ResetPasswordResponseDto
                {
                    Success = false,
                    Message = "Password reset failed. " + errors
                };
            }

            // Ensure account is marked as activated after password reset
            if (!user.IsActivated)
            {
                user.IsActivated = true;
                user.UpdatedAt = DateTime.UtcNow;
                await _userManager.UpdateAsync(user);
            }

            await _activityService.TrackAsync(
                ActivityActions.PasswordResetCompleted,
                userId: user.Id,
                description: "Password reset completed successfully",
                metadata: new { email });

            Log.Information("Password reset completed successfully for: {Email}", email);

            return new ResetPasswordResponseDto
            {
                Success = true,
                Message = "Password has been reset successfully."
            };
        }

        #endregion

        #region Private Helpers

        private static UserProfileDto MapToUserProfile(ApplicationUser user, string role, StudentProfile? profile = null)
        {
            var dto = new UserProfileDto
            {
                Id = user.Id,
                Email = user.Email ?? "",
                FullName = user.FullName,
                Role = role,
                NationalId = user.NationalId,
                DateOfBirth = user.DateOfBirth,
                Gender = user.Gender,
                City = user.City,
                ProfileImageUrl = user.ProfileImageUrl,
                AccountStatus = AccountStatus.Compute(user.IsActive, user.IsActivated),
                CreatedAt = user.CreatedAt,
                LastLoginAt = user.LastLoginAt
            };

            // Polymorphic: Only populate AcademicInfo for Students with a profile
            if (role == Roles.Student && profile != null)
            {
                dto.AcademicInfo = new SkyLearnApi.DTOs.Users.AcademicInfoDto
                {
                    Department = new SkyLearnApi.DTOs.Users.EntityRefDto
                    {
                        Id = profile.DepartmentId,
                        Name = profile.Department?.Name ?? ""
                    },
                    Year = new SkyLearnApi.DTOs.Users.EntityRefDto
                    {
                        Id = profile.YearId,
                        Name = profile.Year?.Name ?? ""
                    },
                    Squadron = new SkyLearnApi.DTOs.Users.EntityRefDto
                    {
                        Id = profile.SquadronId,
                        Name = profile.Squadron?.Name ?? ""
                    },
                    AdmissionYear = profile.AdmissionYear
                };
            }

            return dto;
        }

        #endregion
    }
}
