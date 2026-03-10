using ATS.API.Interface;
using ATS.API.Models;
using ATS.API.Repository;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ATS.API.Controllers
{
    [Route("api/mobile")]
    [ApiController]
    public class MobileWebhookController : ControllerBase
    {
        private readonly IETimeTrackRepository _attendanceRepo;
        private readonly IBackgroundTaskQueue _taskQueue;
        private readonly IServiceScopeFactory _scopeFactory;
        public MobileWebhookController(IETimeTrackRepository attendanceRepo, IBackgroundTaskQueue taskQueue,IServiceScopeFactory scopeFactory)
        {
            _attendanceRepo = attendanceRepo;
            _taskQueue = taskQueue;
            _scopeFactory = scopeFactory;
        }
        [HttpPost("mobile-punch")]
        public async Task<IActionResult> ReceiveMobilePunch([FromBody] MobilePunchRequest model)
        {
            if (model == null)
                return BadRequest(new { Status = "Invalid payload" });
            try
            { 
                string rawPayload = $"{model.EmployeeId} {model.PunchTime:yyyy-MM-dd HH:mm:ss} {model.PunchState}";

                long rawPunchId = await _attendanceRepo.InsertRawPunchMobileAsync(
                    model.TenantId,
                    model.EmployeeId.ToString(),
                    model.PunchTime,
                    model.PunchState,
                    "MOBILE",
                    model.DeviceName,
                    rawPayload,
                    model.Latitude,
                    model.Longitude,
                    model.Location
                );

                if (rawPunchId > 0)
                {
                    await _taskQueue.QueueBackgroundWorkItem(async token =>
                    {
                        using var scope = _scopeFactory.CreateScope();

                        var repo = scope.ServiceProvider
                            .GetRequiredService<IETimeTrackRepository>();

                        await repo.ProcessDailyAttendance(rawPunchId);
                    });
                }

                return Ok(new { Status = "Success" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Status = "Error", Message = ex.Message });
            }
        }
    }
}
