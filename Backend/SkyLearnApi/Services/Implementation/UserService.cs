namespace SkyLearnApi.Services.Implementation
{
    /// Service for Admin-only user management operations.
    /// Handles CRUD operations on ApplicationUser entities
    public class UserService : IUserService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly RoleManager<IdentityRole<int>> _roleManager;
        private readonly IActivityService _activityService;
        private readonly AppDbContext _dbContext;

        public UserService(
            UserManager<ApplicationUser> userManager,
            RoleManager<IdentityRole<int>> roleManager,
            IActivityService activityService,
            AppDbContext dbContext)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _activityService = activityService;
            _dbContext = dbContext;
        }

        public async Task<PagedUsersResponseDto> GetAllUsersAsync(UserFilterParams filterParams)
        {   var query = _dbContext.Users.AsNoTracking().AsQueryable();

            // Apply search filter
            if (!string.IsNullOrWhiteSpace(filterParams.Search))
            {
                var searchLower = filterParams.Search.ToLower();
                query = query.Where(u =>
                    u.FullName.ToLower().Contains(searchLower) ||
                    (u.Email != null && u.Email.ToLower().Contains(searchLower)));
            }

            // Apply active status filter
            if (filterParams.IsActive.HasValue)
            {
                query = query.Where(u => u.IsActive == filterParams.IsActive.Value);
            }

            // Apply role filter using a subquery
            if (!string.IsNullOrWhiteSpace(filterParams.Role))
            {
                var roleId = await _dbContext.Roles
                    .Where(r => r.Name == filterParams.Role)
                    .Select(r => r.Id)
                    .FirstOrDefaultAsync();

                if (roleId != 0)
                {
                    var userIdsWithRole = _dbContext.UserRoles
                        .Where(ur => ur.RoleId == roleId)
                        .Select(ur => ur.UserId);

                    query = query.Where(u => userIdsWithRole.Contains(u.Id));
                }
                else
                {
                    // Role doesn't exist, return empty result
                    return new PagedUsersResponseDto
                    {
                        Users = new List<UserResponseDto>(),
                        TotalCount = 0,
                        PageNumber = filterParams.PageNumber,
                        PageSize = filterParams.PageSize
                    };
                }
            }

            // Get total count before pagination
            var totalCount = await query.CountAsync();

            // Apply sorting
            query = ApplySorting(query, filterParams.SortBy, filterParams.SortDirection);
            // Apply pagination
            var users = await query
                .Skip((filterParams.PageNumber - 1) * filterParams.PageSize)
                .Take(filterParams.PageSize)
                .ToListAsync();

            // Batch load roles for all users in a single query
            var userIds = users.Select(u => u.Id).ToList();
            var userRolesDict = await GetUserRolesDictionaryAsync(userIds);

            // Batch load student profiles for students (polymorphic response)
            var studentProfiles = await _dbContext.StudentProfiles
                .AsNoTracking()
                .Include(sp => sp.Department)
                .Include(sp => sp.Year)
                .Include(sp => sp.Squadron)
                .Where(sp => userIds.Contains(sp.UserId))
                .ToDictionaryAsync(sp => sp.UserId);

            // Map to response DTOs
            var userDtos = users.Select(user =>
            {
                var role = userRolesDict.TryGetValue(user.Id, out var roles) 
                    ? roles.FirstOrDefault() ?? "" 
                    : "";
                studentProfiles.TryGetValue(user.Id, out var profile);
                return MapToResponseDto(user, role, profile);
            }).ToList();

            return new PagedUsersResponseDto
            {
                Users = userDtos,
                TotalCount = totalCount,
                PageNumber = filterParams.PageNumber,
                PageSize = filterParams.PageSize
            };
        }

        public async Task<UserResponseDto?> GetUserByIdAsync(int userId)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null) return null;

            var roles = await _userManager.GetRolesAsync(user);
            var role = roles.FirstOrDefault() ?? "";

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

            return MapToResponseDto(user, role, profile);
        }

        public async Task<(UserResponseDto? User, string? Error)> CreateUserAsync(CreateUserDto dto)
        {
            // Check if email already exists
            var existingUser = await _userManager.FindByEmailAsync(dto.Email);
            if (existingUser != null)
            {
                return (null, "A user with this email already exists");
            }

            // Validate role
            if (!await _roleManager.RoleExistsAsync(dto.Role))
            {
                return (null, $"Role '{dto.Role}' does not exist. Valid roles: Admin, Instructor, Student");
            }

            var user = new ApplicationUser
            {
                UserName = dto.Email,
                Email = dto.Email,
                FullName = dto.FullName,
                NationalId = dto.NationalId,
                DateOfBirth = dto.DateOfBirth,
                Gender = dto.Gender,
                City = dto.City,
                ProfileImageUrl = dto.ProfileImageUrl,
                IsActive = dto.IsActive,
                EmailConfirmed = true, // Trusted - entered by Admin
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };
            //Create user WITHOUT password
            //Users set their own password during first-time activation
            //This ensures Admins NEVER know user passwords
            var createResult = await _userManager.CreateAsync(user);
            if (!createResult.Succeeded)
            {
                var errors = string.Join(", ", createResult.Errors.Select(e => e.Description));
                return (null, $"Failed to create user: {errors}");
            }

            var roleResult = await _userManager.AddToRoleAsync(user, dto.Role);
            if (!roleResult.Succeeded)
            {
                await _userManager.DeleteAsync(user);
                var errors = string.Join(", ", roleResult.Errors.Select(e => e.Description));
                return (null, $"Failed to assign role: {errors}");
            }

            // Use IActivityService interface
            await _activityService.TrackEntityActionAsync(
                ActivityActions.UserCreated,
                "User",
                user.Id,
                description: $"Admin created user {user.Email} with role {dto.Role} (pending activation)",
                metadata: new { role = dto.Role, email = user.Email, pendingActivation = true });

            Log.Information("User created by Admin: {Email} with role {Role} (pending activation)", 
                user.Email, dto.Role);

            return (MapToResponseDto(user, dto.Role), null);
        }

        public async Task<(UserResponseDto? User, string? Error)> UpdateUserAsync(int userId, UpdateUserDto dto)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null)
            {
                return (null, "User not found");
            }

            // Check email uniqueness if changing email
            if (!string.IsNullOrWhiteSpace(dto.Email) && dto.Email != user.Email)
            {
                var existingUser = await _userManager.FindByEmailAsync(dto.Email);
                if (existingUser != null)
                {
                    return (null, "A user with this email already exists");
                }
                user.Email = dto.Email;
                user.UserName = dto.Email;
            }

            // Update properties
            if (!string.IsNullOrWhiteSpace(dto.FullName))
                user.FullName = dto.FullName;
            if (dto.NationalId != null)
                user.NationalId = dto.NationalId;
            if (dto.DateOfBirth.HasValue)
                user.DateOfBirth = dto.DateOfBirth;
            if (dto.Gender != null)
                user.Gender = dto.Gender;
            if (dto.City != null)
                user.City = dto.City;
            if (dto.ProfileImageUrl != null)
                user.ProfileImageUrl = dto.ProfileImageUrl;
            if (dto.IsActive.HasValue)
                user.IsActive = dto.IsActive.Value;

            user.UpdatedAt = DateTime.UtcNow;

            var updateResult = await _userManager.UpdateAsync(user);
            if (!updateResult.Succeeded)
            {
                var errors = string.Join(", ", updateResult.Errors.Select(e => e.Description));
                return (null, $"Failed to update user: {errors}");
            }

            // BUSINESS RULE: Admins CANNOT change user passwords
            // Password management is user-controlled via:
            // - /api/auth/activate-account (first-time setup)
            // - /api/auth/reset-password (password recovery)

            // Update role if provided
            if (!string.IsNullOrWhiteSpace(dto.Role))
            {
                if (!await _roleManager.RoleExistsAsync(dto.Role))
                {
                    return (null, $"Role '{dto.Role}' does not exist");
                }

                var currentRoles = await _userManager.GetRolesAsync(user);
                if (!currentRoles.Contains(dto.Role))
                {
                    await _userManager.RemoveFromRolesAsync(user, currentRoles);
                    await _userManager.AddToRoleAsync(user, dto.Role);
                }
            }

            await _activityService.TrackEntityActionAsync(
                ActivityActions.UserUpdated,
                "User",
                user.Id,
                description: $"Admin updated user {user.Email}");

            var roles = await _userManager.GetRolesAsync(user);
            return (MapToResponseDto(user, roles.FirstOrDefault() ?? ""), null);
        }

        public async Task<(bool Success, string? Error)> DeleteUserAsync(int userId, bool hardDelete = false)
        {
            var user = await _userManager.FindByIdAsync(userId.ToString());
            if (user == null)
            {
                return (false, "User not found");
            }

            var userEmail = user.Email;

            if (hardDelete)
            {
                var deleteResult = await _userManager.DeleteAsync(user);
                if (!deleteResult.Succeeded)
                {
                    var errors = string.Join(", ", deleteResult.Errors.Select(e => e.Description));
                    return (false, $"Failed to delete user: {errors}");
                }

                await _activityService.TrackEntityActionAsync(
                    ActivityActions.UserDeleted,
                    "User",
                    userId,
                    description: $"Admin permanently deleted user {userEmail}");
            }
            else
            {
                user.IsActive = false;
                user.UpdatedAt = DateTime.UtcNow;

                var updateResult = await _userManager.UpdateAsync(user);
                if (!updateResult.Succeeded)
                {
                    var errors = string.Join(", ", updateResult.Errors.Select(e => e.Description));
                    return (false, $"Failed to deactivate user: {errors}");
                }

                await _activityService.TrackEntityActionAsync(
                    ActivityActions.UserDeactivated,
                    "User",
                    userId,
                    description: $"Admin deactivated user {userEmail}");
            }

            return (true, null);
        }

        private async Task<Dictionary<int, List<string>>> GetUserRolesDictionaryAsync(List<int> userIds)
        {
            var userRoles = await (
                from ur in _dbContext.UserRoles
                join r in _dbContext.Roles on ur.RoleId equals r.Id
                where userIds.Contains(ur.UserId)
                select new { ur.UserId, RoleName = r.Name ?? "" }
            ).ToListAsync();

            return userRoles
                .GroupBy(x => x.UserId)
                .ToDictionary(
                    g => g.Key,
                    g => g.Select(x => x.RoleName).ToList());
        }

        private static IQueryable<ApplicationUser> ApplySorting(
            IQueryable<ApplicationUser> query,
            string sortBy,
            string sortDirection)
        {
            var isDescending = sortDirection.Equals("desc", StringComparison.OrdinalIgnoreCase);

            return sortBy.ToLower() switch
            {
                "fullname" => isDescending
                    ? query.OrderByDescending(u => u.FullName)
                    : query.OrderBy(u => u.FullName),
                "email" => isDescending
                    ? query.OrderByDescending(u => u.Email)
                    : query.OrderBy(u => u.Email),
                "lastloginat" => isDescending
                    ? query.OrderByDescending(u => u.LastLoginAt)
                    : query.OrderBy(u => u.LastLoginAt),
                _ => isDescending
                    ? query.OrderByDescending(u => u.CreatedAt)
                    : query.OrderBy(u => u.CreatedAt)
            };
        }

        private static UserResponseDto MapToResponseDto(ApplicationUser user, string role, StudentProfile? profile = null)
        {
            var dto = new UserResponseDto
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
                EmailConfirmed = user.EmailConfirmed,
                CreatedAt = user.CreatedAt,
                UpdatedAt = user.UpdatedAt,
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
    }
}
