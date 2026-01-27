namespace SkyLearnApi.Extentions
{
    public static class MapsterExtensions
    {
        public static IServiceCollection AddMapsterConfiguration(
            this IServiceCollection services)
        {
            var config = TypeAdapterConfig.GlobalSettings;

            services.AddSingleton(config);
            services.AddScoped<IMapper, ServiceMapper>();

            MapConfig.RegisterMappings();

            return services;
        }
    }

}
