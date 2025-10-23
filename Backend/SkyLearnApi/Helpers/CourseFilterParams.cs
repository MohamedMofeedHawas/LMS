namespace SkyLearnApi.Helpers
{
    public class CourseFilterParams
    {
        public int? DepartmentId { get; set; }
        public int? YearId { get; set; }
        public string? Search { get; set; }   // title or description
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 9;
    }
}
