using SkyLearnApi.Dtos;

namespace SkyLearnApi.Services
{
    public interface IAuthService
    {
        Task<AuthResponseDto?> LoginAsync(string email, string password);
        Task LogoutAsync(string token);
    }
}
