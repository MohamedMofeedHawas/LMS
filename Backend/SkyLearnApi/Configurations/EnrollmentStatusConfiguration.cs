namespace SkyLearnApi.Configurations;

public class EnrollmentStatusConfiguration : IEntityTypeConfiguration<EnrollmentStatus>
{
    public void Configure(EntityTypeBuilder<EnrollmentStatus> builder)
    {
        builder.ToTable("EnrollmentStatuses");

        builder.HasKey(es => es.Id);

        builder.Property(es => es.Name)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(es => es.IsActive)
            .HasDefaultValue(true);

        builder.HasIndex(es => es.Name).IsUnique();
    }
}