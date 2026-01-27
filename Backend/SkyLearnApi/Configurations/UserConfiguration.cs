namespace SkyLearnApi.Configuration
{
    public class UserConfiguration : IEntityTypeConfiguration<ApplicationUser>
    {
        public void Configure(EntityTypeBuilder<ApplicationUser> builder)
        {
            builder.ToTable("Users");
            builder.HasKey(u => u.Id);
            builder.Property(u => u.Email)
                   .IsRequired()
                   .HasMaxLength(100);

            builder.Property(u => u.Password)
                   .IsRequired()
                   .HasMaxLength(200);

            builder.Property(u => u.FullName)
                   .IsRequired()
                   .HasMaxLength(150)
                   .HasDefaultValue("First Middle Last");
            builder.ToTable(t =>
            {
                t.HasCheckConstraint("CK_User_FullName_MinWords",
                    "FullName = '' OR LEN(FullName) - LEN(REPLACE(FullName, ' ', '')) + 1 >= 3");
            });

            builder.Property(u => u.ProfileImageUrl)
                   .HasMaxLength(250);

            builder.Property(u => u.Gender)
                   .HasMaxLength(20);

            builder.Property(u => u.City)
                   .HasMaxLength(50);
           
            builder.Property(u => u.Role)
                   .HasConversion<string>()
                   .IsRequired();
        }
    }
}
