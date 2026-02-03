namespace SkyLearnApi.Services.Implementations
{
    public class DepartmentService : IDepartmentService
    {
        private readonly AppDbContext _context;
        private readonly IWebHostEnvironment _environment;

        private readonly UserManager<ApplicationUser> _userManager;

        public DepartmentService(AppDbContext context, IWebHostEnvironment environment, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _environment = environment;
            _userManager = userManager;
        }
        public async Task<IEnumerable<DepartmentDto>> GetAllAsync()
        {
            var departments = await _context.Departments
                .AsNoTracking()
                .Include(d => d.Head)
                .Include(d => d.Years)
                .ToListAsync();

            return departments.Select(d => new DepartmentDto
            {
                Id = d.Id,
                Name = d.Name,
                Description = d.Description,
                ImageUrl = d.ImageUrl,
                HeadId = d.HeadId,
                HeadName = d.Head != null ? d.Head.FullName : "Not Assigned",
                CreatedAt = d.CreatedAt,
                UpdatedAt = d.UpdatedAt,
                Years = d.Years.Adapt<ICollection<YearResponseDto>>()
            }).ToList();
        }
        public async Task<DepartmentDto?> GetByIdAsync(int id)
        {
            var dept = await _context.Departments
                .Include(d => d.Head)
                .Include(d => d.Years)
                    .ThenInclude(y => y.CreatedBy) 
                .FirstOrDefaultAsync(d => d.Id == id);

            if (dept == null) return null;

            return new DepartmentDto
            {
                Id = dept.Id,
                Name = dept.Name,
                Description = dept.Description,
                ImageUrl = dept.ImageUrl,
                HeadId = dept.HeadId,
                HeadName = dept.Head != null ? dept.Head.FullName : "Not Assigned",
                CreatedAt = dept.CreatedAt,
                UpdatedAt = dept.UpdatedAt,
                Years = dept.Years.Adapt<ICollection<YearResponseDto>>()
            };
        }
        public async Task<DepartmentDto> CreateAsync(CreateDepartmentDto dto)
        {
            var head = await _userManager.Users.FirstOrDefaultAsync(u => u.FullName == dto.HeadName);
            
            if (head == null)
            {
                Log.Warning("Department creation failed - Head Name {HeadName} not found", dto.HeadName);
                throw new KeyNotFoundException($"User with Name '{dto.HeadName}' not found.");
            }

            if (await _context.Departments.AnyAsync(d => d.Name == dto.Name))
                throw new InvalidOperationException($"Department with name '{dto.Name}' already exists.");

            var isAdmin = await _userManager.IsInRoleAsync(head, Roles.Admin);
            var isInstructor = await _userManager.IsInRoleAsync(head, Roles.Instructor);

            if (!isAdmin && !isInstructor)
            {
                Log.Warning("Department creation failed - User {UserName} is not Admin or Instructor", head.FullName);
                throw new InvalidOperationException("Head of Department must be an Admin or Instructor.");
            }

            string? imageUrl = null;
            if (dto.Image != null)
                imageUrl = await ImageHelper.SaveImageAsync(dto.Image, "departments", _environment);

            var dept = new Department
            {
                Name = dto.Name,
                Description = dto.Description,
                HeadId = head.Id,
                ImageUrl = imageUrl,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Departments.Add(dept);
            await _context.SaveChangesAsync();

            Log.Information("Department created - Id: {DepartmentId}, Name: {Name}, HeadId: {HeadId}", 
                dept.Id, dept.Name, dept.HeadId);

            return new DepartmentDto
            {
                Id = dept.Id,
                Name = dept.Name,
                Description = dept.Description,
                ImageUrl = dept.ImageUrl,
                HeadId = dept.HeadId,
                HeadName = head.FullName,
                CreatedAt = dept.CreatedAt,
                UpdatedAt = dept.UpdatedAt
            };
        }

        public async Task<DepartmentDto?> UpdateAsync(int id, UpdateDepartmentDto dto)
        {
            var dept = await _context.Departments
                .Include(d => d.Head)
                .FirstOrDefaultAsync(d => d.Id == id);
                
            if (dept == null) return null;

            ApplicationUser? head = dept.Head;
            
            if (!string.IsNullOrEmpty(dto.HeadName))
            {
                var newHead = await _userManager.Users.FirstOrDefaultAsync(u => u.FullName == dto.HeadName);
                
                if (newHead == null)
                {
                    Log.Warning("Department update failed - Head Name {HeadName} not found", dto.HeadName);
                    throw new KeyNotFoundException($"User with Name '{dto.HeadName}' not found.");
                }

                var isAdmin = await _userManager.IsInRoleAsync(newHead, Roles.Admin);
                var isInstructor = await _userManager.IsInRoleAsync(newHead, Roles.Instructor);

                if (!isAdmin && !isInstructor)
                {
                    throw new InvalidOperationException("Head of Department must be an Admin or Instructor.");
                }

                head = newHead;
                dept.HeadId = head.Id;
            }

            if (!string.IsNullOrEmpty(dto.Name))
            {
                if (await _context.Departments.AnyAsync(d => d.Name == dto.Name && d.Id != id))
                    throw new InvalidOperationException($"Department with name '{dto.Name}' already exists.");
                dept.Name = dto.Name;
            }
            if (!string.IsNullOrEmpty(dto.Description)) dept.Description = dto.Description;
            dept.UpdatedAt = DateTime.UtcNow;

            if (dto.Image != null)
            {
                if (!string.IsNullOrEmpty(dept.ImageUrl))
                    ImageHelper.DeleteImage(dept.ImageUrl, _environment);
                    
                dept.ImageUrl = await ImageHelper.SaveImageAsync(dto.Image, "departments", _environment);
            }

            await _context.SaveChangesAsync();

            Log.Information("Department updated - Id: {DepartmentId}, Name: {Name}", dept.Id, dept.Name);

            return new DepartmentDto
            {
                Id = dept.Id,
                Name = dept.Name,
                Description = dept.Description,
                ImageUrl = dept.ImageUrl,
                HeadId = dept.HeadId,
                HeadName = head?.FullName ?? "Not Assigned",
                CreatedAt = dept.CreatedAt,
                UpdatedAt = dept.UpdatedAt
            };
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var dept = await _context.Departments.FindAsync(id);
            if (dept == null) return false;

            // Check if department has years
            var hasYears = await _context.Years.AnyAsync(y => y.DepartmentId == id);
            if (hasYears)
            {
                throw new InvalidOperationException($"Cannot delete department '{dept.Name}' because it has academic years.");
            }

            if (!string.IsNullOrEmpty(dept.ImageUrl))
                ImageHelper.DeleteImage(dept.ImageUrl, _environment);

            _context.Departments.Remove(dept);
            await _context.SaveChangesAsync();
            
            Log.Information("Department deleted - Id: {DepartmentId}", id);
            
            return true;
        }
    }
}
