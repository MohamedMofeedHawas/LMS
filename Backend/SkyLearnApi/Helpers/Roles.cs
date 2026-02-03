namespace SkyLearnApi.Helpers
{
     
    /// Role constants for authorization.
    /// Use these constants instead of magic strings for type-safety.
     
    public static class Roles
    {
        public const string Admin = "Admin";
        public const string Instructor = "Instructor";
        public const string Student = "Student";
        
         
        /// Admin and Instructor roles (for content management)
         
        public const string AdminOrInstructor = "Admin,Instructor";
        
         
        /// All roles (for general authenticated access)
         
        public const string All = "Admin,Instructor,Student";
    }
}
