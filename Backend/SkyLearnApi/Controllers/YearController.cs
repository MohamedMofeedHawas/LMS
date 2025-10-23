namespace SkyLearnApi.Controllers
{
    [ApiController]
    [Route("api/departments/{departmentId}/years")]
    [Authorize]
    public class YearController : ControllerBase
    {
        private readonly IYearService _yearService;

        public YearController(IYearService yearService)
        {
            _yearService = yearService;
        }

        //  Get all years for a department
        [HttpGet]
        public async Task<IActionResult> GetAll(int departmentId)
        {
            var years = await _yearService.GetByDepartmentIdAsync(departmentId);
            return Ok(years);
        }

        // Get a single year by id
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int departmentId, int id)
        {
            var year = await _yearService.GetByIdAsync(id);
            if (year == null)
                return NotFound(new { message = "Year not found" });

            return Ok(year);
        }

        //  Create a new year
        [HttpPost]
        public async Task<IActionResult> Create(int departmentId, [FromBody] YearRequestDto dto)
        {
            string? userId = User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value;

            dto.DepartmentId = departmentId;

            var year = await _yearService.CreateAsync(dto, userId ?? string.Empty);
            return Ok(year);
        }

        //Update a year
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int departmentId, int id, [FromBody] YearRequestDto dto)
        {
            string? userId = User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value;

            dto.DepartmentId = departmentId;

            var year = await _yearService.UpdateAsync(id, dto, userId ?? string.Empty);
            if (year == null)
                return NotFound(new { message = "Year not found" });

            return Ok(year);
        }

        //  Delete a year
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int departmentId, int id)
        {
            string? userId = User.Claims.FirstOrDefault(c => c.Type == "UserId")?.Value;

            try
            {
                var deleted = await _yearService.DeleteAsync(id, userId ?? string.Empty);
                if (!deleted)
                    return NotFound(new { message = "Year not found" });

                return Ok(new { message = "Year deleted successfully" });
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }


    }
}
