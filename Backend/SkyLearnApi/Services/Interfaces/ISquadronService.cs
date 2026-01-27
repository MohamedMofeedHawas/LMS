

namespace SkyLearnApi.Services.Interfaces
{
    public interface ISquadronService
    {
        /// Get all squadrons with student counts
        Task<List<SquadronResponseDto>> GetAllAsync();

        /// Get single squadron with student list
        Task<SquadronDetailResponseDto?> GetByIdAsync(int id);

        /// Create new squadron (Admin)
        Task<(SquadronResponseDto? Squadron, string? Error)> CreateAsync(CreateSquadronDto dto);

        /// Update squadron (Admin)
        Task<(SquadronResponseDto? Squadron, string? Error)> UpdateAsync(int id, UpdateSquadronDto dto);

        /// Delete squadron (Admin) - Hard delete
        Task<(bool Success, string? Error)> DeleteAsync(int id);
    }
}
