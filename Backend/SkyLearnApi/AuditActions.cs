namespace SkyLearnApi;

public class EntityName
{
    public const string Assignments = "Assignments";
    public const string CourseInstructors = "CourseInstructors";
    public const string EnrollmentStatuses = "EnrollmentStatuses";
    public const string MaterialTypes = "MaterialTypes";
    public const string AssignmentSubmissions = "AssignmentSubmissions";
    public const string Enrollments = "Enrollments";
    public const string CourseMaterials = "CourseMaterials";
    public const string Users = "Users";
    public const string Departments = "Departments";
    public const string Years = "Years";
    public const string Courses = "Courses";

    public const string Auth = "Auth";
}

public class AuditActions
{
    public const string USER_LOGIN = "USER_LOGIN";
    public const string USER_LOGOUT = "USER_LOGOUT";
    public const string FAILED_LOGIN = "FAILED_LOGIN";

    public const string COURSE_VIEW = "COURSE_VIEW";
    public const string COURSE_ENROLL = "COURSE_ENROLL";
    public const string COURSE_COMPLETE = "COURSE_COMPLETE";


    public const string MATERIAL_VIEW = "MATERIAL_VIEW";
    public const string VIDEO_LECTURE_START = "VIDEO_LECTURE_START";
    public const string VIDEO_LECTURE_COMPLETE = "VIDEO_LECTURE_COMPLETE";


    public const string ASSIGNMENT_VIEW = "ASSIGNMENT_VIEW";
    public const string ASSIGNMENT_SUBMIT = "ASSIGNMENT_SUBMIT";
    public const string ASSIGNMENT_GRADE = "ASSIGNMENT_GRADE";


    public const string ENROLLMENT_COMPLETE = "ENROLLMENT_COMPLETE";
    public const string ENROLLMENT_DROP = "ENROLLMENT_DROP";


    public const string SYSTEM_LOGIN = "SYSTEM_LOGIN";
    public const string SYSTEM_LOGOUT = "SYSTEM_LOGOUT";


    public const string GRADE_VIEW = "GRADE_VIEW";
}