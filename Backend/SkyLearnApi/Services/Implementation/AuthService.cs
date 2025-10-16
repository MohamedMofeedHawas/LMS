using Microsoft.EntityFrameworkCore;
using Serilog;
using SkyLearnApi.Data;
using SkyLearnApi.Entities;
using SkyLearnApi.Services.Interfaces;

namespace SkyLearnApi.Services.Implementations
{
    public class AuthService : IAuthService
    {
        private readonly AppDbContext _context;
        private readonly JwtService _jwtService;

        public AuthService(AppDbContext context, JwtService jwtService)
        {
            _context = context;
            _jwtService = jwtService;
        }

        public async Task<string?> LoginAsync(string email, string password)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
            if (user == null)
            {
                Log.Warning("Failed login attempt: invalid email {Email}", email);
                return null;
            }

            
            if (user.Password != password)
            {
                Log.Warning("Failed login attempt: invalid password for {Email}", email);
                return null;
            }

            Log.Information("User {UserId} logged in", user.Id);
            return _jwtService.GenerateToken(user);
        }

        public async Task LogoutAsync(long userId)
        {
            Log.Information("User {UserId} logged out", userId);
            await Task.CompletedTask;
        }
    }
}
