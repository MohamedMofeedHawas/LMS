

namespace SkyLearnApi.Controllers
{
    /// Squadron CRUD controller (Admin only).
    /// 5 endpoints: List, Get, Create, Update, Delete
    /// GetById includes student list (merged per business requirement).
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = Roles.Admin)]
    public class SquadronController : ControllerBase
    {
        private readonly ISquadronService _squadronService;

        public SquadronController(ISquadronService squadronService)
        {
            _squadronService = squadronService;
        }

        /// List all squadrons with student counts
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var squadrons = await _squadronService.GetAllAsync();
            return Ok(squadrons);
        }

        /// Get single squadron with student list included
        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetById(int id)
        {
            var squadron = await _squadronService.GetByIdAsync(id);

            if (squadron == null)
            {
                return NotFound(new { message = "Squadron not found" });
            }

            return Ok(squadron);
        }

        /// Create new squadron
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateSquadronDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var (squadron, error) = await _squadronService.CreateAsync(dto);

            if (error != null)
            {
                return BadRequest(new { message = error });
            }

            return CreatedAtAction(nameof(GetById), new { id = squadron!.Id }, squadron);
        }

        /// Update squadron
        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdateSquadronDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var (squadron, error) = await _squadronService.UpdateAsync(id, dto);

            if (error != null)
            {
                if (error == "Squadron not found")
                {
                    return NotFound(new { message = error });
                }
                return BadRequest(new { message = error });
            }

            return Ok(squadron);
        }

        /// Delete squadron (Hard delete)
        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var (success, error) = await _squadronService.DeleteAsync(id);

            if (!success)
            {
                if (error == "Squadron not found")
                {
                    return NotFound(new { message = error });
                }
                return BadRequest(new { message = error });
            }

            return Ok(new { message = "Squadron deleted successfully" });
        }
    }
}
