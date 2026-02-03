

namespace SkyLearnApi.Configuration
{
    public class ApplicationUserConfiguration : IEntityTypeConfiguration<ApplicationUser>
    {
        public void Configure(EntityTypeBuilder<ApplicationUser> builder)
        {
            builder.Property(u => u.FullName)
                   .IsRequired()
                   .HasMaxLength(150);

            builder.Property(u => u.NationalId)
                   .HasMaxLength(14);

            builder.Property(u => u.Gender)
                   .HasMaxLength(20);

            builder.Property(u => u.City)
                   .HasMaxLength(50);

            builder.Property(u => u.ProfileImageUrl)
                   .HasMaxLength(500);

            builder.Property(u => u.IsActive)
                   .HasDefaultValue(true);

            builder.Property(u => u.CreatedAt)
                   .HasDefaultValueSql("GETUTCDATE()");

            builder.Property(u => u.UpdatedAt)
                   .HasDefaultValueSql("GETUTCDATE()");

            builder.HasIndex(u => u.NationalId)
                   .IsUnique()
                   .HasFilter("[NationalId] IS NOT NULL");

            // Navigation properties to logs removed
            // Logs are now accessed via IActivityService for cleaner architecture
        }
    }
}
