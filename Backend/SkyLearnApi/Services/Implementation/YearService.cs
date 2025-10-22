using Microsoft.EntityFrameworkCore;
using SkyLearnApi.Data;
using SkyLearnApi.Dtos.Year;
using SkyLearnApi.Entities;
using SkyLearnApi.Services.Interfaces;
using Mapster;

namespace SkyLearnApi.Services
{
    public class YearService : IYearService
    {
        private readonly AppDbContext _db;

        public YearService(AppDbContext db)
        {
            _db = db;
        }

        // Get a single Year by its Id
        public async Task<YearResponseDto?> GetByIdAsync(int id)
        {
            var year = await _db.Years
                .Include(y => y.Department)
                .Include(y => y.CreatedBy)
                .FirstOrDefaultAsync(y => y.Id == id);

            return year?.Adapt<YearResponseDto>();
        }

        // Get all Years that belong to a specific Department
        public async Task<IEnumerable<YearResponseDto>> GetByDepartmentIdAsync(int departmentId)
        {
            var years = await _db.Years
                .Where(y => y.DepartmentId == departmentId)
                .Include(y => y.Department)
                .Include(y => y.CreatedBy)
                .ToListAsync();

            return years.Adapt<IEnumerable<YearResponseDto>>();
        }

        // ✅ Create a new Year (CreatedById is set here, not from request)
        public async Task<YearResponseDto> CreateAsync(YearRequestDto dto, string userId)
        {
            var year = dto.Adapt<Year>();
            year.CreatedById = int.Parse(userId); // convert userId from string to int
            year.CreatedAt = DateTime.UtcNow;
            year.UpdatedAt = DateTime.UtcNow;

            // Default values
            year.TotalHours = 0;
            year.TotalCourses = 0;

            _db.Years.Add(year);
            await _db.SaveChangesAsync();

            // Load navigation properties after save
            await _db.Entry(year).Reference(y => y.Department).LoadAsync();
            await _db.Entry(year).Reference(y => y.CreatedBy).LoadAsync();

            return year.Adapt<YearResponseDto>();
        }

        // ✅ Update an existing Year (TotalHours is not modified here)
        public async Task<YearResponseDto?> UpdateAsync(int id, YearRequestDto dto, string userId)
        {
            var year = await _db.Years.FindAsync(id);
            if (year == null) return null;

            year.Name = dto.Name;
            year.Description = dto.Description;
            year.DepartmentId = dto.DepartmentId;
            year.StartDate = dto.StartDate;
            year.EndDate = dto.EndDate;
            year.UpdatedAt = DateTime.UtcNow;

            await _db.SaveChangesAsync();

            // Reload navigation properties
            await _db.Entry(year).Reference(y => y.Department).LoadAsync();
            await _db.Entry(year).Reference(y => y.CreatedBy).LoadAsync();

            return year.Adapt<YearResponseDto>();
        }


        public async Task<bool> DeleteAsync(int id, string userId)
        {
            var year = await _db.Years.FindAsync(id);
            if (year == null) return false;

            // Check directly in Courses table
            bool hasCourses = await _db.Courses.AnyAsync(c => c.YearId == id);
            if (hasCourses)
                throw new InvalidOperationException("Cannot delete this year because it has courses.");

            _db.Years.Remove(year);
            await _db.SaveChangesAsync();
            return true;
        }

    }
}
