using SkyLearnApi.Services.Base;

namespace SkyLearnApi.Services.Implementation
{
    public class AuthService : IAuthService
    {
        private readonly AppDbContext _db;
        private readonly JwtSettings _jwtSettings;
        private readonly IUserService _userService;
        private readonly IAuditService _auditService;

        public AuthService(AppDbContext db, IConfiguration config, IUserService userService, IAuditService auditService)
        {
            _db = db;
            _userService = userService;
            _auditService = auditService;
            _jwtSettings = config.GetSection("Jwt").Get<JwtSettings>() ?? new JwtSettings();
        }

        public async Task<AuthResponseDto?> LoginAsync(string email, string password)
        {
            var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email);
            if (user == null || user.Password != password)
            {
                return null;
            }

            var jti = Guid.NewGuid().ToString();
            var claims = new List<Claim>
            {
                new Claim(SystemClaim.UserId, user.Id.ToString()),
                new Claim(SystemClaim.Email, user.Email),
                new Claim(SystemClaim.Role, user.Role.ToString()),
                new Claim(SystemClaim.Jti, jti),
                new Claim(SystemClaim.GroupName, user.GroupName),
                new Claim(SystemClaim.AcademicYear, user.AcademicYear)
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

            await _auditService.LogAuditAsync(AuditActions.USER_LOGIN, $"", EntityName.Users);


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
                int? userId = int.TryParse(jwt.Claims.FirstOrDefault(c => c.Type == SystemClaim.UserId)?.Value, out var uid) ? uid : null;

                if (userId.HasValue)
                {
                    //await _audit.LogAsync("User Logout", $"Token revoked (jti={jwt.Id})", "Auth", userId, jwt.Id, jwt.ValidTo);

                    await _auditService.LogAuditAsync(AuditActions.USER_LOGOUT, $"", EntityName.Users);


                    // Set User as Active in database
                    await _userService.SetUserAsActiveAsync(userId.Value, false);
                }
            }
            catch
            {
                await _auditService.LogAuditAsync(AuditActions.FAILED_LOGIN, $"", EntityName.Users);
            }
        }
    }
}
