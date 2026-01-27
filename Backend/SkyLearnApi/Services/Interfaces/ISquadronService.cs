

namespace SkyLearnApi.Services.Interfaces
{
    public interface ISquadronService
    {
        Task<List<SquadronResponseDto>> GetAllAsync();
        Task<SquadronDetailResponseDto?> GetByIdAsync(int id);
        Task<(SquadronResponseDto? Squadron, string? Error)> CreateAsync(CreateSquadronDto dto);
        Task<(SquadronResponseDto? Squadron, string? Error)> UpdateAsync(int id, UpdateSquadronDto dto);
        Task<(bool Success, string? Error)> DeleteAsync(int id);
    }
}
