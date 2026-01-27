namespace SkyLearnApi.Services
{
    public class AuditService
    {
        private readonly AppDbContext _db;

        public AuditService(AppDbContext db)
        {
            _db = db;
        }

        public async Task LogAsync(string action, string? description = null, string? entityName = null, int? userId = null, string? jti = null, DateTime? expiresAt = null)
        {
            var audit = new AuditLog
            {
                UserId = userId,
                Action = action,
                Description = description,
                EntityName = entityName,
                Jti = jti,
                ExpiresAt = expiresAt
            };

            _db.AuditLogs.Add(audit);
            await _db.SaveChangesAsync();
        }
    }
}
