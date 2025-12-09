namespace SkyLearnApi.Configurations;

public class EnrollmentConfiguration : IEntityTypeConfiguration<Enrollment>
{
    public void Configure(EntityTypeBuilder<Enrollment> builder)
    {
        builder.ToTable("Enrollments");

        builder.HasKey(e => e.Id);

        builder.Property(e => e.EnrolledAt)
            .HasDefaultValueSql(SqlFunctions.GetUtcDate);

        builder.Property(e => e.Status)
            .IsRequired();

        builder.Property(e => e.Grade)
            .HasMaxLength(20)
            .IsRequired(false);

        builder.Property(e => e.CompletedAt)
            .IsRequired(false);

        builder.Property(e => e.DroppedAt)
            .IsRequired(false);

        // relations
        builder.HasOne(e => e.Student)
            .WithMany()
            .HasForeignKey(e => e.StudentId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(e => e.Course)
            .WithMany(c => c.Enrollments)
            .HasForeignKey(e => e.CourseId)
            .OnDelete(DeleteBehavior.Cascade);

        // map Status int to EnrollmentStatus table
        builder.HasOne(e => e.EnrollmentStatus)
            .WithMany(es => es.Enrollments)
            .HasForeignKey(e => e.Status)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasIndex(e => new { e.StudentId, e.CourseId }).IsUnique(false);
    }
}