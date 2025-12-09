namespace SkyLearnApi.Configurations;

public class CourseMaterialConfiguration : IEntityTypeConfiguration<CourseMaterial>
{
    public void Configure(EntityTypeBuilder<CourseMaterial> builder)
    {
        builder.ToTable("CourseMaterials");

        builder.HasKey(cm => cm.Id);

        builder.Property(cm => cm.Title)
            .IsRequired()
            .HasMaxLength(300);

        builder.Property(cm => cm.Description)
            .HasMaxLength(4000)
            .IsRequired(false);

        builder.Property(cm => cm.FileUrl)
            .IsRequired()
            .HasMaxLength(2000);

        builder.Property(cm => cm.ExternalLink)
            .HasMaxLength(2000)
            .IsRequired(false);

        builder.Property(cm => cm.CreatedAt)
            .HasDefaultValueSql(SqlFunctions.GetUtcDate);

        // relations
        builder.HasOne(cm => cm.Course)
            .WithMany(c => c.Materials)
            .HasForeignKey(cm => cm.CourseId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(cm => cm.MaterialType)
            .WithMany(mt => mt.CourseMaterials)
            .HasForeignKey(cm => cm.MaterialTypeId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(cm => cm.CreatedBy)
            .WithMany()
            .HasForeignKey(cm => cm.CreatedById)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasIndex(cm => new { cm.CourseId, cm.MaterialTypeId });
    }
}