namespace SkyLearnApi.Configurations
{
    public class EnrollmentConfiguration : IEntityTypeConfiguration<Enrollment>
    {
        public void Configure(EntityTypeBuilder<Enrollment> builder)
        {
            builder.ToTable("Enrollments");

            builder.HasKey(e => e.Id);

            // Composite unique index: a student can only be enrolled once in a course
            builder.HasIndex(e => new { e.StudentProfileId, e.CourseId })
                .IsUnique()
                .HasDatabaseName("IX_Enrollment_Student_Course");

            // Relationship: StudentProfile
            builder.HasOne(e => e.StudentProfile)
                .WithMany()
                .HasForeignKey(e => e.StudentProfileId)
                .OnDelete(DeleteBehavior.Cascade);

            // Relationship: Course
            builder.HasOne(e => e.Course)
                .WithMany()
                .HasForeignKey(e => e.CourseId)
                .OnDelete(DeleteBehavior.Cascade);

            // Relationship: EnrolledBy (Admin/Instructor)
            builder.HasOne(e => e.EnrolledBy)
                .WithMany()
                .HasForeignKey(e => e.EnrolledById)
                .OnDelete(DeleteBehavior.Restrict);

            builder.Property(e => e.EnrolledAt)
                .HasDefaultValueSql("GETUTCDATE()");

            // Index for querying by course
            builder.HasIndex(e => e.CourseId)
                .HasDatabaseName("IX_Enrollment_CourseId");
        }
    }
}
