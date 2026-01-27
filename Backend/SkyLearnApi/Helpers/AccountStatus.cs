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
