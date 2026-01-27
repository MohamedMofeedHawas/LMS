namespace SkyLearnApi.Services
{
    public interface IAuthService
    {
        Task<VerifyAccountResponseDto> VerifyAccountAsync(string email);        
        Task<ActivateAccountResponseDto?> ActivateAccountAsync(string email, string password);
         Task<AuthResponseDto?> LoginAsync(string email, string password);
        Task LogoutAsync(string token);        
        Task<UserProfileDto?> GetCurrentUserProfileAsync(int userId);
       Task<ForgotPasswordResponseDto> ForgotPasswordAsync(string email);
        Task<ResetPasswordResponseDto> ResetPasswordAsync(string email, string resetToken, string newPassword);
        Task<UserProfileDto?> UpdateProfileAsync(int userId, UpdateProfileRequestDto dto);
    }
}
