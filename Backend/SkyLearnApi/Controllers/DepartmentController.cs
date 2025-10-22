using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SkyLearnApi.Dtos.Department;
using SkyLearnApi.Services.Interfaces;

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

        // Create Department
        [HttpPost("create")]
        public async Task<IActionResult> Create([FromForm] CreateDepartmentDto dto)
        {
            var result = await _departmentService.CreateAsync(dto);
            return Ok(result);
        }

        // ✅ Get All Departments
        [HttpGet("get-all")]
        public async Task<IActionResult> GetAll()
        {
            var result = await _departmentService.GetAllAsync();
            return Ok(result);
        }

        // ✅ Get Department by Id
        [HttpGet("get/{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var result = await _departmentService.GetByIdAsync(id);
            if (result == null)
                return NotFound(new { message = "Department not found" });

            return Ok(result);
        }

        // ✅ Update Department
        [HttpPut("update/{id}")]
        public async Task<IActionResult> Update(int id, [FromForm] UpdateDepartmentDto dto)
        {
            var result = await _departmentService.UpdateAsync(id, dto);
            if (result == null)
                return NotFound(new { message = "Department not found" });

            return Ok(new { message = "Department updated successfully", data = result });
        }

        // ✅ Delete Department
        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var deleted = await _departmentService.DeleteAsync(id);
            if (!deleted)
                return NotFound(new { message = "Department not found" });

            return Ok(new { message = "Department deleted successfully" });
        }
    }
}
