using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SkyLearnApi.Migrations
{
    /// <inheritdoc />
    public partial class AddSquadronAndStudentProfile : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Squadron_Code",
                table: "Squadrons");

            migrationBuilder.DropIndex(
                name: "IX_Squadron_IsActive",
                table: "Squadrons");

            migrationBuilder.DropIndex(
                name: "IX_Squadron_Name",
                table: "Squadrons");

            migrationBuilder.DropColumn(
                name: "Code",
                table: "Squadrons");

            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "Squadrons");

            migrationBuilder.CreateIndex(
                name: "IX_Squadron_Name",
                table: "Squadrons",
                column: "Name",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Squadron_Name",
                table: "Squadrons");

            migrationBuilder.AddColumn<string>(
                name: "Code",
                table: "Squadrons",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "Squadrons",
                type: "bit",
                nullable: false,
                defaultValue: true);

            migrationBuilder.CreateIndex(
                name: "IX_Squadron_Code",
                table: "Squadrons",
                column: "Code",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Squadron_IsActive",
                table: "Squadrons",
                column: "IsActive");

            migrationBuilder.CreateIndex(
                name: "IX_Squadron_Name",
                table: "Squadrons",
                column: "Name");
        }
    }
}
