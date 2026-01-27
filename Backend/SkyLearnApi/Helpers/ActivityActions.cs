namespace SkyLearnApi.Helpers
{
     
    /// Unified activity action constants for the ActivityLog system.
    /// Used for both auditing and analytics tracking.
     
    public static class ActivityActions
    {
        // ============================================
        // Authentication Events
        // ============================================
        public const string UserLoggedIn = "UserLoggedIn";
        public const string UserLoggedOut = "UserLoggedOut";
        public const string LoginFailed = "LoginFailed";
        public const string LogoutFailed = "LogoutFailed";
        public const string TokenRefreshed = "TokenRefreshed";
        public const string PasswordChanged = "PasswordChanged";

        // Account Verification & Activation (Closed System Flow)
        public const string AccountVerification = "AccountVerification";
        public const string AccountActivated = "AccountActivated";
        public const string ActivationFailed = "ActivationFailed";
        public const string ProfileViewed = "ProfileViewed";
        public const string ProfileUpdated = "ProfileUpdated";

        // Password Recovery
        public const string PasswordResetRequested = "PasswordResetRequested";
        public const string PasswordResetCompleted = "PasswordResetCompleted";
        public const string PasswordResetFailed = "PasswordResetFailed";

        // ============================================
        // User Management Events
        // ============================================
        public const string UserCreated = "UserCreated";
        public const string UserUpdated = "UserUpdated";
        public const string UserDeleted = "UserDeleted";
        public const string UserDeactivated = "UserDeactivated";
        public const string UserViewed = "UserViewed";
        public const string UserListViewed = "UserListViewed";

        // ============================================
        // Course Events
        // ============================================
        public const string CourseViewed = "CourseViewed";
        public const string CourseCreated = "CourseCreated";
        public const string CourseUpdated = "CourseUpdated";
        public const string CourseDeleted = "CourseDeleted";
        public const string CourseListViewed = "CourseListViewed";
        public const string CourseSearched = "CourseSearched";
        public const string CourseEnrolled = "CourseEnrolled";
        public const string CourseWatching = "CourseWatching";

        // ============================================
        // Department Events
        // ============================================
        public const string DepartmentViewed = "DepartmentViewed";
        public const string DepartmentCreated = "DepartmentCreated";
        public const string DepartmentUpdated = "DepartmentUpdated";
        public const string DepartmentDeleted = "DepartmentDeleted";
        public const string DepartmentListViewed = "DepartmentListViewed";

        // ============================================
        // Year Events
        // ============================================
        public const string YearViewed = "YearViewed";
        public const string YearCreated = "YearCreated";
        public const string YearUpdated = "YearUpdated";
        public const string YearDeleted = "YearDeleted";
        public const string YearListViewed = "YearListViewed";

        // ============================================
        // Session/Engagement Events (for Data Scientists)
        // ============================================
        public const string SessionStarted = "SessionStarted";
        public const string SessionEnded = "SessionEnded";
        public const string PageViewed = "PageViewed";
        public const string ContentWatched = "ContentWatched";
        public const string LectureStarted = "LectureStarted";
        public const string LectureCompleted = "LectureCompleted";

        // ============================================
        // Squadron Events
        // ============================================
        public const string SquadronViewed = "SquadronViewed";
        public const string SquadronCreated = "SquadronCreated";
        public const string SquadronUpdated = "SquadronUpdated";
        public const string SquadronDeleted = "SquadronDeleted";
        public const string SquadronListViewed = "SquadronListViewed";

        // ============================================
        // Import Events
        // ============================================
        public const string BulkImportStudents = "BulkImportStudents";
    }
}
