

namespace SkyLearnApi.Configuration
{
    public class StudentProfileConfiguration : IEntityTypeConfiguration<StudentProfile>
    {
        public void Configure(EntityTypeBuilder<StudentProfile> builder)
        {
            builder.ToTable("StudentProfiles");

            builder.HasKey(sp => sp.Id);

            // 1:1 relationship with ApplicationUser (unique UserId)
            builder.HasIndex(sp => sp.UserId)
                .IsUnique()
                .HasDatabaseName("IX_StudentProfile_UserId");

            builder.HasOne(sp => sp.User)
                .WithOne()
                .HasForeignKey<StudentProfile>(sp => sp.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // N:1 with Department
            builder.HasOne(sp => sp.Department)
                .WithMany()
                .HasForeignKey(sp => sp.DepartmentId)
                .OnDelete(DeleteBehavior.Restrict);

            // N:1 with Year
            builder.HasOne(sp => sp.Year)
                .WithMany()
                .HasForeignKey(sp => sp.YearId)
                .OnDelete(DeleteBehavior.Restrict);

            // N:1 with Squadron
            builder.HasOne(sp => sp.Squadron)
                .WithMany(s => s.Students)
                .HasForeignKey(sp => sp.SquadronId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.Property(sp => sp.AdmissionYear)
                .IsRequired();

            builder.Property(sp => sp.CreatedAt)
                .HasDefaultValueSql("GETUTCDATE()");

            // Composite indexes for common queries
            builder.HasIndex(sp => sp.DepartmentId)
                .HasDatabaseName("IX_StudentProfile_DepartmentId");

            builder.HasIndex(sp => sp.YearId)
                .HasDatabaseName("IX_StudentProfile_YearId");

            builder.HasIndex(sp => sp.SquadronId)
                .HasDatabaseName("IX_StudentProfile_SquadronId");

            builder.HasIndex(sp => new { sp.DepartmentId, sp.YearId })
                .HasDatabaseName("IX_StudentProfile_Department_Year");
        }
    }
}
