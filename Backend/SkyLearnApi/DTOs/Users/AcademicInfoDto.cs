using System.Text.Json.Serialization;

namespace SkyLearnApi.DTOs.Users
{
    public class AcademicInfoDto
    {
        [JsonPropertyName("department")]
        public EntityRefDto Department { get; set; } = null!;

        [JsonPropertyName("year")]
        public EntityRefDto Year { get; set; } = null!;

        [JsonPropertyName("squadron")]
        public EntityRefDto Squadron { get; set; } = null!;

        [JsonPropertyName("admissionYear")]
        public int AdmissionYear { get; set; }
    }

    public class EntityRefDto
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; } = string.Empty;
    }
}
