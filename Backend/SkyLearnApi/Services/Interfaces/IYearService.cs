namespace SkyLearnApi.Services.Interfaces
{
    public interface IYearService
    {
        Task<YearResponseDto?> GetByIdAsync(int id);
        
         
        /// Gets a year by ID and validates it belongs to the specified department.

        Task<YearResponseDto?> GetByIdAndDepartmentAsync(int id, int departmentId);        
        Task<IEnumerable<YearResponseDto>> GetByDepartmentIdAsync(int departmentId);
        Task<IEnumerable<YearResponseDto>> GetAllAsync();
        Task<YearResponseDto> CreateAsync(YearRequestDto dto, string userId);
        Task<YearResponseDto?> UpdateAsync(int id, YearRequestDto dto, string userId);
        Task<bool> DeleteAsync(int id, string userId);     
        /// Validates that a year belongs to the specified department.
        Task<bool> ValidateDepartmentOwnershipAsync(int yearId, int departmentId);
    }
}
