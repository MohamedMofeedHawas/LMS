using Microsoft.EntityFrameworkCore;

namespace SkyLearnApi.Middleware
{
    public class GlobalExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IWebHostEnvironment _env;

        public GlobalExceptionMiddleware(
            RequestDelegate next,
            IWebHostEnvironment env)
        {
            _next = next;
            _env = env;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {
                // Use Serilog for structured exception logging
                Log.Error(ex, 
                    "Exception occurred. Path: {Path}, Method: {Method}",
                    context.Request.Path,
                    context.Request.Method);

                var (statusCode, title, detail) = ex switch
                {
                    // Handle FK constraint violations - return 409 Conflict
                    DbUpdateException dbEx when IsForeignKeyViolation(dbEx) => (
                        StatusCodes.Status409Conflict,
                        "Conflict",
                        "Cannot delete this item because it is linked to other data in the system."
                    ),
                    
                    // Business rule violations
                    InvalidOperationException => (
                        StatusCodes.Status400BadRequest,
                        "Bad Request",
                        ex.Message
                    ),
                    
                    KeyNotFoundException => (
                        StatusCodes.Status404NotFound,
                        "Not Found",
                        (string?)null
                    ),
                    
                    UnauthorizedAccessException => (
                        StatusCodes.Status401Unauthorized,
                        "Unauthorized",
                        (string?)null
                    ),
                    
                    ArgumentException => (
                        StatusCodes.Status400BadRequest,
                        "Bad Request",
                        ex.Message
                    ),
                    
                    _ => (
                        StatusCodes.Status500InternalServerError,
                        "Internal Server Error",
                        (string?)null
                    )
                };

                context.Response.ContentType = "application/problem+json";
                context.Response.StatusCode = statusCode;

                var problemDetails = new ProblemDetails
                {
                    Status = statusCode,
                    Title = title,
                    Detail = detail ?? (_env.IsDevelopment() ? ex.Message : null),
                    Instance = context.Request.Path
                };

                if (_env.IsDevelopment() && statusCode == StatusCodes.Status500InternalServerError)
                {
                    problemDetails.Extensions["stackTrace"] = ex.StackTrace;
                }

                await context.Response.WriteAsJsonAsync(problemDetails);
            }
        }

        /// <summary>
        /// Simple check for FK constraint violation in DbUpdateException
        /// </summary>
        private static bool IsForeignKeyViolation(DbUpdateException ex)
        {
            var message = ex.InnerException?.Message ?? string.Empty;
            return message.Contains("REFERENCE constraint", StringComparison.OrdinalIgnoreCase)
                || message.Contains("FOREIGN KEY constraint", StringComparison.OrdinalIgnoreCase);
        }
    }
}

