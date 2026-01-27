namespace SkyLearnApi.Services.Implementation
{
    public class YearService : IYearService
    {
        private readonly AppDbContext _db;

        public YearService(AppDbContext db)
        {
            _db = db;
        }
        public async Task<YearResponseDto?> GetByIdAsync(int id)
        {
            var year = await _db.Years
                .Include(y => y.Department)
                .Include(y => y.CreatedBy)
                .FirstOrDefaultAsync(y => y.Id == id);

            return year?.Adapt<YearResponseDto>();
        }
        ///Gets a year and validates it belongs to the specified department.
        public async Task<YearResponseDto?> GetByIdAndDepartmentAsync(int id, int departmentId)
        {
            var year = await _db.Years
                .Include(y => y.Department)
                .Include(y => y.CreatedBy)
                .FirstOrDefaultAsync(y => y.Id == id && y.DepartmentId == departmentId);

            return year?.Adapt<YearResponseDto>();
        }

         
        ////////////Validates that a year belongs to the specified department.
         
        public async Task<bool> ValidateDepartmentOwnershipAsync(int yearId, int departmentId)
        {
            return await _db.Years.AnyAsync(y => y.Id == yearId && y.DepartmentId == departmentId);
        }

        public async Task<IEnumerable<YearResponseDto>> GetByDepartmentIdAsync(int departmentId)
        {
            bool departmentExists =
                await _db.Departments.AnyAsync(d => d.Id == departmentId);

            if (!departmentExists)
                throw new KeyNotFoundException("Department not found");

            var years = await _db.Years
                .Where(y => y.DepartmentId == departmentId)
                .Include(y => y.Department)
                .Include(y => y.CreatedBy)
                .ToListAsync();

            return years.Adapt<IEnumerable<YearResponseDto>>();
        }
        public async Task<IEnumerable<YearResponseDto>> GetAllAsync()
        {
            var years = await _db.Years
                .Include(y => y.Department)
                .Include(y => y.CreatedBy)
                .ToListAsync();

            return years.Adapt<IEnumerable<YearResponseDto>>();
        }
        public async Task<YearResponseDto> CreateAsync(YearRequestDto dto, string userId)
        {
            if (!int.TryParse(userId, out int parsedUserId))
                throw new UnauthorizedAccessException("Invalid user token");

            var department = await _db.Departments.FirstOrDefaultAsync(d => d.Name == dto.DepartmentName);

            if (department == null)
                throw new KeyNotFoundException($"Department '{dto.DepartmentName}' not found");

            var year = dto.Adapt<Year>();
            year.CreatedById = parsedUserId;
            year.CreatedAt = DateTime.UtcNow;
            year.UpdatedAt = DateTime.UtcNow;
            year.TotalCourses = 0;
            year.TotalHours = 0;

            year.DepartmentId = department.Id;

            _db.Years.Add(year);
            await _db.SaveChangesAsync();

            await _db.Entry(year).Reference(y => y.Department).LoadAsync();
            await _db.Entry(year).Reference(y => y.CreatedBy).LoadAsync();

            return year.Adapt<YearResponseDto>();
        }

        public async Task<YearResponseDto?> UpdateAsync(int id, YearRequestDto dto, string userId)
        {
            var year = await _db.Years.FindAsync(id);
            if (year == null) return null;

            // Validate department if being changed
            if (year.Department == null) 
                 await _db.Entry(year).Reference(y => y.Department).LoadAsync();

            if (year.Department.Name != dto.DepartmentName)
            {
                 var department = await _db.Departments.FirstOrDefaultAsync(d => d.Name == dto.DepartmentName);
                 if (department == null)
                     throw new KeyNotFoundException($"Department '{dto.DepartmentName}' not found");
                 
                 year.DepartmentId = department.Id;
            }

            year.Name = dto.Name;
            year.Description = dto.Description;
            // DepartmentId already updated above if needed
            year.StartDate = dto.StartDate;
            year.EndDate = dto.EndDate;
            year.UpdatedAt = DateTime.UtcNow;

            await _db.SaveChangesAsync();

            await _db.Entry(year).Reference(y => y.Department).LoadAsync();
            await _db.Entry(year).Reference(y => y.CreatedBy).LoadAsync();

            return year.Adapt<YearResponseDto>();
        }

        public async Task<bool> DeleteAsync(int id, string userId)
        {
            var year = await _db.Years.FindAsync(id);
            if (year == null) return false;

            bool hasCourses =
                await _db.Courses.AnyAsync(c => c.YearId == id);

            if (hasCourses)
                throw new InvalidOperationException(
                    "Cannot delete this year because it has courses.");

            _db.Years.Remove(year);
            await _db.SaveChangesAsync();
            return true;
        }
    }
}
