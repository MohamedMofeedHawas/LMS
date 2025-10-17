using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SkyLearnApi.Data;
using SkyLearnApi.Dtos;
using SkyLearnApi.Entities;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

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
            if (user == null)
            {
                await _audit.LogAsync("Failed Login", $"Failed attempt for {email}", "User", null);
                return null;
            }

            // ⚠️ مؤقتًا: مقارنة الباسورد بدون تشفير لتجربة السواجر فقط
            if (user.Password != password)
            {
                await _audit.LogAsync("Failed Login", $"Wrong password for {email}", "User", user.Id);
                return null;
            }

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.UTF8.GetBytes(_jwtSettings.Key);

            var claims = new List<Claim>
            {
                new Claim("UserId", user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role.ToString())
            };

            var jti = Guid.NewGuid().ToString();
            claims.Add(new Claim(JwtRegisteredClaimNames.Jti, jti));

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddMinutes(_jwtSettings.ExpireMinutes),
                Issuer = _jwtSettings.Issuer,
                Audience = _jwtSettings.Audience,
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(key),
                    SecurityAlgorithms.HmacSha256Signature
                )
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            var tokenString = tokenHandler.WriteToken(token);

            // Log successful login
            await _audit.LogAsync(
                "User Login",
                $"User {user.Email} logged in",
                "Auth",
                user.Id,
                jti,
                tokenDescriptor.Expires
            );

            return new AuthResponseDto
            {
                Token = tokenString,
                ExpiresAt = tokenDescriptor.Expires!.Value
            };
        }

        public async Task LogoutAsync(string token)
        {
            var handler = new JwtSecurityTokenHandler();
            JwtSecurityToken? jwt = null;
            try
            {
                jwt = handler.ReadJwtToken(token);
            }
            catch
            {
                // invalid token
            }

            if (jwt != null)
            {
                var jti = jwt.Id;
                var exp = jwt.ValidTo;
                int? userId = null;
                var userIdClaim = jwt.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value;
                if (int.TryParse(userIdClaim, out var uid)) userId = uid;

                await _audit.LogAsync("RevokeToken", $"Token revoked (jti={jti})", "Auth", userId, jti, exp);
            }
            else
            {
                await _audit.LogAsync("RevokeToken", "Logout attempted with invalid token", "Auth", null, null, null);
            }
        }
    }
}
