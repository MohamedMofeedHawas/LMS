
namespace SkyLearnApi.Services.Implementation
{
    public class DepartmentService : IDepartmentService
    {
        private readonly AppDbContext _context;
        private readonly IWebHostEnvironment _environment;

        public DepartmentService(AppDbContext context, IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        // 🟩 Get All
        public async Task<IEnumerable<DepartmentDto>> GetAllAsync()
        {
            return await _context.Departments
                .Include(d => d.Head)
                .Select(d => new DepartmentDto
                {
                    Id = d.Id,
                    Name = d.Name,
                    Description = d.Description,
                    ImageUrl = d.ImageUrl,
                    HeadId = d.HeadId,
                    HeadName = d.Head.FullName,
                    CreatedAt = d.CreatedAt,
                    UpdatedAt = d.UpdatedAt
                })
                .ToListAsync();
        }

        // 🟩 Get By Id
        public async Task<DepartmentDto?> GetByIdAsync(int id)
        {
            var dept = await _context.Departments
                .Include(d => d.Head)
                .FirstOrDefaultAsync(d => d.Id == id);

            if (dept == null) return null;

            return new DepartmentDto
            {
                Id = dept.Id,
                Name = dept.Name,
                Description = dept.Description,
                ImageUrl = dept.ImageUrl,
                HeadId = dept.HeadId,
                HeadName = dept.Head.FullName,
                CreatedAt = dept.CreatedAt,
                UpdatedAt = dept.UpdatedAt
            };
        }

        // 🟩 Create
        public async Task<DepartmentDto> CreateAsync(CreateDepartmentDto dto)
        {
            // البحث عن رئيس القسم بالاسم الكامل
            var head = await _context.Users
                .FirstOrDefaultAsync(u => u.FullName.ToLower() == dto.FullName.ToLower());

            if (head == null)
                throw new Exception("Head of Department not found with the given name.");

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

        // 🟩 Update
        public async Task<DepartmentDto?> UpdateAsync(int id, UpdateDepartmentDto dto)
        {
            var dept = await _context.Departments.FindAsync(id);
            if (dept == null) return null;

            ApplicationUser? head = null;
            if (!string.IsNullOrEmpty(dto.FullName))
            {
                head = await _context.Users
                    .FirstOrDefaultAsync(u => u.FullName.ToLower() == dto.FullName.ToLower());

                if (head == null)
                    throw new Exception("Head of Department not found with the given name.");

                dept.HeadId = head.Id;
            }

            if (!string.IsNullOrEmpty(dto.Name)) dept.Name = dto.Name;
            if (!string.IsNullOrEmpty(dto.Description)) dept.Description = dto.Description;
            dept.UpdatedAt = DateTime.UtcNow;

            if (dto.Image != null)
            {
                ImageHelper.DeleteImage(dept.ImageUrl, _environment);
                dept.ImageUrl = await ImageHelper.SaveImageAsync(dto.Image, "departments", _environment);
            }

            await _context.SaveChangesAsync();

            return new DepartmentDto
            {
                Id = dept.Id,
                Name = dept.Name,
                Description = dept.Description,
                ImageUrl = dept.ImageUrl,
                HeadId = dept.HeadId,
                HeadName = head != null ? head.FullName : "Unknown",
                CreatedAt = dept.CreatedAt,
                UpdatedAt = dept.UpdatedAt
            };
        }

        // 🟩 Delete
        public async Task<bool> DeleteAsync(int id)
        {
            var dept = await _context.Departments.FindAsync(id);
            if (dept == null) return false;

            ImageHelper.DeleteImage(dept.ImageUrl, _environment);

            _context.Departments.Remove(dept);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
