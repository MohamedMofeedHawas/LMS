using Serilog;
using SkyLearnApi.Middleware;

namespace SkyLearnApi.Extentions
{
    public static class MiddlewareExtensions
    {
        public static IApplicationBuilder UseGlobalExceptionHandler(this IApplicationBuilder app)
        {
            return app.UseMiddleware<GlobalExceptionMiddleware>();
        }

        public static IApplicationBuilder UseSerilogLogging(this IApplicationBuilder app)
        {
            return app.UseSerilogRequestLogging(options =>
            {
                options.GetLevel = (httpContext, elapsed, ex) =>
                {
                    if (ex != null) return Serilog.Events.LogEventLevel.Error;
                    if (httpContext.Response.StatusCode >= 500) return Serilog.Events.LogEventLevel.Error;
                    if (httpContext.Response.StatusCode >= 400) return Serilog.Events.LogEventLevel.Warning;
                    return Serilog.Events.LogEventLevel.Information;
                };
                
                options.EnrichDiagnosticContext = (diagnosticContext, httpContext) =>
                {
                    diagnosticContext.Set("RequestHost", httpContext.Request.Host.Value);
                    diagnosticContext.Set("RequestScheme", httpContext.Request.Scheme);
                    diagnosticContext.Set("RequestPath", httpContext.Request.Path.ToString());
                    diagnosticContext.Set("RemoteIP", httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown");
                    diagnosticContext.Set("StatusCode", httpContext.Response.StatusCode);
                    
                    var userId = httpContext.User.FindFirst("UserId")?.Value;
                    if (!string.IsNullOrEmpty(userId))
                    {
                        diagnosticContext.Set("UserId", userId);
                    }
                    
                    var roles = httpContext.User.Claims
                        .Where(c => c.Type == System.Security.Claims.ClaimTypes.Role)
                        .Select(c => c.Value)
                        .ToList();
                    if (roles.Any())
                    {
                        diagnosticContext.Set("UserRoles", string.Join(",", roles));
                    }
                };
            });
        }

        public static WebApplication ConfigureMiddlewarePipeline(this WebApplication app)
        {
            app.UsePathBase(app.Configuration.GetValue<string>("PathBase") ?? "/");
            app.UseSerilogLogging();
            app.UseGlobalExceptionHandler();
            
            app.UseSwagger();
            app.UseSwaggerUI(options =>
            {
                options.SwaggerEndpoint("/swagger/v1/swagger.json", "SkyLearn API v1");
                options.RoutePrefix = string.Empty;
            });
            
            app.UseStaticFiles();
            app.UseCors("AllowAll");
            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();
            app.MapControllers();
            
            return app;
        }
    }
}
