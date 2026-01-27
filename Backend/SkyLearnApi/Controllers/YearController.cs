
namespace SkyLearnApi.Controllers
{
    /// Year management controller 
    [ApiController]
    [Route("api/years")]
    [Authorize]
    public class YearController : ControllerBase
    {
        private readonly IYearService _yearService;
        private readonly ICourseService _courseService;

        public YearController(IYearService yearService, ICourseService courseService)
        {
            _yearService = yearService;
            _courseService = courseService;
        }

        private string? UserId => User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value;

        /// Get all years, optionally filtered by department.
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] int? departmentId)
        {
            if (departmentId.HasValue)
            {
                var years = await _yearService.GetByDepartmentIdAsync(departmentId.Value);
                return Ok(years);
            }
            
            var allYears = await _yearService.GetAllAsync();
            return Ok(allYears);
        }

        /// Get a single year by ID.
        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetById(int id)
        {
            var year = await _yearService.GetByIdAsync(id);

            if (year == null)
            {
                return NotFound(new { message = "Year not found" });
            }

            return Ok(year);
        }

        /// Create a new year (Admin only).
        [HttpPost]
        [Authorize(Roles = Roles.Admin)]
        public async Task<IActionResult> Create([FromBody] YearRequestDto dto)
        {
            var userId = UserId;
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            try 
            {
                var year = await _yearService.CreateAsync(dto, userId);
                return CreatedAtAction(nameof(GetById), new { id = year.Id }, year);
            }
            catch (KeyNotFoundException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        /// Update a year (Admin only).
        [HttpPut("{id:int}")]
        [Authorize(Roles = Roles.Admin)]
        public async Task<IActionResult> Update(int id, [FromBody] YearRequestDto dto)
        {
            var userId = UserId;
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            try
            {
                var year = await _yearService.UpdateAsync(id, dto, userId);

                if (year == null)
                {
                    return NotFound(new { message = "Year not found" });
                }

                return Ok(year);
            }
            catch (KeyNotFoundException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        /// Delete a year (Admin only).
        [HttpDelete("{id:int}")]
        [Authorize(Roles = Roles.Admin)]
        public async Task<IActionResult> Delete(int id)
        {
            var userId = UserId;
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            try
            {
                var deleted = await _yearService.DeleteAsync(id, userId);

                if (!deleted)
                {
                    return NotFound(new { message = "Year not found" });
                }

                return Ok(new { message = "Year deleted successfully" });
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        /// Get all courses for a specific year.
        [HttpGet("{id:int}/courses")]
        public async Task<IActionResult> GetCoursesByYear(int id)
        {
            // Reusing CourseService logic to filter by YearId
            var courses = await _courseService.GetAllAsync(
                search: null, 
                departmentId: null, 
                yearId: id, 
                startDate: null, 
                endDate: null, 
                page: 1, 
                pageSize: 1000); // Retrieve all for this year, or reasonable max

            return Ok(courses);
        }
    }
}
