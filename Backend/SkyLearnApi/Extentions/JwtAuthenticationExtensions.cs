using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using System.Security.Claims;
using System.Text;

namespace SkyLearnApi.Extentions
{
    public static class JwtAuthenticationExtensions
    {
        public static IServiceCollection AddJwtAuthentication(
            this IServiceCollection services,
            IConfiguration configuration)
        {
            var jwtSettings = configuration.GetSection("Jwt")
                .Get<JwtSettings>()
                ?? throw new Exception("JWT settings missing");

            var key = Encoding.UTF8.GetBytes(jwtSettings.Key);

            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.SaveToken = true;
                options.RequireHttpsMetadata = false;
                
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = true,
                    ValidIssuer = jwtSettings.Issuer,

                    ValidateAudience = true,
                    ValidAudience = jwtSettings.Audience,

                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),

                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.FromMinutes(5),

                    RoleClaimType = ClaimTypes.Role,
                    NameClaimType = ClaimTypes.NameIdentifier
                };

                options.Events = new JwtBearerEvents
                {
                    OnAuthenticationFailed = context =>
                    {
                        var error = context.Exception.Message;
                        Log.Warning("JWT Authentication failed: {Error}", error);
                        
                        context.Response.Headers.Append("X-Auth-Error", error);
                        return Task.CompletedTask;
                    },
                    OnTokenValidated = context =>
                    {
                        var userId = context.Principal?.FindFirst("UserId")?.Value;
                        var roles = context.Principal?.Claims
                            .Where(c => c.Type == ClaimTypes.Role || c.Type == "role")
                            .Select(c => c.Value)
                            .ToList();
                        
                        Log.Information("Token validated - UserId: {UserId}, Roles: {Roles}", 
                            userId, string.Join(",", roles ?? new List<string>()));
                        return Task.CompletedTask;
                    },
                    OnChallenge = context =>
                    {
                        context.HandleResponse();
                        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                        context.Response.ContentType = "application/json";
                        
                        var error = context.Error ?? "Token missing or invalid";
                        var errorDescription = context.ErrorDescription ?? "Authentication required";
                        
                        Log.Warning("JWT Challenge - Error: {Error}, Description: {Description}, Path: {Path}", 
                            error, errorDescription, context.Request.Path);
                        
                        return context.Response.WriteAsJsonAsync(new
                        {
                            status = 401,
                            message = "Unauthorized",
                            error = error,
                            description = errorDescription,
                            path = context.Request.Path.ToString(),
                            timestamp = DateTime.UtcNow
                        });
                    },
                    OnForbidden = context =>
                    {
                        context.Response.StatusCode = StatusCodes.Status403Forbidden;
                        context.Response.ContentType = "application/json";
                        
                        var userId = context.Principal?.FindFirst("UserId")?.Value;
                        var userRoles = context.Principal?.Claims
                            .Where(c => c.Type == ClaimTypes.Role || c.Type == "role")
                            .Select(c => c.Value)
                            .ToList();
                        
                        Log.Warning("JWT Forbidden - UserId: {UserId}, UserRoles: {UserRoles}, Path: {Path}", 
                            userId, string.Join(",", userRoles ?? new List<string>()), context.Request.Path);
                        
                        return context.Response.WriteAsJsonAsync(new
                        {
                            status = 403,
                            message = "Forbidden - Insufficient permissions",
                            userId = userId,
                            userRoles = userRoles,
                            path = context.Request.Path.ToString(),
                            hint = "This endpoint requires specific role(s). Check your user role.",
                            timestamp = DateTime.UtcNow
                        });
                    }
                };
            });

            return services;
        }
    }
}
