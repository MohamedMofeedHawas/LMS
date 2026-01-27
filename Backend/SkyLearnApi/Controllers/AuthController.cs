

namespace SkyLearnApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        #region 1. Account Verification
        /// Verify if an account exists and its activation status.
        /// First step in the authentication flow.
        /// Frontend uses this to determine:
        /// - If email doesn't exist → show rejection message
        /// - If email exists but not activated → redirect to password setup
        /// - If email exists and activated → redirect to login
    
        [HttpPost("verify-account")]
        [AllowAnonymous]
        public async Task<IActionResult> VerifyAccount([FromBody] VerifyAccountRequestDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _authService.VerifyAccountAsync(dto.Email);
            return Ok(result);
        }

        #endregion

        #region 2. Account Activation
        [HttpPost("activate-account")]
        [AllowAnonymous]
        public async Task<IActionResult> ActivateAccount([FromBody] ActivateAccountRequestDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _authService.ActivateAccountAsync(dto.Email, dto.Password);

            if (result == null)
            {
                return BadRequest(new 
                { 
                    message = "Account activation failed. Please verify your email or contact an administrator.",
                    success = false
                });
            }

            return Ok(result);
        }

        #endregion

        #region 3. Standard Login
         [HttpPost("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _authService.LoginAsync(dto.Email, dto.Password);

            if (result == null)
            {
                return Unauthorized(new 
                { 
                    message = "Invalid credentials. Please check your email and password.",
                    success = false
                });
            }

            return Ok(new
            {
                message = "Login successful",
                success = true,
                token = result.Token,
                expiresIn = result.ExpiresIn,
                user = result.User
            });
        }

        #endregion

        #region 4. Logout

         
        /// Logout the current user.
         
        [Authorize]
        [HttpPost("logout")]
        public async Task<IActionResult> Logout()
        {
            var authHeader = Request.Headers["Authorization"].FirstOrDefault();
            if (string.IsNullOrWhiteSpace(authHeader) || !authHeader.StartsWith("Bearer "))
            {
                return BadRequest(new { message = "No token provided", success = false });
            }

            var token = authHeader.Substring("Bearer ".Length).Trim();
            await _authService.LogoutAsync(token);

            return Ok(new { message = "Logged out successfully", success = true });
        }

        #endregion

        #region 5. User Profile (Me)
        /// Get the current user's profile.
        /// User identity is extracted from JWT claims - no route-based user ID allowed.
         
        [Authorize]
        [HttpGet("me")]
        public async Task<IActionResult> GetCurrentUserProfile()
        {
            // Extract user ID from JWT claims
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier) 
                           ?? User.FindFirst("sub") 
                           ?? User.FindFirst("nameid");

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out var userId))
            {
                return Unauthorized(new 
                { 
                    message = "Invalid or missing user identity in token",
                    success = false
                });
            }

            var profile = await _authService.GetCurrentUserProfileAsync(userId);

            if (profile == null)
            {
                return NotFound(new 
                { 
                    message = "User profile not found",
                    success = false
                });
            }

            return Ok(new
            {
                message = "Profile retrieved successfully",
                success = true,
                user = profile
            });
        }
        /// Update current user profile.
        /// Accepts multipart/form-data for image upload.
        [Authorize]
        [HttpPatch("me")]
        public async Task<IActionResult> UpdateProfile([FromForm] UpdateProfileRequestDto dto)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier) 
                           ?? User.FindFirst("sub") 
                           ?? User.FindFirst("nameid");

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out var userId))
            {
                return Unauthorized(new { message = "Invalid user identity", success = false });
            }
            var updatedProfile = await _authService.UpdateProfileAsync(userId, dto);

            if (updatedProfile == null)
            {
                return NotFound(new { message = "User not found", success = false });
            }

            return Ok(new
            {
                message = "Profile updated successfully",
                success = true,
                user = updatedProfile
            });
        }

        #endregion

        #region 6. Password Recovery

     
        [HttpPost("forgot-password")]
        [AllowAnonymous]
        public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequestDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _authService.ForgotPasswordAsync(dto.Email);
            return Ok(result);
        }
        /// Reset password with token.
         
        [HttpPost("reset-password")]
        [AllowAnonymous]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequestDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _authService.ResetPasswordAsync(dto.Email, dto.ResetToken, dto.NewPassword);

            if (!result.Success)
            {
                return BadRequest(result);
            }

            return Ok(result);
        }

        #endregion
    }
}
