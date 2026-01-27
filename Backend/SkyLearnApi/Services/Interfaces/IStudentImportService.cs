namespace SkyLearnApi.Services.Interfaces
{
    public interface IStudentImportService
    {
        Task<StudentImportResultDto> ImportStudentsFromCsvAsync(Stream csvStream);
    }
}
