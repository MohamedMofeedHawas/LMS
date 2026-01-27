namespace SkyLearnApi.DTOs.Import
{
    public class StudentImportResultDto
    {
        public int TotalRows { get; set; }        
        public int SuccessCount { get; set; }

        public int CreatedCount { get; set; }
        public int UpdatedCount { get; set; }
        public int FailedCount { get; set; }
        public List<StudentImportErrorDto> Errors { get; set; } = new();
    }
    public class StudentImportErrorDto
    {
        public int RowNumber { get; set; }
        public string Email { get; set; } = string.Empty;
        public string Error { get; set; } = string.Empty;
    }
}
