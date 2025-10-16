using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SkyLearnApi.Entities;

namespace SkyLearnApi.Configuration
{
    public class UserConfiguration : IEntityTypeConfiguration<ApplicationUser>
    {
        public void Configure(EntityTypeBuilder<ApplicationUser> builder)
        {
            builder.ToTable("Users"); // اسم الجدول

            builder.HasKey(u => u.Id);

            builder.Property(u => u.Email)
                   .IsRequired()
                   .HasMaxLength(100);

            builder.Property(u => u.Password)
                   .IsRequired()
                   .HasMaxLength(200);

            builder.Property(u => u.FirstName)
                   .IsRequired()
                   .HasMaxLength(50);

            builder.Property(u => u.LastName)
                   .IsRequired()
                   .HasMaxLength(50);

            builder.Property(u => u.ProfileImageUrl)
                   .HasMaxLength(250);

            builder.Property(u => u.Gender)
                   .HasMaxLength(20);

            builder.Property(u => u.City)
                   .HasMaxLength(50);

            builder.Property(u => u.AcademicLevel)
                   .HasMaxLength(50);

            builder.Property(u => u.Role)
                   .HasConversion<string>()
                   .IsRequired();

        }
    }
}
