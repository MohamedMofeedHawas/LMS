namespace SkyLearnApi.Entities
{
    public class ApplicationUser : IdentityUser<int>
    {        public string FullName { get; set; } = string.Empty;
        public string? NationalId { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? Gender { get; set; }
        public string? City { get; set; }
        public string? ProfileImageUrl { get; set; }
        public bool IsActive { get; set; } = true;
        /// Indicates whether the user has completed first-time activation (password setup)
        /// In this closed system, Admins create users WITHOUT passwords
        /// Users must set their password on first login to activate their account
        /// important //////////////////////////////////////////////////
        public bool IsActivated { get; set; } = false;       
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? LastLoginAt { get; set; }
    }
}
