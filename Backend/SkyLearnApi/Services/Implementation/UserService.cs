namespace SkyLearnApi.Services;

public class UserService : IUserService
{
    private readonly AppDbContext _dbContext;

    public UserService(AppDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task SetUserAsActiveAsync(int userId, bool b)
    {
        var user = await _dbContext.Users.FirstOrDefaultAsync(e=>e.Id == userId);
        if (user == null)
        {
            return;
        }

        user.IsActive = b;
        await _dbContext.SaveChangesAsync();
    }
}

