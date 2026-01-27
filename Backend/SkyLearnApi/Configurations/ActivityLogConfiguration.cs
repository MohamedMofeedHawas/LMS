

namespace SkyLearnApi.Configuration
{
    public class ActivityLogConfiguration : IEntityTypeConfiguration<ActivityLog>
    {
        public void Configure(EntityTypeBuilder<ActivityLog> builder)
        {
            // Table
            builder.ToTable("ActivityLogs");

            // Primary Key
            builder.HasKey(a => a.Id);

            // Properties
            builder.Property(a => a.ActionName)
                .IsRequired()
                .HasMaxLength(100);

            builder.Property(a => a.EntityName)
                .HasMaxLength(100);

            builder.Property(a => a.Description)
                .HasMaxLength(1000);

            builder.Property(a => a.SessionId)
                .HasMaxLength(100);

            builder.Property(a => a.IpAddress)
                .HasMaxLength(45); // IPv6 max length

            builder.Property(a => a.UserAgent)
                .HasMaxLength(500);

            builder.Property(a => a.Jti)
                .HasMaxLength(100);

            builder.Property(a => a.Metadata)
                .HasColumnType("NVARCHAR(MAX)");

            builder.Property(a => a.Timestamp)
                .IsRequired()
                .HasDefaultValueSql("GETUTCDATE()");

            // Foreign Key Relationship
            builder.HasOne(a => a.User)
                .WithMany()
                .HasForeignKey(a => a.UserId)
                .OnDelete(DeleteBehavior.SetNull)
                .IsRequired(false);

            // Primary query: Get events by user over time
            builder.HasIndex(a => new { a.UserId, a.Timestamp })
                .HasDatabaseName("IX_ActivityLog_UserId_Timestamp");

            // Event type filtering
            builder.HasIndex(a => new { a.ActionName, a.Timestamp })
                .HasDatabaseName("IX_ActivityLog_ActionName_Timestamp");

            // Entity-based queries (e.g., "all events for Course 5")
            builder.HasIndex(a => new { a.EntityName, a.EntityId })
                .HasDatabaseName("IX_ActivityLog_EntityName_EntityId")
                .HasFilter("[EntityName] IS NOT NULL AND [EntityId] IS NOT NULL");

            // Session-based queries
            builder.HasIndex(a => a.SessionId)
                .HasDatabaseName("IX_ActivityLog_SessionId")
                .HasFilter("[SessionId] IS NOT NULL");

            // Time-based analytics
            builder.HasIndex(a => a.Timestamp)
                .HasDatabaseName("IX_ActivityLog_Timestamp");

            // JWT token lifecycle tracking
            builder.HasIndex(a => a.Jti)
                .HasDatabaseName("IX_ActivityLog_Jti")
                .HasFilter("[Jti] IS NOT NULL");

            // Login session analysis
            builder.HasIndex(a => new { a.UserId, a.LoginTime })
                .HasDatabaseName("IX_ActivityLog_UserId_LoginTime")
                .HasFilter("[LoginTime] IS NOT NULL");
        }
    }
}
