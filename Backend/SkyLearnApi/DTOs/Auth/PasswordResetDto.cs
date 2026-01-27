using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace SkyLearnApi.DTOs.Auth
{
     
    /// Request DTO for initiating password reset (forgot password).
    /// Note: Response never reveals if email exists (security best practice).
     
    public class ForgotPasswordRequestDto
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [JsonPropertyName("Email")]
        public string Email { get; set; } = string.Empty;
    }

     
    /// Response DTO for forgot password request.
    /// Always returns the same message regardless of email existence.
     
    public class ForgotPasswordResponseDto
    {
        [JsonPropertyName("message")]
        public string Message { get; set; } = "If the email exists, password reset instructions will be provided.";

         
        /// In a production system, this would be sent via secure channel.
        /// For this implementation, we return it for admin use.
        /// NEVER expose this in a real production public API.
         
        [JsonPropertyName("resetToken")]
        public string? ResetToken { get; set; }
    }

     
    /// Request DTO for resetting password with token.
     
    public class ResetPasswordRequestDto
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [JsonPropertyName("Email")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Reset token is required")]
        [JsonPropertyName("ResetToken")]
        public string ResetToken { get; set; } = string.Empty;

        [Required(ErrorMessage = "New password is required")]
        [MinLength(8, ErrorMessage = "Password must be at least 8 characters")]
        [JsonPropertyName("NewPassword")]
        public string NewPassword { get; set; } = string.Empty;

        [Required(ErrorMessage = "Password confirmation is required")]
        [Compare(nameof(NewPassword), ErrorMessage = "Passwords do not match")]
        [JsonPropertyName("ConfirmPassword")]
        public string ConfirmPassword { get; set; } = string.Empty;
    }

     
    /// Response DTO for successful password reset.
     
    public class ResetPasswordResponseDto
    {
        [JsonPropertyName("message")]
        public string Message { get; set; } = "Password has been reset successfully.";

        [JsonPropertyName("success")]
        public bool Success { get; set; } = true;
    }
}
