using Microsoft.EntityFrameworkCore;
using SkyLearnApi.Configuration;
using SkyLearnApi.Entities;

namespace SkyLearnApi.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<ApplicationUser> Users { get; set; }
        public DbSet<AuditLog> AuditLogs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            
            modelBuilder.ApplyConfiguration(new UserConfiguration());
            
            modelBuilder.Entity<AuditLog>()
           .HasOne(a => a.User)
           .WithMany(u => u.AuditLogs)
           .HasForeignKey(a => a.UserId)
           .OnDelete(DeleteBehavior.SetNull);
        }
    }
}
