namespace SkyLearnApi.Entities
{
    public class Department
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string? ImageUrl { get; set; }
        public ICollection<Year> Years { get; set; } = new List<Year>();
        public int HeadId { get; set; }
        public ApplicationUser Head { get; set; }
        public ICollection<Course> Courses { get; set; } = new List<Course>();
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
