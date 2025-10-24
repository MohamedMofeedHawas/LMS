using System;
using System.Threading.Tasks;

namespace SkyLearnApi.Services.Interfaces
{
    public interface IAuditService
    {
        Task LogAsync(string action, string? description = null, string? entityName = null, int? userId = null, string? jti = null, DateTime? expiresAt = null);
        Task LogAsync(AuditLog auditLog);
    }
}
