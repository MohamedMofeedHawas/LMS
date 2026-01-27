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
        public string? Role { get; set; }
       public string? Search { get; set; }
        public bool? IsActive { get; set; }
        public string SortBy { get; set; } = "CreatedAt"; 
        public string SortDirection { get; set; } = "desc";
    }
}
