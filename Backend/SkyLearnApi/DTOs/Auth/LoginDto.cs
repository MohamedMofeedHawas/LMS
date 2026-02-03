using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace SkyLearnApi.DTOs
{
     
    /// Login request DTO with proper validation (Issue #10 fix).
     
    public class LoginDto
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [JsonPropertyName("Email")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Password is required")]
        [MinLength(1, ErrorMessage = "Password cannot be empty")]
        [JsonPropertyName("Password")]
        public string Password { get; set; } = string.Empty;
    }
}