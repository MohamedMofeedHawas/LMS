namespace SkyLearnApi.Entities
{
    public class AuditLog
    {
        public int Id { get; set; }
        public int? UserId { get; set; }            // nullable for failed logins
        public string Action { get; set; } = null!;
        public string? Description { get; set; }
        public string? EntityName { get; set; }

        // store token id (jti) if this audit record refers to a token (login/logout/revoke)
        public string? Jti { get; set; }

        // token expiry if applicable (for revoke records)
        public DateTime? ExpiresAt { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public ApplicationUser? User { get; set; }
    }
}
