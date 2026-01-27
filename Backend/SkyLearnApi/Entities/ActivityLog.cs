namespace SkyLearnApi.Entities
{
    public class ActivityLog
    {
        public long Id { get; set; }
        public string ActionName { get; set; } = string.Empty;
        public string? EntityName { get; set; }
        public int? EntityId { get; set; }
        public string? Description { get; set; }
        public int? UserId { get; set; }
        public ApplicationUser? User { get; set; }
        public string? SessionId { get; set; }
        public DateTime? LoginTime { get; set; }
        public DateTime? LogoutTime { get; set; }
        public long? SessionDurationSeconds { get; set; }
        public string? IpAddress { get; set; }
        public string? UserAgent { get; set; }
        public string? Jti { get; set; }
        public DateTime? TokenExpiresAt { get; set; }
        public string? Metadata { get; set; }
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
        public long? ProcessingTimeMs { get; set; }
    }
}
