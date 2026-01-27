using System.ComponentModel.DataAnnotations;

namespace SkyLearnApi.Dtos.Users
{
     
    /// DTO for creating a new user (Admin only).
    /// 
    /// BUSINESS RULE: In this closed system, Admins create users WITHOUT passwords.
    /// Users must set their own password during first-time activation.
    /// This ensures Admins never know user passwords.
     
    public class CreateUserDto
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Full name is required")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Full name must be between 2 and 100 characters")]
        public string FullName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Role is required")]
        [RegularExpression("^(Admin|Instructor|Student)$", ErrorMessage = "Role must be Admin, Instructor, or Student")]
        public string Role { get; set; } = string.Empty;

        public string? NationalId { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? Gender { get; set; }
        public string? City { get; set; }
        public string? ProfileImageUrl { get; set; }
        
         
        /// Whether the user account is enabled.
        /// Defaults to true. Set to false to create a disabled account.
         
        public bool IsActive { get; set; } = true;
    }
}
