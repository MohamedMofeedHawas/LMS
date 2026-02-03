using System.Text.Json.Serialization;

namespace SkyLearnApi.DTOs.Auth
{
    
    /// User profile DTO for the /api/auth/me endpoint and auth responses.
    /// Contains comprehensive user information extracted from JWT claims.
    /// 
    /// Note: Internal flags (IsActive, IsActivated) are NOT exposed directly.
    /// Instead, a computed AccountStatus field provides a business-friendly representation.
  
    public class UserProfileDto
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("email")]
        public string Email { get; set; } = string.Empty;

        [JsonPropertyName("fullName")]
        public string FullName { get; set; } = string.Empty;

        [JsonPropertyName("role")]
        public string Role { get; set; } = string.Empty;

        [JsonPropertyName("nationalId")]
        public string? NationalId { get; set; }

        [JsonPropertyName("dateOfBirth")]
        public DateTime? DateOfBirth { get; set; }

        [JsonPropertyName("gender")]
        public string? Gender { get; set; }

        [JsonPropertyName("city")]
        public string? City { get; set; }

        [JsonPropertyName("profileImageUrl")]
        public string? ProfileImageUrl { get; set; }

        
        /// Computed account status for business-friendly representation.
        /// Possible values: "Disabled", "PendingActivation", "Active"
        
        [JsonPropertyName("accountStatus")]
        public string AccountStatus { get; set; } = string.Empty;

        [JsonPropertyName("createdAt")]
        public DateTime CreatedAt { get; set; }

        [JsonPropertyName("lastLoginAt")]
        public DateTime? LastLoginAt { get; set; }

        /// Polymorphic: Only present for Students
        [JsonPropertyName("academicInfo")]
        public SkyLearnApi.DTOs.Users.AcademicInfoDto? AcademicInfo { get; set; }
    }
}
