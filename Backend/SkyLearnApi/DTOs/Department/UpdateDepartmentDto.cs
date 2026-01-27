using System.ComponentModel.DataAnnotations;

namespace SkyLearnApi.Dtos.Department
{
    public class UpdateDepartmentDto
    {
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Name must be between 2 and 100 characters")]
        public string? Name { get; set; }
        
        [StringLength(500, ErrorMessage = "Description cannot exceed 500 characters")]
        public string? Description { get; set; }
        
        public string? HeadName { get; set; }
        
        public IFormFile? Image { get; set; }
    }
}
