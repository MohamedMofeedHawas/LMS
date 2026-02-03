namespace SkyLearnApi.Entities
{
    public class Course
    {
        public int Id { get; set; }

        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string ImageUrl { get; set; }

        
        public int CreditHours { get; set; }
        public int EnrolledStudentsCount { get; set; } = 0;

        public int DepartmentId { get; set; }
        public required Department Department { get; set; }
        public int YearId { get; set; }
        public required Year Year { get; set; }
        public int CreatedById { get; set; }
        public required ApplicationUser CreatedBy { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }
    }
}
