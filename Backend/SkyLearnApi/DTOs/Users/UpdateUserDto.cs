using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace SkyLearnApi.Dtos.Users
{  
    public class UpdateUserDto
    {
        [EmailAddress(ErrorMessage = "Invalid email format")]
        public string? Email { get; set; }
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Full name must be between 2 and 100 characters")]
        public string? FullName { get; set; }
        [RegularExpression("^(Admin|Instructor|Student)$", ErrorMessage = "Role must be Admin, Instructor, or Student")]
        public string? Role { get; set; }
        public string? NationalId { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? Gender { get; set; }
        public string? City { get; set; }
        public IFormFile? ImageFile { get; set; }
        public bool? IsActive { get; set; }

        // Student Fields
        public int? DepartmentId { get; set; }
        public int? YearId { get; set; }
        public int? SquadronId { get; set; }
    }
}
