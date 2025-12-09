namespace SkyLearnApi.Entities;

public class Course
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string ImageUrl { get; set; }
    public int YearId { get; set; }
    public int DepartmentId { get; set; }
    public int CreditHours { get; set; }
    public int EnrolledStudentsCount { get; set; } = 0;
    public bool IsActive { get; set; } = true;

    public int CreatedById { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }

    // Navigation Properties
    public Year Year { get; set; }
    public Department Department { get; set; }
    public ApplicationUser CreatedBy { get; set; }

    public ICollection<CourseInstructor> Instructors { get; set; } = new List<CourseInstructor>();
    public ICollection<Enrollment> Enrollments { get; set; } = new List<Enrollment>();

    public ICollection<CourseMaterial> Materials { get; set; } = new List<CourseMaterial>();
    public ICollection<Assignment> Assignments { get; set; } = new List<Assignment>();
}


public class Enrollment
{
    public int Id { get; set; }
    public int StudentId { get; set; }
    public int CourseId { get; set; }

    public DateTime EnrolledAt { get; set; }
    public int Status { get; set; }
    public string? Grade { get; set; }
    public DateTime? CompletedAt { get; set; }
    public DateTime? DroppedAt { get; set; }

    // Navigation Properties
    public ApplicationUser Student { get; set; } = null!;
    public Course Course { get; set; } = null!;
    public EnrollmentStatus EnrollmentStatus { get; set; } = null!;
}




public class CourseInstructor
{
    public int Id { get; set; }
    public int CourseId { get; set; }
    public int InstructorId { get; set; }

    // Navigation properties
    public Course Course { get; set; } = null!;
    public ApplicationUser Instructor { get; set; }
}

public class CourseMaterial
{
    public int Id { get; set; }

    public int CourseId { get; set; }
    public int MaterialTypeId { get; set; }

    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }

    public string FileUrl { get; set; }
    public string? ExternalLink { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public int CreatedById { get; set; }

    // Navigation
    public Course Course { get; set; } = null!;
    public MaterialType MaterialType { get; set; } = null!;
    public ApplicationUser CreatedBy { get; set; } = null!;
}


public class MaterialType
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;

    // Navigation
    public ICollection<CourseMaterial> CourseMaterials { get; set; } = new List<CourseMaterial>();
}


public class EnrollmentStatus
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;

    // Navigation
    public ICollection<Enrollment> Enrollments { get; set; } = new List<Enrollment>();
}


public class Assignment
{
    public int Id { get; set; }

    public int CourseId { get; set; }

    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string FileUrl { get; set; } = string.Empty; // required assignment file link for students to download

    public DateTime AssignedAt { get; set; } = DateTime.UtcNow;
    public DateTime DueDate { get; set; }

    public bool IsActive { get; set; } = true;

    public int CreatedById { get; set; }

    // Navigation
    public Course Course { get; set; } = null!;
    public ApplicationUser CreatedBy { get; set; } = null!;
    public ICollection<AssignmentSubmission> Submissions { get; set; } = new List<AssignmentSubmission>();
}

public class AssignmentSubmission
{
    public int Id { get; set; }

    public int AssignmentId { get; set; }
    public int StudentId { get; set; }

    public string FileUrl { get; set; } = string.Empty; // submitted assignment file link by student
    public DateTime SubmittedAt { get; set; } = DateTime.UtcNow;

    public string? Grade { get; set; }
    public string? Feedback { get; set; }

    // Navigation
    public Assignment Assignment { get; set; } = null!;
    public ApplicationUser Student { get; set; } = null!;
}