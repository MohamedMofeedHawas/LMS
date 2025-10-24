using SkyLearnApi.Data;
using SkyLearnApi.Entities;
using SkyLearnApi.Services.Interfaces;

namespace SkyLearnApi.Services
{
    public class AuditService : IAuditService
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

        public async Task LogAsync(AuditLog auditLog)
        {
            _db.AuditLogs.Add(auditLog);
            await _db.SaveChangesAsync();
        }
    }
}
