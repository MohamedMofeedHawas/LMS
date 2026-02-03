using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SkyLearnApi.Migrations
{
    /// <inheritdoc />
    public partial class UniqueConstraints : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Clean up duplicate Years
            migrationBuilder.Sql(@"
                WITH Duplicates AS (
                    SELECT Id, Name, DepartmentId,
                           ROW_NUMBER() OVER (PARTITION BY Name, DepartmentId ORDER BY Id) AS rn
                    FROM Years
                )
                UPDATE Years
                SET Name = Name + ' ' + CAST(Id AS VARCHAR(10))
                WHERE Id IN (SELECT Id FROM Duplicates WHERE rn > 1);
            ");

            // Clean up duplicate Departments
            migrationBuilder.Sql(@"
                WITH DeptDuplicates AS (
                    SELECT Id, Name,
                           ROW_NUMBER() OVER (PARTITION BY Name ORDER BY Id) AS rn
                    FROM Departments
                )
                UPDATE Departments
                SET Name = Name + ' ' + CAST(Id AS VARCHAR(10))
                WHERE Id IN (SELECT Id FROM DeptDuplicates WHERE rn > 1);
            ");

            migrationBuilder.CreateIndex(
                name: "IX_Years_Name_DepartmentId",
                table: "Years",
                columns: new[] { "Name", "DepartmentId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Departments_Name",
                table: "Departments",
                column: "Name",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Years_Name_DepartmentId",
                table: "Years");

            migrationBuilder.DropIndex(
                name: "IX_Departments_Name",
                table: "Departments");
        }
    }
}
