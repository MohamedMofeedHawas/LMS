namespace SkyLearnApi.Services
{     
    /// Service interface for Admin-only user management operations
    /// All methods in this service should only be called by Admin users 
    public interface IUserService
    {
        Task<PagedUsersResponseDto> GetAllUsersAsync(UserFilterParams filterParams);
        Task<UserResponseDto?> GetUserByIdAsync(int userId);
        Task<(UserResponseDto? User, string? Error)> CreateUserAsync(CreateUserDto dto);
        Task<(UserResponseDto? User, string? Error)> UpdateUserAsync(int userId, UpdateUserDto dto);        Task<(bool Success, string? Error)> DeleteUserAsync(int userId, bool hardDelete = false);
    }
}