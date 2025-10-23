

namespace SkyLearnApi.Services.Interfaces
{
    public interface ICourseService
    {
        Task<IEnumerable<CourseResponseDto>> GetAllAsync(string? search, int? departmentId, int? yearId, DateTime? startDate, DateTime? endDate, int page = 1, int pageSize = 9);
        Task<CourseResponseDto?> GetByIdAsync(int id);

        Task<CourseResponseDto> CreateAsync(CourseRequestDto dto, int userId);
        Task<CourseResponseDto?> UpdateAsync(int id, CourseRequestDto dto, int userId);
        Task<bool> DeleteAsync(int id, int userId);
    }
}
