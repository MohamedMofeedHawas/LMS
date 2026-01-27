

namespace SkyLearnApi.DTOs.Squadron
{
    /// Create Squadron request (Admin only)
    public class CreateSquadronDto
    {
        [Required(ErrorMessage = "Name is required")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Name must be 2-100 characters")]
        [JsonPropertyName("name")]
        public string Name { get; set; } = string.Empty;

        [StringLength(500)]
        [JsonPropertyName("description")]
        public string? Description { get; set; }
    }

    /// Update Squadron request (Admin only)
    public class UpdateSquadronDto
    {
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Name must be 2-100 characters")]
        [JsonPropertyName("name")]
        public string? Name { get; set; }

        [StringLength(500)]
        [JsonPropertyName("description")]
        public string? Description { get; set; }
    }
}
