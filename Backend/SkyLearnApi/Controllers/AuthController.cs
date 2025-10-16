using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using SkyLearnApi.Services.Interfaces;
using SkyLearnApi.DTOs;

namespace SkyLearn.Api.Controllers
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

       [HttpPost("login")]
public async Task<IActionResult> Login([FromBody] LoginDto dto)
{
    var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";

    var token = await _authService.LoginAsync(dto.Email, dto.Password);

    if (string.IsNullOrEmpty(token))
        return Unauthorized();

    return Ok(new { token });
}


        [HttpPost("logout")]
        public async Task<IActionResult> Logout()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
                return Unauthorized();

            await _authService.LogoutAsync(int.Parse(userId));

            return Ok(new { message = "Logged out successfully" });
        }
    }
}
