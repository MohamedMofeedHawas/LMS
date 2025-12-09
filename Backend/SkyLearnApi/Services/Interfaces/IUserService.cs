namespace SkyLearnApi.Services.Interfaces;

public interface IUserService
{
    Task SetUserAsActiveAsync(int userId, bool b);
}