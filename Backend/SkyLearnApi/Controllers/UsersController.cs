

namespace SkyLearnApi.Controllers
{
    /// Admin-only controller for user management.
    /// Only users with Admin role can access these endpoints.
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = Roles.Admin)]
    public class UsersController : ControllerBase
    {
        private readonly IUserService _userService;

        public UsersController(IUserService userService)
        {
            _userService = userService;
        }

      
        /// Get all users with pagination, filtering, and sorting
        
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] UserFilterParams filterParams)
        {
            var result = await _userService.GetAllUsersAsync(filterParams);
            return Ok(result);
        }

        
        /// Get a user by ID
        
        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetById(int id)
        {
            var user = await _userService.GetUserByIdAsync(id);
            
            if (user == null)
                return NotFound(new { message = "User not found" });

            return Ok(user);
        }

        /// Create a new user with specified role
       
        [HttpPost]
        public async Task<IActionResult> Create([FromForm] CreateUserDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var (user, error) = await _userService.CreateUserAsync(dto);

            if (error != null)
                return BadRequest(new { message = error });

            return CreatedAtAction(nameof(GetById), new { id = user!.Id }, user);
        }

        /// Update an existing user

        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, [FromForm] UpdateUserDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var (user, error) = await _userService.UpdateUserAsync(id, dto);

            if (error != null)
            {
                if (error == "User not found")
                    return NotFound(new { message = error });
                
                return BadRequest(new { message = error });
            }

            return Ok(user);
        }

      
        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id, [FromQuery] bool hardDelete = false)
        {
            var (success, error) = await _userService.DeleteUserAsync(id, hardDelete);

            if (!success)
            {
                if (error == "User not found")
                    return NotFound(new { message = error });
                
                return BadRequest(new { message = error });
            }

            return Ok(new { message = hardDelete ? "User permanently deleted" : "User deactivated" });
        }
    }
}
