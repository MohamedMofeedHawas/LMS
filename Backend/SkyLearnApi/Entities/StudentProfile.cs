namespace SkyLearnApi.Entities
{
    /// StudentProfile - academic context for students Only
    /// Admins/Instructors do NOT have profiles.
    public class StudentProfile
    {
        public int Id { get; set; }

        // 1:1 relationship with ApplicationUser
        public int UserId { get; set; }
        public ApplicationUser User { get; set; } = null!;
        public int DepartmentId { get; set; }
        public Department Department { get; set; } = null!;
        public int YearId { get; set; }
        public Year Year { get; set; } = null!;
        public int SquadronId { get; set; }
        public Squadron Squadron { get; set; } = null!;
        // Student-specific fields (moved from ApplicationUser for students)
        public int AdmissionYear { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    }
}
