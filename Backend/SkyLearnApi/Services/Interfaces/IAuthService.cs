using System.Threading.Tasks;

namespace SkyLearnApi.Services.Interfaces
{
    public interface IAuthService
{
    Task<string?> LoginAsync(string email, string password); 
    Task LogoutAsync(long userId);
}

}
