namespace SkyLearnApi.Dtos.Courses
{
    public class CourseRequestDto
    {
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }

        public int DepartmentId { get; set; }
        public int YearId { get; set; }

        public int CreditHours { get; set; }
        public string? ImageUrl { get; set; }

       
        public IFormFile? ImageFile { get; set; }
    }
}
