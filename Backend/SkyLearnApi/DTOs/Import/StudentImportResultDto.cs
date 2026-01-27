namespace SkyLearnApi.DTOs.Import
{
     
    /// Result DTO for bulk student import operation.
    /// Provides comprehensive summary of the import including success/failure counts and detailed error messages.
     
    public class StudentImportResultDto
    {
         
        /// Total number of rows processed from the CSV file (excluding header row).
         
        public int TotalRows { get; set; }

         
        /// Total successful operations (Created + Updated).
         
        public int SuccessCount { get; set; }

         
        /// Number of NEW students created.
         
        public int CreatedCount { get; set; }

         
        /// Number of EXISTING students updated.
         
        public int UpdatedCount { get; set; }

         
        /// Number of rows that failed validation or operation.
         
        public int FailedCount { get; set; }

         
        /// Detailed list of errors for failed rows.
        /// Each error includes the row number, email (if available), and error message.
         
        public List<StudentImportErrorDto> Errors { get; set; } = new();
    }

     
    /// Detailed error information for a single failed import row.
     
    public class StudentImportErrorDto
    {
         
        /// The 1-based row number in the CSV file (excluding header).
        /// Row 1 refers to the first data row after the header.
         
        public int RowNumber { get; set; }

         
        /// The email from the failed row (if available).
        /// Helps admin identify which record failed.
         
        public string Email { get; set; } = string.Empty;

         
        /// Human-readable error message explaining why the row failed.
         
        public string Error { get; set; } = string.Empty;
    }
}
