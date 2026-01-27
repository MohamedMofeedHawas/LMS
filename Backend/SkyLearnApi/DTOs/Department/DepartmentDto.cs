namespace SkyLearnApi.Dtos.Department
{
    public class DepartmentDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string? ImageUrl { get; set; }
        public int HeadId { get; set; }
        public string? HeadName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public ICollection<YearResponseDto> Years { get; set; } = new List<YearResponseDto>();
    }
}
