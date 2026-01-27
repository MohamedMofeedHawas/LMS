using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SkyLearnApi.Migrations
{
    /// <inheritdoc />
    public partial class AddActivityLogsTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ActivityLogs",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ActionName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    EntityName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    EntityId = table.Column<int>(type: "int", nullable: true),
                    Description = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    UserId = table.Column<int>(type: "int", nullable: true),
                    SessionId = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    LoginTime = table.Column<DateTime>(type: "datetime2", nullable: true),
                    LogoutTime = table.Column<DateTime>(type: "datetime2", nullable: true),
                    SessionDurationSeconds = table.Column<long>(type: "bigint", nullable: true),
                    IpAddress = table.Column<string>(type: "nvarchar(45)", maxLength: 45, nullable: true),
                    UserAgent = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    Jti = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    TokenExpiresAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Metadata = table.Column<string>(type: "NVARCHAR(MAX)", nullable: true),
                    Timestamp = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    ProcessingTimeMs = table.Column<long>(type: "bigint", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ActivityLogs", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ActivityLogs_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ActivityLog_ActionName_Timestamp",
                table: "ActivityLogs",
                columns: new[] { "ActionName", "Timestamp" });

            migrationBuilder.CreateIndex(
                name: "IX_ActivityLog_EntityName_EntityId",
                table: "ActivityLogs",
                columns: new[] { "EntityName", "EntityId" },
                filter: "[EntityName] IS NOT NULL AND [EntityId] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_ActivityLog_Jti",
                table: "ActivityLogs",
                column: "Jti",
                filter: "[Jti] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_ActivityLog_SessionId",
                table: "ActivityLogs",
                column: "SessionId",
                filter: "[SessionId] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_ActivityLog_Timestamp",
                table: "ActivityLogs",
                column: "Timestamp");

            migrationBuilder.CreateIndex(
                name: "IX_ActivityLog_UserId_LoginTime",
                table: "ActivityLogs",
                columns: new[] { "UserId", "LoginTime" },
                filter: "[LoginTime] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_ActivityLog_UserId_Timestamp",
                table: "ActivityLogs",
                columns: new[] { "UserId", "Timestamp" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ActivityLogs");
        }
    }
}
