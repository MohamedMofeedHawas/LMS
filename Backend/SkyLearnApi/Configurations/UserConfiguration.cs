namespace SkyLearnApi.Configuration
{
    public class UserConfiguration : IEntityTypeConfiguration<ApplicationUser>
    {
        public void Configure(EntityTypeBuilder<ApplicationUser> builder)
        {
            // اسم الجدول
            builder.ToTable("Users");

            // المفتاح الأساسي
            builder.HasKey(u => u.Id);

            // الخصائص الأساسية
            builder.Property(u => u.Email)
                   .IsRequired()
                   .HasMaxLength(100);

            builder.Property(u => u.Password)
                   .IsRequired()
                   .HasMaxLength(200);

            builder.Property(u => u.FullName)
                   .IsRequired()
                   .HasMaxLength(150)
                   // قيمة افتراضية للتأكد من عدم كسر الـ constraint
                   .HasDefaultValue("First Middle Last");

            // Check constraint مع السماح للقيم الفارغة أو الأقل من 3 كلمات
            builder.ToTable(t =>
            {
                t.HasCheckConstraint("CK_User_FullName_MinWords",
                    "FullName = '' OR LEN(FullName) - LEN(REPLACE(FullName, ' ', '')) + 1 >= 3");
            });

            // خصائص اختيارية
            builder.Property(u => u.ProfileImageUrl)
                   .HasMaxLength(250);

            builder.Property(u => u.Gender)
                   .HasMaxLength(20);

            builder.Property(u => u.City)
                   .HasMaxLength(50);

            builder.Property(u => u.AcademicYear)
                .IsRequired()
                   .HasMaxLength(50);

            builder.Property(u => u.GroupName)
                .IsRequired()
                   .HasMaxLength(50);


            builder.Property(u => u.Role)
                   .HasConversion<string>()
                   .IsRequired();
        }
    }
}
