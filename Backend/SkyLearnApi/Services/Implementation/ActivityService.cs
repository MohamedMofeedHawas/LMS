namespace SkyLearnApi.Services.Implementation
{
     
    /// Unified activity service that handles both audit logging and analytics tracking.
    /// Uses a separate DI scope to avoid conflicts with the main request scope.
        public class ActivityService : IActivityService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public ActivityService(
            IServiceScopeFactory scopeFactory,
            IHttpContextAccessor httpContextAccessor)
        {
            _scopeFactory = scopeFactory;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task TrackAsync(
            string actionName,
            int? userId = null,
            string? entityName = null,
            int? entityId = null,
            string? description = null,
            object? metadata = null,
            long? processingTimeMs = null)
        {
            var activity = new ActivityLog
            {
                ActionName = actionName,
                UserId = userId,
                EntityName = entityName,
                EntityId = entityId,
                Description = description,
                Metadata = SerializeMetadata(metadata),
                ProcessingTimeMs = processingTimeMs,
                SessionId = GetCurrentSessionId(),
                IpAddress = GetCurrentIpAddress(),
                UserAgent = GetCurrentUserAgent(),
                Timestamp = DateTime.UtcNow
            };

            await TrackRawAsync(activity);
        }

        public async Task TrackLoginAsync(
            int userId,
            string? sessionId = null,
            string? jti = null,
            DateTime? tokenExpiresAt = null,
            object? metadata = null)
        {
            var now = DateTime.UtcNow;

            var activity = new ActivityLog
            {
                ActionName = ActivityActions.UserLoggedIn,
                UserId = userId,
                EntityName = "Auth",
                SessionId = sessionId ?? GetCurrentSessionId(),
                LoginTime = now,
                Jti = jti,
                TokenExpiresAt = tokenExpiresAt,
                Metadata = SerializeMetadata(metadata),
                IpAddress = GetCurrentIpAddress(),
                UserAgent = GetCurrentUserAgent(),
                Timestamp = now
            };

            await TrackRawAsync(activity);
        }

        public async Task TrackLogoutAsync(
            int? userId,
            string? sessionId = null,
            string? jti = null,
            object? metadata = null)
        {
            var now = DateTime.UtcNow;
            long? sessionDuration = null;

            // Calculate session duration from last login
            try
            {
                using var scope = _scopeFactory.CreateScope();
                var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

                var lastLogin = await db.ActivityLogs
                    .Where(a => a.UserId == userId &&
                                a.ActionName == ActivityActions.UserLoggedIn &&
                                a.LoginTime != null)
                    .OrderByDescending(a => a.LoginTime)
                    .FirstOrDefaultAsync();

                if (lastLogin?.LoginTime != null)
                {
                    sessionDuration = (long)(now - lastLogin.LoginTime.Value).TotalSeconds;
                }
            }
            catch (Exception ex)
            {
                Log.Warning(ex, "Failed to calculate session duration for UserId: {UserId}", userId);
                // Continue without session duration - don't break the logout
            }

            var activity = new ActivityLog
            {
                ActionName = ActivityActions.UserLoggedOut,
                UserId = userId,
                EntityName = "Auth",
                SessionId = sessionId ?? GetCurrentSessionId(),
                LogoutTime = now,
                SessionDurationSeconds = sessionDuration,
                Jti = jti,
                Metadata = SerializeMetadata(metadata),
                IpAddress = GetCurrentIpAddress(),
                UserAgent = GetCurrentUserAgent(),
                Timestamp = now
            };

            await TrackRawAsync(activity);
        }

        public async Task TrackLoginFailedAsync(
            string attemptedEmail,
            string? reason = null,
            object? metadata = null)
        {
            var combinedMetadata = new
            {
                attemptedEmail,
                reason,
                additionalData = metadata
            };

            var activity = new ActivityLog
            {
                ActionName = ActivityActions.LoginFailed,
                EntityName = "Auth",
                Description = $"Login failed for {attemptedEmail}: {reason ?? "Invalid credentials"}",
                Metadata = SerializeMetadata(combinedMetadata),
                IpAddress = GetCurrentIpAddress(),
                UserAgent = GetCurrentUserAgent(),
                Timestamp = DateTime.UtcNow
            };

            await TrackRawAsync(activity);
        }

        public async Task TrackEntityActionAsync(
            string actionName,
            string entityName,
            int entityId,
            int? userId = null,
            string? description = null,
            object? metadata = null,
            long? processingTimeMs = null)
        {
            var activity = new ActivityLog
            {
                ActionName = actionName,
                EntityName = entityName,
                EntityId = entityId,
                UserId = userId,
                Description = description,
                Metadata = SerializeMetadata(metadata),
                ProcessingTimeMs = processingTimeMs,
                SessionId = GetCurrentSessionId(),
                IpAddress = GetCurrentIpAddress(),
                UserAgent = GetCurrentUserAgent(),
                Timestamp = DateTime.UtcNow
            };

            await TrackRawAsync(activity);
        }

        public async Task TrackRawAsync(ActivityLog activityLog)
        {
            try
            {
                using var scope = _scopeFactory.CreateScope();
                var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

                db.ActivityLogs.Add(activityLog);
                await db.SaveChangesAsync();

                Log.Debug("Activity tracked: {ActionName} for User {UserId}, Entity: {EntityName}",
                    activityLog.ActionName, activityLog.UserId, activityLog.EntityName);
            }
            catch (Exception ex)
            {
                // Issue #3 fix: Log the error instead of silent swallowing
                Log.Error(ex, 
                    "Failed to track activity: {ActionName}, UserId: {UserId}, EntityName: {EntityName}, EntityId: {EntityId}",
                    activityLog.ActionName, 
                    activityLog.UserId, 
                    activityLog.EntityName,
                    activityLog.EntityId);

                // Don't rethrow - activity tracking failure shouldn't break the main request
            }
        }

        public string? GetCurrentSessionId()
        {
            return _httpContextAccessor.HttpContext?.Request.Headers["X-Session-Id"].FirstOrDefault();
        }

        public string? GetCurrentIpAddress()
        {
            return _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString();
        }

        private string? GetCurrentUserAgent()
        {
            return _httpContextAccessor.HttpContext?.Request.Headers["User-Agent"].FirstOrDefault();
        }

        private static string? SerializeMetadata(object? metadata)
        {
            if (metadata == null) return null;

            try
            {
                return JsonSerializer.Serialize(metadata, new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                });
            }
            catch (Exception ex)
            {
                Log.Warning(ex, "Failed to serialize activity metadata");
                return null;
            }
        }
    }
}
