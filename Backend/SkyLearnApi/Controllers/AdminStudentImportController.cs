using SkyLearnApi.DTOs.Import;

namespace SkyLearnApi.Controllers
{
     
    /// Admin-only controller for bulk student import operations.
    /// 
    /// Design Decision: Separated from UsersController to maintain single responsibility.
    /// UsersController handles individual CRUD operations.
    /// This controller handles bulk import which has different concerns:
    /// - File parsing
    /// - Batch validation
    /// - Detailed error reporting
    [ApiController]
    [Route("api/admin/import")]
    [Authorize(Roles = Roles.Admin)]
    public class AdminStudentImportController : ControllerBase
    {
        private readonly IStudentImportService _importService;

        // Maximum file size: 5 MB (sufficient for thousands of students)
        private const long MaxFileSizeBytes = 5 * 1024 * 1024;
        
        // Allowed file extensions
        private static readonly string[] AllowedExtensions = { ".csv" };

        public AdminStudentImportController(IStudentImportService importService)
        {
            _importService = importService;
        }

        /// Import students from a CSV file.
        /// Expected CSV format (header row required):
        /// Email,FullName,NationalId,DepartmentName,YearName,SquadronName
        /// 
        /// Processing rules:
        /// - Role is always "Student" (not read from file)
        /// - Users are created WITHOUT passwords (Admin cannot set passwords)
        /// - Each row is processed independently (one failure doesn't affect others)
        /// - DepartmentName, YearName, SquadronName must match existing database records
        [HttpPost("students")]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(typeof(StudentImportResultDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> ImportStudents(IFormFile file)
        {
            // FILE VALIDATION

            // 1. File is required
            if (file == null || file.Length == 0)
            {
                return BadRequest(new { message = "No file uploaded or file is empty" });
            }

            // 2. Check file extension
            var extension = Path.GetExtension(file.FileName).ToLowerInvariant();
            if (!AllowedExtensions.Contains(extension))
            {
                return BadRequest(new 
                { 
                    message = $"Invalid file type. Only CSV files are allowed. Received: {extension}"
                });
            }

            // 3. Check file size
            if (file.Length > MaxFileSizeBytes)
            {
                return BadRequest(new 
                { 
                    message = $"File size exceeds maximum allowed size of {MaxFileSizeBytes / (1024 * 1024)} MB"
                });
            }

            // 4. Validate content type (additional security check)
            var allowedContentTypes = new[] { "text/csv", "application/csv", "text/plain", "application/vnd.ms-excel" };
            if (!string.IsNullOrEmpty(file.ContentType) && 
                !allowedContentTypes.Any(ct => file.ContentType.Contains(ct, StringComparison.OrdinalIgnoreCase)))
            {
                // Log but don't reject - content type can be unreliable
                Log.Warning("Unexpected content type for CSV file: {ContentType}", file.ContentType);
            }

            // ========================================
            // PROCESS IMPORT
            // ========================================
            try
            {
                using var stream = file.OpenReadStream();
                var result = await _importService.ImportStudentsFromCsvAsync(stream);

                // Log the operation
                Log.Information(
                    "Admin bulk import completed: {Success}/{Total} students imported successfully",
                    result.SuccessCount, result.TotalRows);

                return Ok(result);
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Error during bulk student import");
                return StatusCode(StatusCodes.Status500InternalServerError, new 
                { 
                    message = "An error occurred while processing the import file",
                    details = ex.Message
                });
            }
        }

         
        /// Get the expected CSV format/template for student import.
        /// Returns a sample CSV that admins can use as a template.
         
        [HttpGet("students/template")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public IActionResult GetImportTemplate()
        {
            var csvContent = "Email,FullName,NationalId,DepartmentName,YearName,SquadronName\n" +
                             "student1@example.com,Ahmed Mohamed,12345678901234,Computer Science,First Year,Squadron Alpha\n" +
                             "student2@example.com,Sara Ahmed,12345678901235,Engineering,Second Year,Squadron Beta";

            return File(
                Encoding.UTF8.GetBytes(csvContent),
                "text/csv",
                "student_import_template.csv");
        }
    }
}
