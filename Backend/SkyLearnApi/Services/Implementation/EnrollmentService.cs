using SkyLearnApi.DTOs.Enrollment;

namespace SkyLearnApi.Services.Implementation
{
    public class EnrollmentService : IEnrollmentService
    {
        private readonly AppDbContext _context;

        public EnrollmentService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<StudentCourseDto>> GetStudentCoursesAsync(int studentId)
        {
            var profile = await _context.StudentProfiles
                .AsNoTracking()
                .FirstOrDefaultAsync(sp => sp.UserId == studentId);

            if (profile == null)
            {
                Log.Warning("GetStudentCourses: No profile found for user {UserId}", studentId);
                return new List<StudentCourseDto>();
            }

            // Get all courses for this student's year and department
            var courses = await _context.Courses
                .AsNoTracking()
                .Include(c => c.CreatedBy)
                .Where(c => c.YearId == profile.YearId && c.DepartmentId == profile.DepartmentId)
                .ToListAsync();

            if (!courses.Any())
                return new List<StudentCourseDto>();

            // Get enrolled student counts for these courses
            // Students are automatically enrolled in all courses of their academic year
            var yearIds = courses.Select(c => c.YearId).Distinct().ToList();
            var enrollmentCounts = await _context.StudentProfiles
                .Where(sp => yearIds.Contains(sp.YearId))
                .GroupBy(sp => sp.YearId)
                .Select(g => new { YearId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.YearId, x => x.Count);

            // Get this student's enrollments
            var courseIds = courses.Select(c => c.Id).ToList();
            var studentEnrollments = await _context.Enrollments
                .AsNoTracking()
                .Where(e => e.StudentProfileId == profile.Id && courseIds.Contains(e.CourseId))
                .ToDictionaryAsync(e => e.CourseId, e => e.EnrolledAt);

            return courses.Select(c => new StudentCourseDto
            {
                CourseId = c.Id,
                CourseTitle = c.Title,
                CourseDescription = c.Description,
                ImageUrl = c.ImageUrl,
                CreditHours = c.CreditHours,
                EnrolledStudentsCount = enrollmentCounts.GetValueOrDefault(c.YearId, 0),
                InstructorName = c.CreatedBy.FullName,
                EnrolledAt = studentEnrollments.GetValueOrDefault(c.Id)
            }).ToList();
        }

        public async Task<(bool Success, string? Error)> EnrollStudentAsync(int studentId, int courseId, int enrolledById)
        {
            var profile = await _context.StudentProfiles
                .FirstOrDefaultAsync(sp => sp.UserId == studentId);

            if (profile == null)
            {
                Log.Warning("Enroll failed: Student {StudentId} not found or has no profile", studentId);
                return (false, "Student not found or is not a student.");
            }

            var course = await _context.Courses.FindAsync(courseId);
            if (course == null)
            {
                Log.Warning("Enroll failed: Course {CourseId} not found", courseId);
                return (false, "Course not found.");
            }

            if (course.DepartmentId != profile.DepartmentId)
            {
                Log.Warning("Enroll failed: Course {CourseId} not in student's department", courseId);
                return (false, "Course is not in the student's department.");
            }

            var exists = await _context.Enrollments
                .AnyAsync(e => e.StudentProfileId == profile.Id && e.CourseId == courseId);

            if (exists)
            {
                Log.Warning("Enroll failed: Student {StudentId} already enrolled in course {CourseId}", studentId, courseId);
                return (false, "Student is already enrolled in this course.");
            }

            var enrollment = new Enrollment
            {
                StudentProfileId = profile.Id,
                CourseId = courseId,
                EnrolledById = enrolledById,
                EnrolledAt = DateTime.UtcNow
            };

            _context.Enrollments.Add(enrollment);
            await _context.SaveChangesAsync();

            Log.Information("Student {StudentId} enrolled in course {CourseId} by user {EnrolledBy}",
                studentId, courseId, enrolledById);

            return (true, null);
        }

        public async Task<(bool Success, string? Error)> UnenrollStudentAsync(int studentId, int courseId)
        {
            var profile = await _context.StudentProfiles
                .FirstOrDefaultAsync(sp => sp.UserId == studentId);

            if (profile == null)
            {
                Log.Warning("Unenroll failed: Student {StudentId} not found", studentId);
                return (false, "Student not found.");
            }

            var enrollment = await _context.Enrollments
                .FirstOrDefaultAsync(e => e.StudentProfileId == profile.Id && e.CourseId == courseId);

            if (enrollment == null)
            {
                Log.Warning("Unenroll failed: Student {StudentId} not enrolled in course {CourseId}", studentId, courseId);
                return (false, "Student is not enrolled in this course.");
            }

            _context.Enrollments.Remove(enrollment);
            await _context.SaveChangesAsync();

            Log.Information("Student {StudentId} unenrolled from course {CourseId}", studentId, courseId);

            return (true, null);
        }
    }
}
