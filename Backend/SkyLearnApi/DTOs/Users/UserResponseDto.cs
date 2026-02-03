namespace SkyLearnApi.Dtos.Users
{
    /// DTO for returning user data in API responses.
    /// 
    /// Note: Internal flags (IsActive, IsActivated) are NOT exposed directly.
    /// Instead, a computed AccountStatus field provides a business-friendly representation:
    /// "Disabled" = Admin disabled the account
    /// "PendingActivation" = Account enabled but user hasn't set password yet
    /// "Active" = Fully operational account
    /// Computed account status for non-technical admins.
     
    public class UserResponseDto
    {
        public int Id { get; set; }
        public string Email { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
        public string? NationalId { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? Gender { get; set; }
        public string? City { get; set; }
        public string? ProfileImageUrl { get; set; }
        public string AccountStatus { get; set; } = string.Empty;

        public bool EmailConfirmed { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public DateTime? LastLoginAt { get; set; }

        /// Polymorphic: Only present for Students, null for Admin/Instructor
        public SkyLearnApi.DTOs.Users.AcademicInfoDto? AcademicInfo { get; set; }
    }

   
    /// Paginated response wrapper for user lists
    
    public class PagedUsersResponseDto
    {
        public List<UserResponseDto> Users { get; set; } = new();
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
        public bool HasNextPage => PageNumber < TotalPages;
        public bool HasPreviousPage => PageNumber > 1;
    }
}
