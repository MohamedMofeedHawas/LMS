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

        public async Task InvokeAsync(HttpContext context, AuditService auditService)
        {
            var userIdClaim = context.User.FindFirst("UserId")?.Value;
            int? userId = int.TryParse(userIdClaim, out var uid) ? uid : null;

            
            var action = $"{context.Request.Method} {context.Request.Path}";
            var description = $"Request from {context.Connection.RemoteIpAddress}";
            string? entityName = context.Request.Path.Value?.Split('/').LastOrDefault();

            
            await _next(context);

            
            await auditService.LogAsync(action, description, entityName, userId);
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
