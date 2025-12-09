using SkyLearnApi.Services.Base;

namespace SkyLearnApi.Middleware
{
    public class AuditMiddleware
    {
        private readonly RequestDelegate _next;

        public AuditMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context, IAuditService auditService, ICurrentUserService currentUserService)
        {
            var action = $"{context.Request.Method} {context.Request.Path}";
            var description = $"";
            string? entityName = context.Request.Path.Value?.Split('/').LastOrDefault();

            await _next(context);


            if (context.User.Identity is { IsAuthenticated: true })
                await auditService.LogAsync(new AuditLog
                {
                    UserId = currentUserService.UserId,
                    Action = action,
                    Description = description,
                    EntityName = entityName,
                    Jti = currentUserService.Jti,
                    ExpiresAt = currentUserService.ExpiresAt,
                    CreatedAt = DateTime.UtcNow,
                    GroupName = currentUserService.GroupName,
                    AcademicYear = currentUserService.AcademicYear
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
