
namespace SkyLearnApi.Extentions
{
    public static class DatabaseExtensions
    {
        public static IServiceCollection AddDatabase(
            this IServiceCollection services,
            IConfiguration configuration)
        {
            services.AddDbContext<AppDbContext>(options =>
                options.UseSqlServer(
                    configuration.GetConnectionString("DefaultConnection"),
                    sqlServerOptions =>
                    {
                        sqlServerOptions.EnableRetryOnFailure(
                            maxRetryCount: 5,                
                            maxRetryDelay: TimeSpan.FromSeconds(10), 
                            errorNumbersToAdd: null          
                        );
                    }));

            return services;
        }
    }
}
