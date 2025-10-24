namespace SkyLearnApi.Services;

public interface IUserService
{
    Task SetUserAsActiveAsync(int userId, bool b);
}