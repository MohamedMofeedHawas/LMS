namespace SkyLearnApi.Services
{
    public class AuthService : IAuthService
    {
        private readonly AppDbContext _db;
        private readonly JwtSettings _jwtSettings;
        private readonly AuditService _audit;

        public AuthService(AppDbContext db, IConfiguration config, AuditService audit)
        {
            _db = db;
            _audit = audit;
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
                new Claim(JwtRegisteredClaimNames.Jti, jti)
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

            await _audit.LogAsync("User Login", $"User {user.Email} logged in", "Auth", user.Id, jti, tokenDescriptor.Expires);

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
                    AcademicLevel = user.AcademicLevel,
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

                await _audit.LogAsync("User Logout", $"Token revoked (jti={jwt.Id})", "Auth", userId, jwt.Id, jwt.ValidTo);
            }
            catch
            {
                await _audit.LogAsync("Failed Logout", "Invalid or missing token", "Auth", null);
            }
        }
    }
}
