using System.ComponentModel.DataAnnotations;

namespace SkyLearnApi.Dtos.Department
{
    public class CreateDepartmentDto
    {
        [Required(ErrorMessage = "Department name is required")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Name must be between 2 and 100 characters")]
        public string Name { get; set; } = string.Empty;
        
        [StringLength(500, ErrorMessage = "Description cannot exceed 500 characters")]
        public string? Description { get; set; }
        
        [Required(ErrorMessage = "Head of Department Name is required")]
        public string HeadName { get; set; } = string.Empty;
        
        public IFormFile? Image { get; set; }
    }
}
