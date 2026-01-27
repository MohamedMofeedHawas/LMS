

namespace SkyLearnApi.Services
{
     
    /// Service interface for Admin-only user management operations.
    /// All methods in this service should only be called by Admin users.
     
    public interface IUserService
    {
         
        /// Get all users with pagination, filtering, and sorting
         
        Task<PagedUsersResponseDto> GetAllUsersAsync(UserFilterParams filterParams);

         
        /// Get a single user by ID
         
        Task<UserResponseDto?> GetUserByIdAsync(int userId);

         
        /// Create a new user with specified role
         
        Task<(UserResponseDto? User, string? Error)> CreateUserAsync(CreateUserDto dto);

         
        /// Update an existing user
         
        Task<(UserResponseDto? User, string? Error)> UpdateUserAsync(int userId, UpdateUserDto dto);

         
        /// Delete a user (soft delete by setting IsActive = false, or hard delete)
         
        Task<(bool Success, string? Error)> DeleteUserAsync(int userId, bool hardDelete = false);
    }
}