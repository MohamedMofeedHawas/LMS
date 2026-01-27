using SkyLearnApi.DTOs.Import;

namespace SkyLearnApi.Services.Implementation
{
    public class StudentImportService : IStudentImportService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly AppDbContext _dbContext;
        private readonly IActivityService _activityService;
        // Expected CSV header columns (case-insensitive matching)
        private static readonly string[] ExpectedHeaders = 
            { "Email", "FullName", "NationalId", "DepartmentName", "YearName", "SquadronName" };
        public StudentImportService(
            UserManager<ApplicationUser> userManager,
            AppDbContext dbContext,
            IActivityService activityService)
        {
            _userManager = userManager;
            _dbContext = dbContext;
            _activityService = activityService;
        }
        public async Task<StudentImportResultDto> ImportStudentsFromCsvAsync(Stream csvStream)
        {
            var result = new StudentImportResultDto();
            var rows = new List<(int RowNumber, StudentImportRowDto Data)>();

            // STEP 1: Parse CSV file
            try
            {
                rows = await ParseCsvAsync(csvStream);
            }
            catch (FormatException ex)
            {
                // CSV parsing failed - return single error
                result.TotalRows = 0;
                result.FailedCount = 1;
                result.Errors.Add(new StudentImportErrorDto
                {
                    RowNumber = 0,
                    Email = "",
                    Error = $"CSV parsing error: {ex.Message}"
                });
                return result;
            }

            result.TotalRows = rows.Count;

            if (rows.Count == 0)
            {
                result.Errors.Add(new StudentImportErrorDto
                {
                    RowNumber = 0,
                    Email = "",
                    Error = "CSV file is empty or contains only headers"
                });
                return result;
            }
            // STEP 2: Pre-load lookup data for performance
            // Avoids N+1 database queries during validation
            var departmentsLookup = await _dbContext.Departments
                .AsNoTracking()
                .ToDictionaryAsync(d => d.Name.ToLowerInvariant(), d => d.Id);

            var yearsLookup = await _dbContext.Years
                .AsNoTracking()
                .ToDictionaryAsync(y => y.Name.ToLowerInvariant(), y => y.Id);

            var squadronsLookup = await _dbContext.Squadrons
                .AsNoTracking()
                .ToDictionaryAsync(s => s.Name.ToLowerInvariant(), s => s.Id);

            // Pre load existing emails to check uniqueness efficiently
            var existingEmails = await _dbContext.Users
                .AsNoTracking()
                .Where(u => u.Email != null)
                .Select(u => u.Email!.ToLower())
                .ToHashSetAsync();
            var existingNationalIds = await _dbContext.Users
                .AsNoTracking()
                .Where(u => u.NationalId != null)
                .Select(u => u.NationalId!)
                .ToHashSetAsync();

            // STEP 3: Process each row independently
            // One failure must NOT affect other rows
            foreach (var (rowNumber, rowData) in rows)
            {
                var (importError, wasUpdate) = await ProcessRowAsync(
                    rowNumber,
                    rowData,
                    departmentsLookup,
                    yearsLookup,
                    squadronsLookup,
                    existingEmails);

                if (importError != null)
                {
                    result.FailedCount++;
                    result.Errors.Add(importError);
                }
                else
                {
                    result.SuccessCount++;
                    if (wasUpdate)
                    {
                        result.UpdatedCount++;
                    }
                    else
                    {
                        result.CreatedCount++;
                    }
                }
            }
            // STEP 4: Log the import operation
           
            await _activityService.TrackAsync(
                ActivityActions.BulkImportStudents,
                entityName: "StudentImport",
                description: $"Bulk import: {result.CreatedCount} created, {result.UpdatedCount} updated, {result.FailedCount} failed",
                metadata: new
                {
                    totalRows = result.TotalRows,
                    createdCount = result.CreatedCount,
                    updatedCount = result.UpdatedCount,
                    failedCount = result.FailedCount
                });

            Log.Information(
                "Bulk student import completed: {CreatedCount} created, {UpdatedCount} updated, {FailedCount} failed out of {TotalRows}",
                result.CreatedCount, result.UpdatedCount, result.FailedCount, result.TotalRows);

            return result;
        }

         
        /// Parses CSV stream into structured row data.
        /// Validates header row format and extracts data rows.
        private async Task<List<(int RowNumber, StudentImportRowDto Data)>> ParseCsvAsync(Stream csvStream)
        {
            var rows = new List<(int, StudentImportRowDto)>();
            using var reader = new StreamReader(csvStream);

            // Read and validate header row
            var headerLine = await reader.ReadLineAsync();
            if (string.IsNullOrWhiteSpace(headerLine))
            {
                throw new FormatException("CSV file is empty - missing header row");
            }

            var headers = ParseCsvLine(headerLine);
            ValidateHeaders(headers);

            // Create header index map for flexible column ordering
            var headerIndexMap = CreateHeaderIndexMap(headers);

            // Parse data rows
            int rowNumber = 0;
            string? line;
            while ((line = await reader.ReadLineAsync()) != null)
            {
                rowNumber++;

                // Skip empty lines
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                var values = ParseCsvLine(line);
                
                // Ensure we have enough columns
                if (values.Length < ExpectedHeaders.Length)
                {
                    // Pad with empty strings for missing columns
                    var paddedValues = new string[ExpectedHeaders.Length];
                    values.CopyTo(paddedValues, 0);
                    values = paddedValues;
                }

                var rowData = new StudentImportRowDto
                {
                    Email = GetValueByHeader(values, headerIndexMap, "Email"),
                    FullName = GetValueByHeader(values, headerIndexMap, "FullName"),
                    NationalId = GetValueByHeader(values, headerIndexMap, "NationalId"),
                    DepartmentName = GetValueByHeader(values, headerIndexMap, "DepartmentName"),
                    YearName = GetValueByHeader(values, headerIndexMap, "YearName"),
                    SquadronName = GetValueByHeader(values, headerIndexMap, "SquadronName")
                };

                rows.Add((rowNumber, rowData));
            }

            return rows;
        }
        /// Parses a single CSV line, handling quoted fields and commas within quotes.         
        private static string[] ParseCsvLine(string line)
        {
            var result = new List<string>();
            var current = new StringBuilder();
            bool inQuotes = false;

            for (int i = 0; i < line.Length; i++)
            {
                char c = line[i];

                if (c == '"')
                {
                    // Check for escaped quote ("")
                    if (inQuotes && i + 1 < line.Length && line[i + 1] == '"')
                    {
                        current.Append('"');
                        i++; // Skip next quote
                    }
                    else
                    {
                        inQuotes = !inQuotes;
                    }
                }
                else if (c == ',' && !inQuotes)
                {
                    result.Add(current.ToString().Trim());
                    current.Clear();
                }
                else
                {
                    current.Append(c);
                }
            }

            result.Add(current.ToString().Trim());
            return result.ToArray();
        }

         
        /// Validates that all expected headers are present in the CSV.
        /// Throws FormatException if headers are missing or incorrect.
         
