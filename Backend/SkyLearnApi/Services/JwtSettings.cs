namespace SkyLearnApi.Services
{
    public class JwtSettings
    {
        public string Key { get; set; } = "ChangeThisToASecretKeyInProduction";
        public string Issuer { get; set; } = "SkyLearnApi";
        public string Audience { get; set; } = "SkyLearnApiClients";
        public int ExpireMinutes { get; set; } = 120;
    }
}
