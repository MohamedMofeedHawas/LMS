

namespace SkyLearnApi.Controllers
{ 
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class DepartmentController : ControllerBase
    {
        private readonly IDepartmentService _departmentService;

        public DepartmentController(IDepartmentService departmentService)
        {
            _departmentService = departmentService;
        }
        /// Create a new department (Admin only)
        [HttpPost]
        [Authorize(Roles = Roles.Admin)]
        public async Task<IActionResult> Create([FromForm] CreateDepartmentDto dto)
        {
            var result = await _departmentService.CreateAsync(dto);
            return Ok(result);
        }
        /// Get all departments
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var result = await _departmentService.GetAllAsync();
            return Ok(result);
        }
        /// Get department by ID.
 
        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetById(int id)
        {
            var result = await _departmentService.GetByIdAsync(id);

            if (result == null)
            {
                return NotFound(new { message = "Department not found" });
            }

            return Ok(result);
        }
        /// Update a department (Admin only).
       
        [HttpPut("{id:int}")]
        [Authorize(Roles = Roles.Admin)]
        public async Task<IActionResult> Update(int id, [FromForm] UpdateDepartmentDto dto)
        {
            var result = await _departmentService.UpdateAsync(id, dto);

            if (result == null)
            {
                return NotFound(new { message = "Department not found" });
            }

            return Ok(new { message = "Department updated successfully", data = result });
        }
        /// Delete a department (Admin only)
        [HttpDelete("{id:int}")]
        [Authorize(Roles = Roles.Admin)]
        public async Task<IActionResult> Delete(int id)
        {
            var deleted = await _departmentService.DeleteAsync(id);

            if (!deleted)
            {
                return NotFound(new { message = "Department not found" });
            }

            return Ok(new { message = "Department deleted successfully" });
        }
    }
}