        private static void ValidateHeaders(string[] headers)
        {
            var normalizedHeaders = headers.Select(h => h.ToLowerInvariant().Trim()).ToHashSet();
            var expectedNormalized = ExpectedHeaders.Select(h => h.ToLowerInvariant()).ToList();

            var missing = expectedNormalized
                .Where(expected => !normalizedHeaders.Contains(expected))
                .ToList();

            if (missing.Any())
            {
                throw new FormatException(
                    $"Missing required CSV columns: {string.Join(", ", missing)}. " +
                    $"Expected columns: {string.Join(", ", ExpectedHeaders)}");
            }
        }

         
        /// Creates a case-insensitive mapping from header names to column indices.
         
        private static Dictionary<string, int> CreateHeaderIndexMap(string[] headers)
        {
            var map = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            for (int i = 0; i < headers.Length; i++)
            {
                map[headers[i].Trim()] = i;
            }
            return map;
        }

         
        /// Gets a value from the values array using the header name.
         
        private static string GetValueByHeader(string[] values, Dictionary<string, int> headerMap, string headerName)
        {
            if (headerMap.TryGetValue(headerName, out int index) && index < values.Length)
            {
                return values[index]?.Trim() ?? string.Empty;
            }
            return string.Empty;
        }
        /// Processes a single import row: validates, creates or UPDATES user, assigns role, creates/updates profile.
        /// Returns tuple: (error if failed, wasUpdate flag to distinguish create vs update)
        /// 
        /// BUSINESS RULES:
        /// - Department and Year MUST exist in database
        /// - Squadron is AUTO-CREATED if not found
        /// - If user already exists (by email), UPDATE their profile instead of error
   
