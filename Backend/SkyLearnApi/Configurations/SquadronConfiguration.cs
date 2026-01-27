namespace SkyLearnApi.Configuration
{
    public class SquadronConfiguration : IEntityTypeConfiguration<Squadron>
    {
        public void Configure(EntityTypeBuilder<Squadron> builder)
        {
            builder.ToTable("Squadrons");

            builder.HasKey(s => s.Id);

            builder.Property(s => s.Name)
                .IsRequired()
                .HasMaxLength(100);

            builder.Property(s => s.Description)
                .HasMaxLength(500);

            builder.Property(s => s.CreatedAt)
                .HasDefaultValueSql("GETUTCDATE()");

            // Unique name constraint
            builder.HasIndex(s => s.Name)
                .IsUnique()
                .HasDatabaseName("IX_Squadron_Name");
        }
    }
}
