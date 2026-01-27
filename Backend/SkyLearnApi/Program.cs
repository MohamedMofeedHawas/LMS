var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((context, services, configuration) => configuration
    .ReadFrom.Configuration(context.Configuration)
    .ReadFrom.Services(services)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .Enrich.WithThreadId()
    .Enrich.WithProperty("Application", "SkyLearnApi")
    .Enrich.WithProperty("Environment", context.HostingEnvironment.EnvironmentName));

builder.Services.AddDatabase(builder.Configuration);
builder.Services.AddIdentityServices();
builder.Services.AddAnalyticsServices(builder.Configuration);
builder.Services.AddJwtConfiguration(builder.Configuration);
builder.Services.AddJwtAuthentication(builder.Configuration);
builder.Services.AddMapsterConfiguration();
builder.Services.AddApplicationServices();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Issue #8 fix: Register ActivityTrackingFilter globally for all controllers
builder.Services.AddControllers(options =>
{
    options.Filters.Add<ActivityTrackingFilter>();
})
.AddJsonOptions(options =>
{
    options.JsonSerializerOptions.PropertyNameCaseInsensitive = true;
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerWithJwt();
builder.Services.AddAuthorization();
builder.Services.AddHttpContextAccessor();

var app = builder.Build();

Log.Information("SkyLearnApi Starting - Environment: {Environment}", app.Environment.EnvironmentName);

await app.Services.SeedRolesAsync();
await app.Services.SeedAdminUserAsync();

app.ConfigureMiddlewarePipeline();

try
{
    Log.Information("SkyLearnApi started successfully");
    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Application terminated unexpectedly");
}
finally
{
    Log.CloseAndFlush();
}