        private async Task<(StudentImportErrorDto? Error, bool WasUpdate)> ProcessRowAsync(
            int rowNumber,
            StudentImportRowDto rowData,
            Dictionary<string, int> departmentsLookup,
            Dictionary<string, int> yearsLookup,
            Dictionary<string, int> squadronsLookup,
            HashSet<string> existingEmails)
        {
            // ========================================
            // VALIDATION PHASE
            // ========================================

            // 1. Email is required
            if (string.IsNullOrWhiteSpace(rowData.Email))
            {
                return (new StudentImportErrorDto
                {
                    RowNumber = rowNumber,
                    Email = "",
                    Error = "Email is required"
                }, false);
            }

            var emailLower = rowData.Email.ToLowerInvariant();

            // 2. Email format validation
            if (!IsValidEmail(rowData.Email))
            {
                return (new StudentImportErrorDto
                {
                    RowNumber = rowNumber,
                    Email = rowData.Email,
                    Error = "Invalid email format"
                }, false);
            }
            

            // 3. Department MUST exist (no auto-create)
            if (string.IsNullOrWhiteSpace(rowData.DepartmentName) || 
                !departmentsLookup.TryGetValue(rowData.DepartmentName.ToLowerInvariant(), out int departmentId))
            {
                return (new StudentImportErrorDto
                {
                    RowNumber = rowNumber,
                    Email = rowData.Email,
                    Error = $"Department not found: '{rowData.DepartmentName}'"
                }, false);
            }

            // 4. Year MUST exist (no auto-create)
            if (string.IsNullOrWhiteSpace(rowData.YearName) ||
                !yearsLookup.TryGetValue(rowData.YearName.ToLowerInvariant(), out int yearId))
            {
                return (new StudentImportErrorDto
                {
                    RowNumber = rowNumber,
                    Email = rowData.Email,
                    Error = $"Year not found: '{rowData.YearName}'"
                }, false);
            }

            // 5. Squadron - AUTO-CREATE if not found
            int squadronId;
            if (string.IsNullOrWhiteSpace(rowData.SquadronName))
            {
                return (new StudentImportErrorDto
                {
                    RowNumber = rowNumber,
                    Email = rowData.Email,
                    Error = "Squadron name is required"
                }, false);
            }

            var squadronNameLower = rowData.SquadronName.ToLowerInvariant();
            if (!squadronsLookup.TryGetValue(squadronNameLower, out squadronId))
            {
                // Squadron doesn't exist - create it automatically
                var newSquadron = new Squadron
                {
                    Name = rowData.SquadronName.Trim(),
                    Description = "Auto-created during student import",
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };

                _dbContext.Squadrons.Add(newSquadron);
                await _dbContext.SaveChangesAsync();

                squadronId = newSquadron.Id;
                squadronsLookup[squadronNameLower] = squadronId;

                Log.Information("Auto-created squadron '{SquadronName}' (ID: {SquadronId}) during import", 
                    rowData.SquadronName, squadronId);
            }

            // ========================================
            // CHECK IF USER EXISTS - UPDATE OR CREATE
            // ========================================
            var existingUser = await _userManager.FindByEmailAsync(rowData.Email);

            if (existingUser != null)
            {
                // USER EXISTS - Update their information (wasUpdate = true)
                var updateError = await UpdateExistingUserAsync(rowNumber, rowData, existingUser, departmentId, yearId, squadronId);
                return (updateError, wasUpdate: true);
            }
            else
            {
                // NEW USER - Create from scratch (wasUpdate = false)
                var createError = await CreateNewUserAsync(rowNumber, rowData, departmentId, yearId, squadronId, existingEmails);
                return (createError, wasUpdate: false);
            }
        }

         
        /// Updates an existing user's profile with new data from CSV.
        /// Updates: FullName, NationalId, Department, Year, Squadron
         
