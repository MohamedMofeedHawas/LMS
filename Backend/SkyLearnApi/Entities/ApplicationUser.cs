
using SkyLearnApi.Enums;

namespace SkyLearnApi.Entities
{
    public class ApplicationUser
{
    public int Id { get; set; }
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
   public string? ProfileImageUrl { get; set; }
        public string? Gender { get; set; }
        public string? City { get; set; }
        public string? AcademicLevel { get; set; }

        // ---- Role ----
        public UserRole Role { get; set; } = UserRole.Student;

        // ---- Audit Info ----
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

}

}
