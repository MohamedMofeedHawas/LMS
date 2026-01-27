

namespace SkyLearnApi.DTOs.Squadron
{
    /// Response DTO for Squadron with student count
    public class SquadronResponseDto
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; } = string.Empty;

        [JsonPropertyName("description")]
        public string? Description { get; set; }

        [JsonPropertyName("studentCount")]
        public int StudentCount { get; set; }

        [JsonPropertyName("createdAt")]
        public DateTime CreatedAt { get; set; }

        [JsonPropertyName("updatedAt")]
        public DateTime UpdatedAt { get; set; }
    }

    /// Detailed response with student list (for single squadron GET)
    public class SquadronDetailResponseDto : SquadronResponseDto
    {
        [JsonPropertyName("students")]
        public List<SquadronStudentDto> Students { get; set; } = new();
    }

    /// Student info within squadron response
    public class SquadronStudentDto
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("email")]
        public string Email { get; set; } = string.Empty;

        [JsonPropertyName("fullName")]
        public string FullName { get; set; } = string.Empty;

        [JsonPropertyName("departmentName")]
        public string DepartmentName { get; set; } = string.Empty;

        [JsonPropertyName("yearName")]
        public string YearName { get; set; } = string.Empty;
    }
}
