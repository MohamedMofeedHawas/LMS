

namespace SkyLearnApi.Services.Interfaces
{
    public interface IYearService
    {
        Task<YearResponseDto?> GetByIdAsync(int id);
        Task<IEnumerable<YearResponseDto>> GetByDepartmentIdAsync(int departmentId);
        Task<YearResponseDto> CreateAsync(YearRequestDto dto, string userId);
        Task<YearResponseDto?> UpdateAsync(int id, YearRequestDto dto, string userId);
        Task<bool> DeleteAsync(int id, string userId);
    }
}
