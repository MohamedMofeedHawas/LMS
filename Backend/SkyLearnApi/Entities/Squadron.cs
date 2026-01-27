namespace SkyLearnApi.Entities
{
    /// Squadron entity : organizational grouping for students
    /// Cross-departmental: students from any department/year can belong to a squadron.
    /// Name is the unique identifier ( "سرب Charlie - 31").
    /// Hard delete only - blocked if students exist.
    public class Squadron
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        // Navigation property for students in this squadron
        public ICollection<StudentProfile> Students { get; set; } = new List<StudentProfile>();
    }
}
