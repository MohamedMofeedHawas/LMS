

namespace SkyLearnApi.Services.Interfaces
{
     
    /// JWT token generation and management service interface.
     
    public interface IJwtService
    {
        Task<JwtTokenResult> GenerateTokenAsync(ApplicationUser user);
        JwtTokenInfo? ParseToken(string token);
    }

     
    /// Result of JWT token generation.
     
    public class JwtTokenResult
    {
        public string Token { get; set; } = string.Empty;
        public string Jti { get; set; } = string.Empty;
        public DateTime ExpiresAt { get; set; }
    }
    /// Parsed JWT token information.
     
    public class JwtTokenInfo
    {
        public int? UserId { get; set; }
        public string? Jti { get; set; }
        public DateTime ExpiresAt { get; set; }
        public IEnumerable<string> Roles { get; set; } = Enumerable.Empty<string>();
    }
}
