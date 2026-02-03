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
            services.AddScoped<IActivityService, ActivityService>();
            services.AddScoped<IJwtService, JwtService>();
            services.AddScoped<IAuthService, AuthService>();
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<IYearService, YearService>();
            services.AddScoped<ICourseService, CourseService>();
            services.AddScoped<IDepartmentService, DepartmentService>();
            services.AddScoped<ISquadronService, SquadronService>();
            services.AddScoped<IEnrollmentService, EnrollmentService>();
            services.AddScoped<IStudentImportService, StudentImportService>();
            services.AddScoped<ActivityTrackingFilter>();
            services.AddProblemDetails();
            services.AddHttpContextAccessor();
            return services;
        }
    }
}
