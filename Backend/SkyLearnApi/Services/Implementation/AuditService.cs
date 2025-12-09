using SkyLearnApi.Services.Base;

namespace SkyLearnApi.Services.Implementation
{
    public class AuditService : IAuditService
    {
        private readonly AppDbContext _db;
        private readonly ICurrentUserService _currentUserService;

        public AuditService(AppDbContext db, ICurrentUserService currentUserService)
        {
            _db = db;
            _currentUserService = currentUserService;
        }

        public async Task LogAuditAsync(string action, string description, string entityName)
        {
            await LogAsync(new AuditLog
            {
                UserId = _currentUserService.UserId,
                Action = action,
                Description = description,
                EntityName = entityName,
                Jti = _currentUserService.Jti,
                CreatedAt = DateTime.UtcNow,
                ExpiresAt = _currentUserService.ExpiresAt,
                GroupName = _currentUserService.GroupName,
                AcademicYear = _currentUserService.AcademicYear
            });
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
                ExpiresAt = expiresAt,
                IsActive = true
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
