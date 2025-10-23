namespace SkyLearnApi.Dtos.Department
{
    public class UpdateDepartmentDto
    {
        public string? Name { get; set; }
        public string? Description { get; set; }
        public string? FullName { get; set; }
        public IFormFile? Image { get; set; }
    }
}
