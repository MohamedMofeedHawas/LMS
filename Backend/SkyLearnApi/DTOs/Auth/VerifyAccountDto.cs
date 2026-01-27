using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace SkyLearnApi.DTOs.Auth
{
     
    /// Request DTO for verifying if an account exists and its activation status.
    /// First step in the closed system authentication flow.
     
    public class VerifyAccountRequestDto
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [JsonPropertyName("Email")]
        public string Email { get; set; } = string.Empty;
    }

     
    /// Response DTO for account verification.
     
    public class VerifyAccountResponseDto
    {
         
        /// Whether the email exists in the system.
         
        [JsonPropertyName("exists")]
        public bool Exists { get; set; }

         
        /// Whether the account has been activated (password set).
        /// Only meaningful if Exists is true.
         
        [JsonPropertyName("isActivated")]
        public bool IsActivated { get; set; }
    }
}
