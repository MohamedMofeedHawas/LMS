using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SkyLearnApi.Dtos;
using SkyLearnApi.DTOs;
using SkyLearnApi.Services;

namespace SkyLearnApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _auth;
        private readonly AuditService _audit;

        public AuthController(IAuthService auth, AuditService audit)
        {
            _auth = auth;
            _audit = audit;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            var res = await _auth.LoginAsync(dto.Email, dto.Password);
            if (res == null)
            {
                return Unauthorized(new { message = "Invalid credentials" });
            }

            return Ok(res);
        }

       [Authorize]
[HttpPost("logout")]
public async Task<IActionResult> Logout()
{
    var authHeader = Request.Headers["Authorization"].FirstOrDefault();
    if (string.IsNullOrWhiteSpace(authHeader) || !authHeader.StartsWith("Bearer "))
    {
        await _audit.LogAsync("Logout Attempt", "Missing Authorization header", "Auth", null);
        return BadRequest(new { message = "No token provided" });
    }

    var token = authHeader.Substring("Bearer ".Length).Trim();
    await _auth.LogoutAsync(token);
    return Ok(new { message = "Logged out" });
}

        
    }
}
