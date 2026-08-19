using ATS.API.Services;
using Microsoft.AspNetCore.Mvc;

namespace ATS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ConverterController : ControllerBase
    {
        private readonly FileMigrationService _migrationService;
        private readonly ILogger<ConverterController> _logger;

        public ConverterController(FileMigrationService migrationService, ILogger<ConverterController> logger)
        {
            _migrationService = migrationService;
            _logger = logger;
        }

        /// <summary>
        /// Check total, migrated, and pending count of images and resumes
        /// </summary>
        [HttpGet("Status")]
        public async Task<IActionResult> GetStatus()
        {
            try
            {
                var result = await _migrationService.GetStatusAsync();
                return Ok(new { success = true, data = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting migration status");
                return StatusCode(500, new { success = false, message = ex.Message });
            }
        }

        /// <summary>
        /// Migrate top N unmigrated images from BLOB to physical disk folder
        /// </summary>
        [HttpPost("MigrateImages")]
        public async Task<IActionResult> MigrateImages([FromQuery] int batchSize = 500, [FromQuery] long? imageId = null)
        {
            try
            {
                var result = await _migrationService.MigrateImagesAsync(batchSize, HttpContext.RequestAborted, imageId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error migrating images");
                return StatusCode(500, new { success = false, message = ex.Message });
            }
        }

        /// <summary>
        /// Migrate top N unmigrated resumes from BLOB to physical disk folder
        /// </summary>
        [HttpPost("MigrateResumes")]
        public async Task<IActionResult> MigrateResumes([FromQuery] int batchSize = 500, [FromQuery] long? resumeId = null)
        {
            try
            {
                var result = await _migrationService.MigrateResumesAsync(batchSize, HttpContext.RequestAborted, resumeId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error migrating resumes");
                return StatusCode(500, new { success = false, message = ex.Message });
            }
        }

        /// <summary>
        /// Migrate both images and resumes in a single batch call
        /// </summary>
        [HttpPost("MigrateAll")]
        public async Task<IActionResult> MigrateAll([FromQuery] int batchSize = 500)
        {
            try
            {
                var imageResult = await _migrationService.MigrateImagesAsync(batchSize, HttpContext.RequestAborted);
                var resumeResult = await _migrationService.MigrateResumesAsync(batchSize, HttpContext.RequestAborted);

                return Ok(new
                {
                    success = true,
                    images = imageResult,
                    resumes = resumeResult
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error executing MigrateAll");
                return StatusCode(500, new { success = false, message = ex.Message });
            }
        }
    }
}
