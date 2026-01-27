

namespace SkyLearnApi.Services
{
     
    /// Authentication service interface for the closed system.
    /// Supports the Air Force Academy authentication flow:
    /// - Admins create users WITHOUT passwords
    /// - Users set their password on first login (activation)
    /// - Standard login for activated users
    /// - Password recovery without revealing account existence
     
    public interface IAuthService
    {
         
        /// Verify if an account exists and its activation status.
        /// First step in the authentication flow.
         
        Task<VerifyAccountResponseDto> VerifyAccountAsync(string email);

         
        /// Activate a new account by setting the password for the first time.
        /// Only works for existing, non-activated accounts.
        /// Returns JWT token immediately upon successful activation.
         
        Task<ActivateAccountResponseDto?> ActivateAccountAsync(string email, string password);

         
        /// Standard login for activated users.
         
        Task<AuthResponseDto?> LoginAsync(string email, string password);

         
        /// Logout the current user.        
        Task LogoutAsync(string token);        
        /// Get current user profile from JWT claims     
        Task<UserProfileDto?> GetCurrentUserProfileAsync(int userId);
        /// Initiate password reset flow.
        /// Never reveals whether the email exists (security best practice).
         
        Task<ForgotPasswordResponseDto> ForgotPasswordAsync(string email);

         
        /// Complete password reset with token.
         
        Task<ResetPasswordResponseDto> ResetPasswordAsync(string email, string resetToken, string newPassword);

        Task<UserProfileDto?> UpdateProfileAsync(int userId, UpdateProfileRequestDto dto);
    }
}
