using System.Security.Claims;
using System.Text.Json;
using SkyLearnApi.Services;

namespace SkyLearnApi.Middleware
{
    public class AuditMiddleware
    {
        private readonly RequestDelegate _next;

        public AuditMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context, IAuditService auditService)
        {
            var action = $"{context.Request.Method} {context.Request.Path}";
            var description = $"Request from {context.Connection.RemoteIpAddress}";
            string? entityName = context.Request.Path.Value?.Split('/').LastOrDefault();

            await _next(context);


            var userIdClaim = context.User.FindFirst("UserId")?.Value;
            int? userId = int.TryParse(userIdClaim, out var uid) ? uid : null;
            var groupName = context.User.FindFirst("GroupName")?.Value;
            var academicYear = context.User.FindFirst("AcademicYear")?.Value;

            var jti = context.User.FindFirst(JwtRegisteredClaimNames.Jti)?.Value;
            var expClaim = context.User.FindFirst("exp")?.Value;

            if (context.User.Identity is { IsAuthenticated: true })
                await auditService.LogAsync(new AuditLog
                {
                    UserId = userId,
                    Action = action,
                    Description = description,
                    EntityName = entityName,
                    Jti = jti,
                    ExpiresAt = string.IsNullOrEmpty(expClaim) ? null : DateTimeOffset.FromUnixTimeSeconds(long.Parse(expClaim)).UtcDateTime,
                    CreatedAt = DateTime.UtcNow,
                    GroupName = groupName,
                    AcademicYear = academicYear
                });
        }
    }

    public static class AuditMiddlewareExtensions
    {
        public static IApplicationBuilder UseAuditLogging(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<AuditMiddleware>();
        }
    }
}
