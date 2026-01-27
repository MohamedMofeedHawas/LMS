using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using SkyLearnApi.Configuration;
using SkyLearnApi.Entities;

namespace SkyLearnApi.Data
{
    public class AppDbContext : IdentityDbContext<ApplicationUser, IdentityRole<int>, int>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        // Entity DbSets
        public DbSet<Department> Departments { get; set; }
        public DbSet<Year> Years { get; set; }
        public DbSet<Course> Courses { get; set; }
        
        // Student Academic Context
        public DbSet<Squadron> Squadrons { get; set; }
        public DbSet<StudentProfile> StudentProfiles { get; set; }
        
        // Unified Activity/Analytics Logging
        public DbSet<ActivityLog> ActivityLogs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Apply all Fluent API configurations
            modelBuilder.ApplyConfiguration(new ApplicationUserConfiguration());
            modelBuilder.ApplyConfiguration(new DepartmentConfiguration());
            modelBuilder.ApplyConfiguration(new YearConfiguration());
            modelBuilder.ApplyConfiguration(new CourseConfiguration());
            modelBuilder.ApplyConfiguration(new SquadronConfiguration());
            modelBuilder.ApplyConfiguration(new StudentProfileConfiguration());
            modelBuilder.ApplyConfiguration(new ActivityLogConfiguration());
        }
    }
}
