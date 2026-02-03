namespace SkyLearnApi.Dtos.Courses
{
    public class CourseResponseDto
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }

        public int DepartmentId { get; set; }
        public string DepartmentName { get; set; } = string.Empty;

        public int YearId { get; set; }
        public string YearName { get; set; } = string.Empty;

        public int CreditHours { get; set; }
        public int EnrolledStudentsCount { get; set; } = 0;

        public string? ImageUrl { get; set; }

        public int InstructorId { get; set; }
        public string InstructorName { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
    }
}
