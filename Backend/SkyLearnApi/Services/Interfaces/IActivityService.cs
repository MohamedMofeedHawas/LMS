

namespace SkyLearnApi.Services.Interfaces
{
    public interface IActivityService
    {
        // Tracks a general activity/event
        Task TrackAsync(
            string actionName,
            int? userId = null,
            string? entityName = null,
            int? entityId = null,
            string? description = null,
            object? metadata = null,
            long? processingTimeMs = null);

        // Tracks a user login event with session initialization
        Task TrackLoginAsync(
            int userId,
            string? sessionId = null,
            string? jti = null,
            DateTime? tokenExpiresAt = null,
            object? metadata = null);

        // Tracks a user logout event and calculates session duration
        Task TrackLogoutAsync(
            int? userId,
            string? sessionId = null,
            string? jti = null,
            object? metadata = null);

        // Tracks a failed login attempt
        Task TrackLoginFailedAsync(
            string attemptedEmail,
            string? reason = null,
            object? metadata = null);

        // Tracks entity-specific actions (CRUD operations)
        Task TrackEntityActionAsync(
            string actionName,
            string entityName,
            int entityId,
            int? userId = null,
            string? description = null,
            object? metadata = null,
            long? processingTimeMs = null);

        // Tracks raw ActivityLog entity (for advanced scenarios)
        Task TrackRawAsync(ActivityLog activityLog);

        // Gets the current request's session ID
        string? GetCurrentSessionId();

        // Gets the current request's IP address
        string? GetCurrentIpAddress();
    }
}
