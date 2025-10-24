namespace SkyLearnApi.Controllers
{
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

        private int GetUserIdFromToken()
        {
            var userIdClaim = User.FindFirst("UserId")?.Value;
            if (string.IsNullOrEmpty(userIdClaim))
                throw new UnauthorizedAccessException("User ID not found in token.");
            return int.Parse(userIdClaim);
        }

        [HttpGet("get-all")]
        [AllowAnonymous] // لو عايز تخليها مفتوحة
        public async Task<IActionResult> GetAll(
            [FromQuery] string? search,
            [FromQuery] int? departmentId,
            [FromQuery] int? yearId,
            [FromQuery] DateTime? startDate,
            [FromQuery] DateTime? endDate,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 9)
        {
            var result = await _courseService.GetAllAsync(search, departmentId, yearId, startDate, endDate, page, pageSize);
            return Ok(result);
        }

        [HttpGet("get/{id:int}")]
        public async Task<IActionResult> GetById(int id)
        {
            var result = await _courseService.GetByIdAsync(id);
            if (result == null) return NotFound();
            return Ok(result);
        }

        [HttpPost("create")]
        public async Task<IActionResult> Create([FromForm] CourseRequestDto dto)
        {
            var userId = GetUserIdFromToken(); // ✅ جاي من التوكن
            var created = await _courseService.CreateAsync(dto, userId);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        [HttpPut("update/{id:int}")]
        public async Task<IActionResult> Update(int id, [FromForm] CourseRequestDto dto)
        {
            var userId = GetUserIdFromToken(); 
            var updated = await _courseService.UpdateAsync(id, dto, userId);
            if (updated == null) return NotFound();
            return Ok(updated);
        }

        [HttpDelete("delete/{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var userId = GetUserIdFromToken(); 
            var deleted = await _courseService.DeleteAsync(id, userId);
            if (!deleted) return NotFound();
            return Ok(new { message = "Course deleted successfully." });
        }
    }
}
