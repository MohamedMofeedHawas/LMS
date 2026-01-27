namespace SkyLearnApi.Services.Implementation
{
    public class SquadronService : ISquadronService
    {
        private readonly AppDbContext _context;
        private readonly IActivityService _activityService;

        public SquadronService(AppDbContext context, IActivityService activityService)
        {
            _context = context;
            _activityService = activityService;
        }

        public async Task<List<SquadronResponseDto>> GetAllAsync()
        {
            var squadrons = await _context.Squadrons
                .Select(s => new SquadronResponseDto
                {
                    Id = s.Id,
                    Name = s.Name,
                    Description = s.Description,
                    StudentCount = s.Students.Count,
                    CreatedAt = s.CreatedAt,
                    UpdatedAt = s.UpdatedAt
                })
                .OrderBy(s => s.Name)
                .ToListAsync();

            return squadrons;
        }

        public async Task<SquadronDetailResponseDto?> GetByIdAsync(int id)
        {
            var squadron = await _context.Squadrons
                .Where(s => s.Id == id)
                .Select(s => new SquadronDetailResponseDto
                {
                    Id = s.Id,
                    Name = s.Name,
                    Description = s.Description,
                    StudentCount = s.Students.Count,
                    CreatedAt = s.CreatedAt,
                    UpdatedAt = s.UpdatedAt,
                    Students = s.Students.Select(sp => new SquadronStudentDto
                    {
                        Id = sp.User.Id,
                        Email = sp.User.Email ?? "",
                        FullName = sp.User.FullName,
                        DepartmentName = sp.Department.Name,
                        YearName = sp.Year.Name
                    }).ToList()
                })
                .FirstOrDefaultAsync();

            return squadron;
        }

        public async Task<(SquadronResponseDto? Squadron, string? Error)> CreateAsync(CreateSquadronDto dto)
        {
            // Check name uniqueness
            var existingName = await _context.Squadrons
                .AnyAsync(s => s.Name == dto.Name);

            if (existingName)
            {
                return (null, $"Squadron with name '{dto.Name}' already exists");
            }

            var squadron = new Squadron
            {
                Name = dto.Name,
                Description = dto.Description,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Squadrons.Add(squadron);
            await _context.SaveChangesAsync();

            await _activityService.TrackEntityActionAsync(
                ActivityActions.SquadronCreated,
                "Squadron",
                squadron.Id,
                description: $"Squadron created: {squadron.Name}");

            Log.Information("Squadron created: {Name}", squadron.Name);

            return (MapToResponse(squadron, 0), null);
        }

        public async Task<(SquadronResponseDto? Squadron, string? Error)> UpdateAsync(int id, UpdateSquadronDto dto)
        {
            var squadron = await _context.Squadrons
                .Include(s => s.Students)
                .FirstOrDefaultAsync(s => s.Id == id);

            if (squadron == null)
            {
                return (null, "Squadron not found");
            }

            // Check name uniqueness if changing
            if (!string.IsNullOrWhiteSpace(dto.Name) && dto.Name != squadron.Name)
            {
                var existingName = await _context.Squadrons
                    .AnyAsync(s => s.Name == dto.Name && s.Id != id);

                if (existingName)
                {
                    return (null, $"Squadron with name '{dto.Name}' already exists");
                }
                squadron.Name = dto.Name;
            }

            if (dto.Description != null)
                squadron.Description = dto.Description;

            squadron.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            await _activityService.TrackEntityActionAsync(
                ActivityActions.SquadronUpdated,
                "Squadron",
                squadron.Id,
                description: $"Squadron updated: {squadron.Name}");

            return (MapToResponse(squadron, squadron.Students.Count), null);
        }

        public async Task<(bool Success, string? Error)> DeleteAsync(int id)
        {
            var squadron = await _context.Squadrons
                .Include(s => s.Students)
                .FirstOrDefaultAsync(s => s.Id == id);

            if (squadron == null)
            {
                return (false, "Squadron not found");
            }

            if (squadron.Students.Any())
            {
                return (false, $"Cannot delete squadron with {squadron.Students.Count} students. Remove or reassign students first.");
            }
            // Hard delete
            _context.Squadrons.Remove(squadron);
            await _context.SaveChangesAsync();

            await _activityService.TrackEntityActionAsync(
                ActivityActions.SquadronDeleted,
                "Squadron",
                id,
                description: $"Squadron deleted: {squadron.Name}");

            Log.Information("Squadron deleted: {Name} (Id: {Id})", squadron.Name, id);

            return (true, null);
        }

        private static SquadronResponseDto MapToResponse(Squadron s, int studentCount)
        {
            return new SquadronResponseDto
            {
                Id = s.Id,
                Name = s.Name,
                Description = s.Description,
                StudentCount = studentCount,
                CreatedAt = s.CreatedAt,
                UpdatedAt = s.UpdatedAt
            };
        }
    }
}
