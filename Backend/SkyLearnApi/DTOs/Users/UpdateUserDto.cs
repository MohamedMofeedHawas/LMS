using System.ComponentModel.DataAnnotations;

namespace SkyLearnApi.Dtos.Users
{
     
    /// DTO for updating an existing user (Admin only).
    /// 
    /// BUSINESS RULE: Admins can update user profile information but CANNOT:
    /// - Set or change passwords (users manage their own passwords)
    /// - View password hashes
    /// 
    /// Password management is strictly user-controlled via:
    /// - /api/auth/activate-account (first-time setup)
    /// - /api/auth/reset-password (password recovery)
     
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
        public string? ProfileImageUrl { get; set; }
        
         
        /// Enable or disable the user account.
        /// Disabled users cannot log in.
         
        public bool? IsActive { get; set; }
    }
}
