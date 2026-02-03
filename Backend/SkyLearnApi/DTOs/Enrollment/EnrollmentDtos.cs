namespace SkyLearnApi.DTOs.Enrollment
{
    public class EnrollStudentDto
    {
        [Required]
        public int StudentId { get; set; }

        [Required]
        public int CourseId { get; set; }
    }

    public class StudentCourseDto
    {
        public int CourseId { get; set; }
        public string CourseTitle { get; set; } = string.Empty;
        public string? CourseDescription { get; set; }
        public string? ImageUrl { get; set; }
        public int CreditHours { get; set; }
        public int EnrolledStudentsCount { get; set; }
        public string InstructorName { get; set; } = string.Empty;
        public DateTime? EnrolledAt { get; set; }
    }
}
