namespace SkyLearnApi.Entities
{
    public class ApplicationUser
{
    public int Id { get; set; }
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string? ProfileImageUrl { get; set; }
    public string? Gender { get; set; }
    public string? City { get; set; }
    public string? AcademicLevel { get; set; }

        // ---- Role ----
    public UserRole Role { get; set; } = UserRole.Student;

        
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    
    public ICollection<AuditLog> AuditLogs { get; set; } = new List<AuditLog>();

}

}


// "ConnectionStrings": {
//     "DefaultConnection": "Server=db30067.public.databaseasp.net;Database=db30067;User Id=db30067;Password=Sx8?6L_qWe5%;Encrypt=False;MultipleActiveResultSets=True;TrustServerCertificate=True;"
//   },