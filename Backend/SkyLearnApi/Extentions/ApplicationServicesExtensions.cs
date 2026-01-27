using SkyLearnApi.Filters;
using SkyLearnApi.Services.Implementation;
using SkyLearnApi.Services.Interfaces;

namespace SkyLearnApi.Extentions
{
    public static class ApplicationServicesExtensions
    {
        public static IServiceCollection AddApplicationServices(
            this IServiceCollection services)
        {
            // Unified Activity Service (replaces both AuditService and AnalyticsService)
            services.AddScoped<IActivityService, ActivityService>();           
            // JWT Service 
            services.AddScoped<IJwtService, JwtService>();
            // Core Services
            services.AddScoped<IAuthService, AuthService>();
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<IYearService, YearService>();
            services.AddScoped<ICourseService, CourseService>();
            services.AddScoped<IDepartmentService, DepartmentService>();
            services.AddScoped<ISquadronService, SquadronService>();        
            // Import Services - Bulk operations, separated from CRUD services
            services.AddScoped<IStudentImportService, StudentImportService>();            
            // Activity Tracking Filter - Issue #8 fix: Cross-cutting concerns
            services.AddScoped<ActivityTrackingFilter>();           
            services.AddProblemDetails();
            services.AddHttpContextAccessor();
            return services;
        }
    }
}
