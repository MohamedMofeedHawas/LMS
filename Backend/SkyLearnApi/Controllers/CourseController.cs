

namespace SkyLearnApi.Controllers
{
   
    /// Course management controller
   
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class CourseController : ControllerBase
    {
        private readonly ICourseService _courseService;

        public CourseController(ICourseService courseService)
        {
            _courseService = courseService;
        }

        private int? UserId =>
            int.TryParse(User.FindFirst("UserId")?.Value, out var id) ? id : null;

        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> GetAll(
            [FromQuery] string? search,
            [FromQuery] int? departmentId,
            [FromQuery] int? yearId,
            [FromQuery] DateTime? startDate,
            [FromQuery] DateTime? endDate,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 9)
        {
            var result = await _courseService.GetAllAsync(
                search, departmentId, yearId, startDate, endDate, page, pageSize);

            return Ok(result);
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetById(int id)
        {
            if (UserId == null)
                return Unauthorized(new { message = "Invalid or missing authentication token" });

            var result = await _courseService.GetByIdAsync(id);

            if (result == null)
            {
                return NotFound(new { message = "Course not found" });
            }

            return Ok(result);
        }

        [HttpPost]
        [Authorize(Roles = Roles.AdminOrInstructor)]
        public async Task<IActionResult> Create([FromForm] CourseRequestDto dto)
        {
            if (UserId == null)
                return Unauthorized(new { message = "Invalid or missing authentication token" });

            var created = await _courseService.CreateAsync(dto, UserId.Value);

            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        [HttpPut("{id:int}")]
        [Authorize(Roles = Roles.AdminOrInstructor)]
        public async Task<IActionResult> Update(int id, [FromForm] CourseRequestDto dto)
        {
            if (UserId == null)
                return Unauthorized(new { message = "Invalid or missing authentication token" });

            var updated = await _courseService.UpdateAsync(id, dto, UserId.Value);

            if (updated == null)
            {
                return NotFound(new { message = "Course not found" });
            }

            return Ok(updated);
        }

        [HttpDelete("{id:int}")]
        [Authorize(Roles = Roles.Admin)]
        public async Task<IActionResult> Delete(int id)
        {
            if (UserId == null)
                return Unauthorized(new { message = "Invalid or missing authentication token" });

            var deleted = await _courseService.DeleteAsync(id, UserId.Value);

            if (!deleted)
            {
                return NotFound(new { message = "Course not found" });
            }

            return Ok(new { message = "Course deleted successfully." });
        }
    }
}
