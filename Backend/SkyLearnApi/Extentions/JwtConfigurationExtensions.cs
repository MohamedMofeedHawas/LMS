namespace SkyLearnApi.Extentions
{
    public static class JwtConfigurationExtensions
    {
        public static IServiceCollection AddJwtConfiguration(
            this IServiceCollection services,
            IConfiguration configuration)
        {
            services.Configure<JwtSettings>(
                configuration.GetSection("Jwt"));

            return services;
        }
    }

}
