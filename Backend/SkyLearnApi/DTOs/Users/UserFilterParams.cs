namespace SkyLearnApi.Dtos.Users
{
     
    /// Query parameters for filtering and paginating users
     
    public class UserFilterParams
    {
        private const int MaxPageSize = 50;
        private int _pageSize = 10;

        public int PageNumber { get; set; } = 1;
        
        public int PageSize
        {
            get => _pageSize;
            set => _pageSize = value > MaxPageSize ? MaxPageSize : value;
        }

         
        /// Filter by role: Admin, Instructor, Student
         
        public string? Role { get; set; }

         
        /// Search in email and full name
         
        public string? Search { get; set; }

         
        /// Filter by active status
         
        public bool? IsActive { get; set; }

         
        /// Sort field: FullName, Email, CreatedAt, LastLoginAt
         
        public string SortBy { get; set; } = "CreatedAt";

         
        /// Sort direction: asc or desc
         
        public string SortDirection { get; set; } = "desc";
    }
}
