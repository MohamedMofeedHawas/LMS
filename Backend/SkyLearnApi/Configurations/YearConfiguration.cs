

namespace SkyLearnApi.Configurations
{
    public class YearConfiguration : IEntityTypeConfiguration<Year>
    {
              public void Configure(EntityTypeBuilder<Year> builder)
              {
                     // Table
                     builder.ToTable("Years");

                     // Primary Key
                     builder.HasKey(y => y.Id);

                     // Properties
                     builder.Property(y => y.Name)
                            .IsRequired()
                            .HasMaxLength(100);

                     builder.Property(y => y.Description)
                            .HasMaxLength(500);

                     builder.Property(y => y.TotalCourses)
                            .HasDefaultValue(0);

                     builder.Property(y => y.TotalHours)
                            .HasDefaultValue(0);

                     builder.Property(y => y.StartDate)
                            .IsRequired();

                     builder.Property(y => y.EndDate)
                            .IsRequired();

                     builder.Property(y => y.CreatedAt)
                            .HasDefaultValueSql("GETUTCDATE()");

                     builder.Property(y => y.UpdatedAt)
                            .HasDefaultValueSql("GETUTCDATE()");

                     builder.Property(y => y.CreatedById)
                            .IsRequired();

                     // Relationships

                     // Year ↔ Department (Many-to-One)
                     builder.HasOne(y => y.Department)
                            .WithMany(d => d.Years)
                            .HasForeignKey(y => y.DepartmentId)
                            .OnDelete(DeleteBehavior.Cascade);

                     // Year ↔ User (CreatedBy)
                     builder.HasOne(y => y.CreatedBy)
                            .WithMany()
                            .HasForeignKey(y => y.CreatedById)
                            .OnDelete(DeleteBehavior.Restrict);

                     // Year ↔ Courses (One-to-Many)
                     builder.HasMany(y => y.Courses)
                            .WithOne(c => c.Year)
                            .HasForeignKey(c => c.YearId)
                            .OnDelete(DeleteBehavior.Restrict);
              }
    }
}