        private async Task<StudentImportErrorDto?> UpdateExistingUserAsync(
            int rowNumber,
            StudentImportRowDto rowData,
            ApplicationUser existingUser,
            int departmentId,
            int yearId,
            int squadronId)
        {
            try
            {
                // Update basic user info if provided
                bool userUpdated = false;
                
                if (!string.IsNullOrWhiteSpace(rowData.FullName) && existingUser.FullName != rowData.FullName)
                {
                    existingUser.FullName = rowData.FullName;
                    userUpdated = true;
                }
                
                if (!string.IsNullOrWhiteSpace(rowData.NationalId) && existingUser.NationalId != rowData.NationalId)
                {
                    existingUser.NationalId = rowData.NationalId;
                    userUpdated = true;
                }

                if (userUpdated)
                {
                    existingUser.UpdatedAt = DateTime.UtcNow;
                    await _userManager.UpdateAsync(existingUser);
                }

                // Find or create StudentProfile
                var profile = await _dbContext.StudentProfiles
                    .FirstOrDefaultAsync(sp => sp.UserId == existingUser.Id);

                if (profile != null)
                {
                    // Update existing profile
                    bool profileUpdated = false;

                    if (profile.DepartmentId != departmentId)
                    {
                        profile.DepartmentId = departmentId;
                        profileUpdated = true;
                    }

                    if (profile.YearId != yearId)
                    {
                        profile.YearId = yearId;
                        profileUpdated = true;
                    }

                    if (profile.SquadronId != squadronId)
                    {
                        profile.SquadronId = squadronId;
                        profileUpdated = true;
                    }

                    if (profileUpdated)
                    {
                        profile.UpdatedAt = DateTime.UtcNow;
                        await _dbContext.SaveChangesAsync();
                        Log.Debug("Updated student profile for existing user: {Email}", rowData.Email);
                    }
                }
                else
                {
                    // User exists but no StudentProfile - create one
                    var newProfile = new StudentProfile
                    {
                        UserId = existingUser.Id,
                        DepartmentId = departmentId,
                        YearId = yearId,
                        SquadronId = squadronId,
                        AdmissionYear = DateTime.UtcNow.Year,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    };

                    _dbContext.StudentProfiles.Add(newProfile);
                    await _dbContext.SaveChangesAsync();

                    // Ensure user has Student role
                    if (!await _userManager.IsInRoleAsync(existingUser, Roles.Student))
                    {
                        await _userManager.AddToRoleAsync(existingUser, Roles.Student);
                    }

                    Log.Debug("Created student profile for existing user: {Email}", rowData.Email);
                }

                return null; // Success
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Error updating existing user {Email}", rowData.Email);
                return new StudentImportErrorDto
                {
                    RowNumber = rowNumber,
                    Email = rowData.Email,
                    Error = $"Error updating existing user: {ex.Message}"
                };
            }
        }
        /// Creates a new user and their StudentProfile.
      
        private async Task<StudentImportErrorDto?> CreateNewUserAsync(
            int rowNumber,
            StudentImportRowDto rowData,
            int departmentId,
            int yearId,
            int squadronId,
            HashSet<string> existingEmails)
        {
            ApplicationUser? user = null;
            
            try
            {
                user = new ApplicationUser
                {
                    UserName = rowData.Email,
                    Email = rowData.Email,
                    FullName = rowData.FullName,
                    NationalId = string.IsNullOrWhiteSpace(rowData.NationalId) ? null : rowData.NationalId,
                    EmailConfirmed = true,
                    IsActive = true,
                    IsActivated = false,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };

                var createResult = await _userManager.CreateAsync(user);
                if (!createResult.Succeeded)
                {
                    var errors = string.Join("; ", createResult.Errors.Select(e => e.Description));
                    return new StudentImportErrorDto
                    {
                        RowNumber = rowNumber,
                        Email = rowData.Email,
                        Error = $"User creation failed: {errors}"
                    };
                }

                var roleResult = await _userManager.AddToRoleAsync(user, Roles.Student);
                if (!roleResult.Succeeded)
                {
                    // Rollback: Delete the user we just created
                    await _userManager.DeleteAsync(user);
                    var errors = string.Join("; ", roleResult.Errors.Select(e => e.Description));
                    return new StudentImportErrorDto
                    {
                        RowNumber = rowNumber,
                        Email = rowData.Email,
                        Error = $"Role assignment failed: {errors}"
                    };
                }

                var profile = new StudentProfile
                {
                    UserId = user.Id,
                    DepartmentId = departmentId,
                    YearId = yearId,
                    SquadronId = squadronId,
                    AdmissionYear = DateTime.UtcNow.Year,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };

                _dbContext.StudentProfiles.Add(profile);
                await _dbContext.SaveChangesAsync();

                // Track the email so we don't create duplicates within same import
                existingEmails.Add(rowData.Email.ToLowerInvariant());

                Log.Debug("Successfully created new student: {Email}", rowData.Email);
                return null;
            }
            catch (Exception ex)
            {
                // Rollback: Delete the user if it was created
                if (user != null && user.Id > 0)
                {
                    try
                    {
                        await _userManager.DeleteAsync(user);
                    }
                    catch
                    {
                        Log.Warning("Failed to cleanup user {Email} after error", rowData.Email);
                    }
                }
                
                Log.Error(ex, "Error creating new student {Email}", rowData.Email);
                return new StudentImportErrorDto
                {
                    RowNumber = rowNumber,
                    Email = rowData.Email,
                    Error = $"Unexpected error: {ex.Message}"
                };
            }
        }

         
        /// Simple email format validation.
         
        private static bool IsValidEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }
    }
}
