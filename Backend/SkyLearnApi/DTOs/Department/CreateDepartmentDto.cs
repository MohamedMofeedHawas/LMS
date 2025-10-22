namespace SkyLearnApi.Dtos.Department
{
    public class CreateDepartmentDto
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string FullName { get; set; } = string.Empty; 
    public IFormFile? Image { get; set; }
}

}
