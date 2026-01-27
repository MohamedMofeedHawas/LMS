namespace SkyLearnApi.DTOs.Import
{   public class StudentImportRowDto
    {
        public string Email { get; set; } = string.Empty;
       public string FullName { get; set; } = string.Empty;
        public string? NationalId { get; set; }
        public string DepartmentName { get; set; } = string.Empty;
        public string YearName { get; set; } = string.Empty;
        public string SquadronName { get; set; } = string.Empty;
    }
}
