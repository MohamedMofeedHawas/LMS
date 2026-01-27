using Serilog;

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
                        "Unhandled exception occurred. Path: {Path}, Method: {Method}, StatusCode: {StatusCode}",
                        context.Request.Path,
                        context.Request.Method,
                        context.Response.StatusCode);

                    var statusCode = ex switch
                    {
                        KeyNotFoundException => StatusCodes.Status404NotFound,
                        UnauthorizedAccessException => StatusCodes.Status401Unauthorized,
                        ArgumentException => StatusCodes.Status400BadRequest,
                        _ => StatusCodes.Status500InternalServerError
                    };

                    context.Response.ContentType = "application/problem+json";
                    context.Response.StatusCode = statusCode;

                    var problemDetails = new ProblemDetails
                    {
                        Status = statusCode,
                        Title = statusCode switch
                        {
                            400 => "Bad Request",
                            401 => "Unauthorized",
                            404 => "Not Found",
                            _ => "Internal Server Error"
                        },
                        Detail = _env.IsDevelopment()
                            ? ex.Message
                            : null,
                        Instance = context.Request.Path
                    };

                    if (_env.IsDevelopment())
                    {
                        problemDetails.Extensions["stackTrace"] = ex.StackTrace;
                    }
                    

                    await context.Response.WriteAsJsonAsync(problemDetails);
                }
            }
        }
    }

