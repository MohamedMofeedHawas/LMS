namespace SkyLearnApi.Services.Interfaces
{
    public interface IAuditService
    {
        Task LogAuditAsync(string action, string description, string entityName);
        Task LogAsync(string action, string? description = null, string? entityName = null, int? userId = null, string? jti = null, DateTime? expiresAt = null);
        Task LogAsync(AuditLog auditLog);
    }
}
