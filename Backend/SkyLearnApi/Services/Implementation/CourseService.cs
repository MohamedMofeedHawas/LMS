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

            // Get enrolled student counts for these courses
            // Students are automatically enrolled in all courses of their academic year
            var yearIds = courses.Select(c => c.YearId).Distinct().ToList();
            var enrollmentCounts = await _context.StudentProfiles
                .Where(sp => yearIds.Contains(sp.YearId))
                .GroupBy(sp => sp.YearId)
                .Select(g => new { YearId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.YearId, x => x.Count);

            return courses.Select(c => new CourseResponseDto
            {
                Id = c.Id,
                Title = c.Title,
                Description = c.Description,
                DepartmentId = c.DepartmentId,
                DepartmentName = c.Department.Name,
                YearId = c.YearId,
                YearName = c.Year.Name,
                CreditHours = c.CreditHours,
                EnrolledStudentsCount = enrollmentCounts.GetValueOrDefault(c.YearId, 0),
                ImageUrl = c.ImageUrl,
                InstructorId = c.CreatedById,
                InstructorName = c.CreatedBy.FullName,
                CreatedAt = c.CreatedAt,
                UpdatedAt = c.UpdatedAt
            });
        }

        public async Task<CourseResponseDto?> GetByIdAsync(int id)
        {
            var course = await _context.Courses
                .Include(c => c.Department)
                .Include(c => c.Year)
                .Include(c => c.CreatedBy)
                .FirstOrDefaultAsync(c => c.Id == id);

            if (course == null) return null;

            // Students are automatically enrolled in all courses of their academic year
            var enrolledCount = await _context.StudentProfiles.CountAsync(sp => sp.YearId == course.YearId);

            return new CourseResponseDto
            {
                Id = course.Id,
                Title = course.Title,
                Description = course.Description,
                DepartmentId = course.DepartmentId,
                DepartmentName = course.Department.Name,
                YearId = course.YearId,
                YearName = course.Year.Name,
                CreditHours = course.CreditHours,
                EnrolledStudentsCount = enrolledCount,
                ImageUrl = course.ImageUrl,
                InstructorId = course.CreatedById,
                InstructorName = course.CreatedBy.FullName,
                CreatedAt = course.CreatedAt,
                UpdatedAt = course.UpdatedAt
            };
        }

        public async Task<CourseResponseDto> CreateAsync(CourseRequestDto dto, int userId)
        {
            var department = await _context.Departments
                .FirstOrDefaultAsync(d => d.Name == dto.DepartmentName);
            if (department == null)
                throw new ArgumentException($"Department '{dto.DepartmentName}' not found.");

            var year = await _context.Years
                .FirstOrDefaultAsync(y => y.Name == dto.YearName && y.DepartmentId == department.Id);
            if (year == null)
                throw new ArgumentException($"Year '{dto.YearName}' not found in department '{dto.DepartmentName}'.");

            var course = _mapper.Map<Course>(dto);
            course.DepartmentId = department.Id;
            course.YearId = year.Id;
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

            var instructor = await _context.Users.FindAsync(userId);
            
            return new CourseResponseDto
            {
                Id = course.Id,
                Title = course.Title,
                Description = course.Description,
                DepartmentId = department.Id,
                DepartmentName = department.Name,
                YearId = year.Id,
                YearName = year.Name,
                CreditHours = course.CreditHours,
                EnrolledStudentsCount = 0,
                ImageUrl = course.ImageUrl,
                InstructorId = userId,
                InstructorName = instructor?.FullName ?? "",
                CreatedAt = course.CreatedAt,
                UpdatedAt = course.UpdatedAt
            };
        }

        public async Task<CourseResponseDto?> UpdateAsync(int id, CourseRequestDto dto, int userId)
        {
            var course = await _context.Courses.FindAsync(id);
            if (course == null)
                return null;

            if (course.CreatedById != userId)
                throw new UnauthorizedAccessException("You are not allowed to update this course.");

            var department = await _context.Departments
                .FirstOrDefaultAsync(d => d.Name == dto.DepartmentName);
            if (department == null)
                throw new ArgumentException($"Department '{dto.DepartmentName}' not found.");

            var year = await _context.Years
                .FirstOrDefaultAsync(y => y.Name == dto.YearName && y.DepartmentId == department.Id);
            if (year == null)
                throw new ArgumentException($"Year '{dto.YearName}' not found in department '{dto.DepartmentName}'.");
            
            var oldYearId = course.YearId;

            _mapper.Map(dto, course);
            
            course.DepartmentId = department.Id;
            course.YearId = year.Id;
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

            return await GetByIdAsync(id);
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
