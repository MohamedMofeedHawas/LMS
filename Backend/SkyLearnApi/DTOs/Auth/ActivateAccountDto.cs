using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace SkyLearnApi.DTOs.Auth
{
    public class ActivateAccountRequestDto
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [JsonPropertyName("Email")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Password is required")]
        [MinLength(8, ErrorMessage = "Password must be at least 8 characters")]
        [JsonPropertyName("Password")]
        public string Password { get; set; } = string.Empty;

        [Required(ErrorMessage = "Password confirmation is required")]
        [Compare(nameof(Password), ErrorMessage = "Passwords do not match")]
        [JsonPropertyName("ConfirmPassword")]
        public string ConfirmPassword { get; set; } = string.Empty;
    }

     
    /// Response DTO for successful account activation.
    /// Includes JWT token for immediate authentication.
     
    public class ActivateAccountResponseDto
    {
        [JsonPropertyName("message")]
        public string Message { get; set; } = "Account activated successfully";

        [JsonPropertyName("token")]
        public string Token { get; set; } = null!;

        [JsonPropertyName("expiresIn")]
        public DateTime ExpiresIn { get; set; }

        [JsonPropertyName("user")]
        public UserProfileDto User { get; set; } = null!;
    }
}
