using ATS.API.Interface;
using ATS.API.Models;
using ATS.API.Repository;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace ATS.API.Controllers
{
    [Route("api/mobile")]
    [Route("ATS/api/mobile")]
    [ApiController]
    public class MobileWebhookController : ControllerBase
    {
        private readonly IETimeTrackRepository _attendanceRepo;
        private readonly IBackgroundTaskQueue _taskQueue;
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<MobileWebhookController> _logger;

        public MobileWebhookController(
            IETimeTrackRepository attendanceRepo,
            IBackgroundTaskQueue taskQueue,
            IServiceScopeFactory scopeFactory,
            ILogger<MobileWebhookController> logger)
        {
            _attendanceRepo = attendanceRepo;
            _taskQueue = taskQueue;
            _scopeFactory = scopeFactory;
            _logger = logger;
        }

        [HttpPost("mobile-punch")]
        public async Task<IActionResult> ReceiveMobilePunch([FromBody] MobilePunchRequest model)
        {
            if (model == null)
                return BadRequest(new { Status = "Error", Message = "Invalid or empty payload." });

            try
            {
                string rawPayload = $"{model.EmployeeId} {model.PunchTime:yyyy-MM-dd HH:mm:ss} {model.PunchState}";

                _logger.LogInformation("Received mobile punch for EmployeeId: {EmployeeId}, Device: {DeviceName}, PunchTime: {PunchTime}",
                    model.EmployeeId, model.DeviceName, model.PunchTime);

                long rawPunchId = await _attendanceRepo.InsertRawPunchMobileAsync(
                    model.TenantId ?? string.Empty,
                    model.EmployeeId.ToString(),
                    model.PunchTime,
                    model.PunchState ?? "0",
                    "MOBILE",
                    model.DeviceName ?? "MOBILE",
                    rawPayload,
                    model.Latitude,
                    model.Longitude,
                    model.Location ?? string.Empty
                );

                if (rawPunchId > 0)
                {
                    _logger.LogInformation("Mobile punch inserted successfully with RawPunchId: {RawPunchId}. Enqueuing attendance calculation.", rawPunchId);

                    await _taskQueue.QueueBackgroundWorkItem(async token =>
                    {
                        try
                        {
                            using var scope = _scopeFactory.CreateScope();
                            var repo = scope.ServiceProvider.GetRequiredService<IETimeTrackRepository>();
                            long resultStatus = await repo.ProcessDailyAttendance(rawPunchId);
                            _logger.LogInformation("Completed daily attendance process for RawPunchId: {RawPunchId} with result status: {ResultStatus}", rawPunchId, resultStatus);
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex, "Background processing failed for RawPunchId: {RawPunchId}", rawPunchId);
                        }
                    });

                    return Ok(new
                    {
                        Status = "Success",
                        RawPunchId = rawPunchId,
                        Message = "Punch recorded and scheduled for daily attendance processing."
                    });
                }
                else
                {
                    _logger.LogWarning("Punch was not inserted (RawPunchId = 0). Possible duplicate within 2 minutes or unmapped device/employee: {EmployeeId}", model.EmployeeId);
                    return Ok(new
                    {
                        Status = "Ignored",
                        RawPunchId = 0,
                        Message = "Punch ignored (duplicate within 2-min window or unmapped employee/device)."
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing mobile punch for EmployeeId: {EmployeeId}", model.EmployeeId);
                return StatusCode(500, new { Status = "Error", Message = ex.Message });
            }
        }
    }
}
