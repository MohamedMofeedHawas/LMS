namespace SkyLearnApi.Helpers
{
       public static class AccountStatus
    {
        public const string Disabled = "Disabled";
        public const string PendingActivation = "PendingActivation";
        public const string Active = "Active";
        public static string Compute(bool isActive, bool isActivated)
        {
            if (!isActive)
                return Disabled;
            if (!isActivated)
                return PendingActivation;
            return Active;
        }
    }
}
 
    /// User account status values derived from internal IsActive and IsActivated flags.
    /// This provides a business-friendly abstraction for non-technical admins.
    /// 
    /// Status derivation rules:
    /// - Disabled: IsActive == false (admin disabled the account)
    /// - PendingActivation: IsActive == true AND IsActivated == false (awaiting first password setup)
    /// - Active: IsActive == true AND IsActivated == true (fully operational account)
    
        /// Account has been disabled by an administrator.
        /// User cannot log in until an admin re-enables the account.
        /// Account is enabled but user has not completed first-time password setup.
        /// User must activate their account by setting a password.
        /// Account is fully active and operational
        /// User has completed activation and can log in normally

