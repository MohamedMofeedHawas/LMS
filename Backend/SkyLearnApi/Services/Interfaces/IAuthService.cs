
namespace SkyLearnApi.Services.Interfaces
{
    public interface IAuthService
    {
        Task<AuthResponseDto?> LoginAsync(string email, string password);
        Task LogoutAsync(string token);
    }
}
