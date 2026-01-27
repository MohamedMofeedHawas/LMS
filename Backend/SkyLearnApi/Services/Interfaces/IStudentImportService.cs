namespace SkyLearnApi.Services.Interfaces
{
     
    /// Service interface for bulk student import operations.
    /// Handles CSV parsing, validation, and batch creation of student accounts.
    /// 
    /// Design Decision: Separated from IUserService to maintain single responsibility.
    /// UserService handles CRUD operations, this service handles bulk import logic.
     
    public interface IStudentImportService
    {
         
        /// Imports students from a CSV file.
        /// 
        /// Expected CSV format (header row required):
        /// Email,FullName,NationalId,DepartmentName,YearName,SquadronName
        /// 
        /// Processing rules:
        /// - Each row is processed independently (one failure doesn't affect others)
        /// - Valid rows create ApplicationUser + StudentProfile in a single transaction
        /// - Role is always "Student" (hardcoded, not from CSV)
        /// - Users are created WITHOUT passwords (IsActivated = false)
         
        /// <param name="csvStream">The CSV file stream</param>
        /// <returns>Import result with success/failure counts and detailed errors</returns>
        Task<StudentImportResultDto> ImportStudentsFromCsvAsync(Stream csvStream);
    }
}
