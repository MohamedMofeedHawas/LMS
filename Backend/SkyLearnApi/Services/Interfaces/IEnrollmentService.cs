using SkyLearnApi.DTOs.Enrollment;

namespace SkyLearnApi.Services.Interfaces
{
    public interface IEnrollmentService
    {
        Task<List<StudentCourseDto>> GetStudentCoursesAsync(int studentId);
        Task<(bool Success, string? Error)> EnrollStudentAsync(int studentId, int courseId, int enrolledById);
        Task<(bool Success, string? Error)> UnenrollStudentAsync(int studentId, int courseId);
    }
}
