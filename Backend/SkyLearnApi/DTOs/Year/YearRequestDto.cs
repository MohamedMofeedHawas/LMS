namespace SkyLearnApi.Dtos.Year
{
    public class YearRequestDto
    {
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string DepartmentName { get; set; } = string.Empty;
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }
}
