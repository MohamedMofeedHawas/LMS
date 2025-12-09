namespace SkyLearnApi.Configurations;

public class AssignmentSubmissionConfiguration : IEntityTypeConfiguration<AssignmentSubmission>
{
    public void Configure(EntityTypeBuilder<AssignmentSubmission> builder)
    {
        builder.ToTable("AssignmentSubmissions");

        builder.HasKey(s => s.Id);

        builder.Property(s => s.FileUrl)
            .IsRequired()
            .HasMaxLength(2000);

        builder.Property(s => s.SubmittedAt)
            .HasDefaultValueSql("GETUTCDATE()");

        builder.Property(s => s.Grade)
            .HasMaxLength(20)
            .IsRequired(false);

        builder.Property(s => s.Feedback)
            .HasMaxLength(4000)
            .IsRequired(false);

        builder.HasOne(s => s.Assignment)
            .WithMany(a => a.Submissions)
            .HasForeignKey(s => s.AssignmentId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(s => s.Student)
            .WithMany()
            .HasForeignKey(s => s.StudentId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasIndex(s => new { s.AssignmentId, s.StudentId });
    }
}