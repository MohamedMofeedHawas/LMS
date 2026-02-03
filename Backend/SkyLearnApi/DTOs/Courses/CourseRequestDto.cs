namespace SkyLearnApi.Dtos.Courses
{
    public class CourseRequestDto
    {
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }

        public string DepartmentName { get; set; } = string.Empty;
        public string YearName { get; set; } = string.Empty;

        public int CreditHours { get; set; }
        public string? ImageUrl { get; set; }

       
        public IFormFile? ImageFile { get; set; }
    }
}
