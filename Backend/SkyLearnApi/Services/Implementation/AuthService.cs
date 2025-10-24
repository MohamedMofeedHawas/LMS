namespace SkyLearnApi.Services
{
    public class AuthService : IAuthService
    {
        private readonly AppDbContext _db;
        private readonly JwtSettings _jwtSettings;
        private readonly IAuditService _audit;
        private readonly IUserService _userService;

        public AuthService(AppDbContext db, IConfiguration config, IAuditService audit, IUserService userService)
        {
            _db = db;
            _audit = audit;
            _userService = userService;
            _jwtSettings = config.GetSection("Jwt").Get<JwtSettings>() ?? new JwtSettings();
        }

        public async Task<AuthResponseDto?> LoginAsync(string email, string password)
        {
            var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email);
            if (user == null || user.Password != password)
            {
                await _audit.LogAsync("Failed Login", $"Login failed for {email}", "Auth", user?.Id);
                return null;
            }

            var jti = Guid.NewGuid().ToString();
            var claims = new List<Claim>
            {
                new Claim("UserId", user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti, jti),
                new Claim(nameof(ApplicationUser.GroupName), user.GroupName),
                new Claim(nameof(ApplicationUser.AcademicYear), user.AcademicYear),
            };

            var key = Encoding.UTF8.GetBytes(_jwtSettings.Key);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddMinutes(_jwtSettings.ExpireMinutes),
                Issuer = _jwtSettings.Issuer,
                Audience = _jwtSettings.Audience,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);
            var tokenString = tokenHandler.WriteToken(token);

            //await _audit.LogAsync("User Login", $"User {user.Email} logged in", "Auth", user.Id, jti, tokenDescriptor.Expires);

            await _audit.LogAsync(new AuditLog
            {
                UserId = user.Id,
                Action = "User Login",
                Description = $"User {user.Email} logged in",
                EntityName = "Auth",
                Jti = jti,
                ExpiresAt = tokenDescriptor.Expires,
                CreatedAt = DateTime.UtcNow,
                GroupName = user.GroupName,
                AcademicYear = user.AcademicYear
            });


            // Set User as Active in database
            await _userService.SetUserAsActiveAsync(user.Id, true);

            return new AuthResponseDto
            {
                Token = tokenString,
                ExpiresIn = tokenDescriptor.Expires!.Value,
                User = new UserDto
                {
                    Id = user.Id,
                    FullName = user.FullName,
                    Email = user.Email,
                    Role = user.Role.ToString(),
                    Gender = user.Gender,
                    City = user.City,
                    AcademicYear = user.AcademicYear,
                    ProfileImageUrl = user.ProfileImageUrl
                }
            };
        }

        public async Task LogoutAsync(string token)
        {
            var handler = new JwtSecurityTokenHandler();
            try
            {
                var jwt = handler.ReadJwtToken(token);
                int? userId = int.TryParse(jwt.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value, out var uid) ? uid : null;
                var groupName = jwt.Claims.First(x => x.Type == "GroupName").Value;
                var academicYear = jwt.Claims.First(x => x.Type == "AcademicYear").Value;

                if (userId.HasValue)
                {
                    //await _audit.LogAsync("User Logout", $"Token revoked (jti={jwt.Id})", "Auth", userId, jwt.Id, jwt.ValidTo);

                    await _audit.LogAsync(new AuditLog
                    {
                        UserId = userId,
                        Action = "User Logout",
                        Description = $"Token revoked (jti={jwt.Id})",
                        EntityName = "Auth",
                        Jti = jwt.Id,
                        ExpiresAt = null,
                        CreatedAt = DateTime.UtcNow,
                        GroupName = groupName,
                        AcademicYear = academicYear
                    });


                    // Set User as Active in database
                    await _userService.SetUserAsActiveAsync(userId.Value, false);
                }
            }
            catch
            {
                await _audit.LogAsync("Failed Logout", "Invalid or missing token", "Auth", null);
            }
        }
    }
}
