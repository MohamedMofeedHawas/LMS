namespace SkyLearnApi.Services.Implementations
{
    public class CourseService : ICourseService
    {
        private readonly AppDbContext _context;
        private readonly IMapper _mapper;
        private readonly IWebHostEnvironment _env;

        public CourseService(AppDbContext context, IMapper mapper, IWebHostEnvironment env)
        {
            _context = context;
            _mapper = mapper;
            _env = env;
        }

        public async Task<IEnumerable<CourseResponseDto>> GetAllAsync(
            string? search, int? departmentId, int? yearId,
            DateTime? startDate, DateTime? endDate,
            int page = 1, int pageSize = 9)
        {
            var query = _context.Courses
                .Include(c => c.Department)
                .Include(c => c.Year)
                .Include(c => c.CreatedBy)
                .AsQueryable();

            if (departmentId.HasValue)
                query = query.Where(c => c.DepartmentId == departmentId.Value);

            if (yearId.HasValue)
                query = query.Where(c => c.YearId == yearId.Value);

            //Null-safe search 
            if (!string.IsNullOrWhiteSpace(search))
            {
                query = query.Where(c =>
                    c.Title.Contains(search) ||
                    (c.Description != null && c.Description.Contains(search)));
            }

            if (startDate.HasValue)
                query = query.Where(c => c.CreatedAt >= startDate.Value);

            if (endDate.HasValue)
                query = query.Where(c => c.CreatedAt <= endDate.Value);

            var courses = await query
                .OrderByDescending(c => c.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return _mapper.Map<IEnumerable<CourseResponseDto>>(courses);
        }

        public async Task<CourseResponseDto?> GetByIdAsync(int id)
        {
            var course = await _context.Courses
                .Include(c => c.Department)
                .Include(c => c.Year)
                .Include(c => c.CreatedBy)
                .FirstOrDefaultAsync(c => c.Id == id);

            return course == null ? null : _mapper.Map<CourseResponseDto>(course);
        }

        public async Task<CourseResponseDto> CreateAsync(CourseRequestDto dto, int userId)
        {
            if (!await _context.Departments.AnyAsync(d => d.Id == dto.DepartmentId))
                throw new ArgumentException("Invalid DepartmentId.");

            if (!await _context.Years.AnyAsync(y => y.Id == dto.YearId))
                throw new ArgumentException("Invalid YearId.");

            var course = _mapper.Map<Course>(dto);
            course.CreatedById = userId;

            if (dto.ImageFile != null)
            {
                if (string.IsNullOrEmpty(_env.WebRootPath))
                    throw new InvalidOperationException("WebRootPath is not configured.");

                var uploadsFolder = Path.Combine(_env.WebRootPath, "uploads", "courses");
                Directory.CreateDirectory(uploadsFolder);

                var fileName = $"{Guid.NewGuid()}_{dto.ImageFile.FileName}";
                var filePath = Path.Combine(uploadsFolder, fileName);

                using var stream = new FileStream(filePath, FileMode.Create);
                await dto.ImageFile.CopyToAsync(stream);

                course.ImageUrl = $"/uploads/courses/{fileName}";
            }

            _context.Courses.Add(course);
            await _context.SaveChangesAsync();

            await UpdateYearTotalsAsync(course.YearId);

            return _mapper.Map<CourseResponseDto>(course);
        }

        public async Task<CourseResponseDto?> UpdateAsync(int id, CourseRequestDto dto, int userId)
        {
            var course = await _context.Courses.FindAsync(id);
            if (course == null)
                return null;

            if (course.CreatedById != userId)
                throw new UnauthorizedAccessException("You are not allowed to update this course.");

            if (dto.DepartmentId != course.DepartmentId &&
                !await _context.Departments.AnyAsync(d => d.Id == dto.DepartmentId))
                throw new ArgumentException("Invalid DepartmentId.");

            if (dto.YearId != course.YearId &&
                !await _context.Years.AnyAsync(y => y.Id == dto.YearId))
                throw new ArgumentException("Invalid YearId.");

            var oldYearId = course.YearId;

            _mapper.Map(dto, course);
            course.UpdatedAt = DateTime.UtcNow;

            if (dto.ImageFile != null)
            {
                if (string.IsNullOrEmpty(_env.WebRootPath))
                    throw new InvalidOperationException("WebRootPath is not configured.");

                var uploadsFolder = Path.Combine(_env.WebRootPath, "uploads", "courses");
                Directory.CreateDirectory(uploadsFolder);

                var fileName = $"{Guid.NewGuid()}_{dto.ImageFile.FileName}";
                var filePath = Path.Combine(uploadsFolder, fileName);

                using var stream = new FileStream(filePath, FileMode.Create);
                await dto.ImageFile.CopyToAsync(stream);

                course.ImageUrl = $"/uploads/courses/{fileName}";
            }

            await _context.SaveChangesAsync();

            await UpdateYearTotalsAsync(course.YearId);
            if (oldYearId != course.YearId)
                await UpdateYearTotalsAsync(oldYearId);

            return _mapper.Map<CourseResponseDto>(course);
        }

        public async Task<bool> DeleteAsync(int id, int userId)
        {
            var course = await _context.Courses.FindAsync(id);
            if (course == null)
                return false;

            if (course.CreatedById != userId)
                throw new UnauthorizedAccessException("You are not allowed to delete this course.");

            var yearId = course.YearId;

            _context.Courses.Remove(course);
            await _context.SaveChangesAsync();

            await UpdateYearTotalsAsync(yearId);

            return true;
        }

        private async Task UpdateYearTotalsAsync(int yearId)
        {
            var totalCourses = await _context.Courses.CountAsync(c => c.YearId == yearId);
            var totalHours = await _context.Courses
                .Where(c => c.YearId == yearId)
                .Select(c => (int?)c.CreditHours)
                .SumAsync() ?? 0;

            var year = await _context.Years.FindAsync(yearId);
            if (year != null)
            {
                year.TotalCourses = totalCourses;
                year.TotalHours = totalHours;
                await _context.SaveChangesAsync();
            }
        }
    }
}
