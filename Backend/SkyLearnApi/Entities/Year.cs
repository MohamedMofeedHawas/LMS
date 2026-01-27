namespace SkyLearnApi.Entities
{
    public class Year
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public int DepartmentId { get; set; }
        public Department Department { get; set; }
        public ICollection<Course> Courses { get; set; } = new List<Course>();
        public int CreatedById { get; set; }
        public ApplicationUser CreatedBy { get; set; }      
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }       
        public int TotalCourses { get; set; } = 0;
        public int TotalHours { get; set; } = 0;       
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
