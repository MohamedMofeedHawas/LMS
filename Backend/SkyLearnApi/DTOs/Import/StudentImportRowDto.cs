namespace SkyLearnApi.DTOs.Import
{
     
    /// Internal DTO representing a single row parsed from the CSV file.
    /// Used internally by the import service for validation and processing.
     
    public class StudentImportRowDto
    {
         
        /// Student's email address. Will be used as the UserName.
        /// Required - row will fail if empty.
         
        public string Email { get; set; } = string.Empty;

         
        /// Student's full name for display purposes.
         
        public string FullName { get; set; } = string.Empty;

         
        /// National ID for identification purposes.
         
        public string? NationalId { get; set; }

         
        /// Name of the department. Must exist in the database.
        /// Lookup is done by exact name match.
         
        public string DepartmentName { get; set; } = string.Empty;

         
        /// Name of the academic year. Must exist in the database.
        /// Lookup is done by exact name match.
         
        public string YearName { get; set; } = string.Empty;

         
        /// Name of the squadron. Must exist in the database.
        /// Lookup is done by exact name match.
         
        public string SquadronName { get; set; } = string.Empty;
    }
}
