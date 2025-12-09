namespace SkyLearnApi.Configurations;

public class CourseInstructorConfiguration : IEntityTypeConfiguration<CourseInstructor>
{
    public void Configure(EntityTypeBuilder<CourseInstructor> builder)
    {
        builder.ToTable("CourseInstructors");

        builder.HasKey(ci => ci.Id);

        builder.HasOne(ci => ci.Course)
            .WithMany(c => c.Instructors)
            .HasForeignKey(ci => ci.CourseId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(ci => ci.Instructor)
            .WithMany() // ApplicationUser nav not assumed
            .HasForeignKey(ci => ci.InstructorId)
            .OnDelete(DeleteBehavior.Restrict);

        // prevent duplicate pairing (course + instructor)
        builder.HasIndex(ci => new { ci.CourseId, ci.InstructorId }).IsUnique();
    }
}