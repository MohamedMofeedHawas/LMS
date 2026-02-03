

namespace SkyLearnApi.Configurations
{
    public class CourseConfiguration : IEntityTypeConfiguration<Course>
    {
        public void Configure(EntityTypeBuilder<Course> builder)
        {
            builder.ToTable("Courses");

            builder.HasKey(c => c.Id);

            builder.Property(c => c.Title)
                .IsRequired()
                .HasMaxLength(150);

            builder.Property(c => c.Description)
                .HasMaxLength(1000);

            builder.Property(c => c.ImageUrl)
                .HasMaxLength(255);

            builder.Property(c => c.CreditHours)
                .IsRequired();

            builder.Property(c => c.EnrolledStudentsCount)
                .HasDefaultValue(0);

            builder.HasOne(c => c.Department)
                .WithMany(d => d.Courses)
                .HasForeignKey(c => c.DepartmentId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasOne(c => c.Year)
                .WithMany(y => y.Courses)
                .HasForeignKey(c => c.YearId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasOne(c => c.CreatedBy)
                .WithMany()
                .HasForeignKey(c => c.CreatedById)
                .OnDelete(DeleteBehavior.Restrict);

            builder.Property(c => c.CreatedAt)
                .HasDefaultValueSql("GETUTCDATE()");

              builder.HasIndex(c => c.YearId);
        }
    }
}
