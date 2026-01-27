

namespace SkyLearnApi.Configuration
{
    public class DepartmentConfiguration : IEntityTypeConfiguration<Department>
    {
        public void Configure(EntityTypeBuilder<Department> builder)
        {
            builder.ToTable("Departments");

            builder.HasKey(d => d.Id);

            builder.Property(d => d.Name)
                .IsRequired()
                .HasMaxLength(100);

            builder.Property(d => d.ImageUrl)
                .HasMaxLength(255);

            builder.HasOne(d => d.Head)
                .WithMany() 
                .HasForeignKey(d => d.HeadId)
                .OnDelete(DeleteBehavior.Restrict); 
        }
    }
}
