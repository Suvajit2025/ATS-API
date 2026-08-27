using ATS.API.Interface;
using ATS.API.Repository;
using ATS.API.Services;
using CommonUtility.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Data;
using System.Text;

namespace ATS.API.Controllers
{
    [Route("iclock/cdata")]
    [Route("ATS/iclock/cdata")]
    [ApiController]
    public class AttendanceListenerController : ControllerBase
    {
        private readonly IBackgroundTaskQueue _taskQueue;
        private readonly IDataService _dataService;
        private readonly string _ConnectionString;
        private readonly IETimeTrackRepository _attendanceRepo;
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<AttendanceListenerController> _logger;

        public AttendanceListenerController(
            IBackgroundTaskQueue taskQueue,
            IConfiguration configuration,
            IDataService dataService,
            IETimeTrackRepository eTimeTrackRepository,
            IServiceScopeFactory scopeFactory,
            ILogger<AttendanceListenerController> logger)
        {
            _dataService = dataService;
            _ConnectionString = configuration.GetConnectionString("DBConnSaaSEssP") ?? string.Empty;
            _taskQueue = taskQueue;
            _attendanceRepo = eTimeTrackRepository;
            _scopeFactory = scopeFactory;
            _logger = logger;
        }

        // ===============================================================
        // 1. HEARTBEAT / HANDSHAKE (ADMS Device Ping)
        // ===============================================================
        [HttpGet]
        public async Task<IActionResult> Handshake(string SN, string options)
        {
            try
            {
                var parameters = new Dictionary<string, object> { { "@DeviceSerialNumber", SN } };
                DataTable dt = await _dataService.GetDataAsync("PRC_API_Check_Attendance_Device", parameters, _ConnectionString);

                if (dt != null && dt.Rows.Count > 0)
                {
                    StringBuilder sb = new StringBuilder();

                    sb.Append("GET OPTION FROM: " + SN + "\n");
                    sb.Append("Stamp=" + DateTime.Now.Ticks + "\n");
                    sb.Append("OpStamp=" + DateTime.Now.Ticks + "\n");
                    sb.Append("ErrorDelay=60\n");
                    sb.Append("Delay=30\n");
                    sb.Append("ResLog=0\n");
                    sb.Append("TransTimes=00:00;14:05\n");
                    sb.Append("TransInterval=1\n");

                    return Content(sb.ToString());
                }

                _logger.LogWarning("Handshake rejected for unknown or unauthorized device SN: {SN}", SN);
                return Content("ERROR: Unknown Device");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Handshake error for device SN: {SN}", SN);
                return Content("ERROR");
            }
        }

        // ===============================================================
        // 2. RECEIVE DEVICE PUNCH DATA (Unified Bulk Insertion)
        // ===============================================================
        [HttpPost]
        public async Task<IActionResult> ReceiveData(string SN, string table, int Stamp = 0)
        {
            if (table != "ATTLOG")
                return Content("OK");

            try
            {
                // 1. Validate device
                var parameters = new Dictionary<string, object>
                {
                    { "@DeviceSerialNumber", SN }
                };

                DataTable dtDevice = await _dataService.GetDataAsync("PRC_API_Check_Attendance_Device", parameters, _ConnectionString);

                if (dtDevice == null || dtDevice.Rows.Count == 0)
                {
                    _logger.LogWarning("Punch data rejected for unauthorized device SN: {SN}", SN);
                    return Content("ERROR: Device Not Authorized");
                }

                // 2. Read payload body
                string body;
                using (var reader = new StreamReader(Request.Body, Encoding.UTF8))
                {
                    body = await reader.ReadToEndAsync();
                }

                if (string.IsNullOrWhiteSpace(body))
                    return Content("OK");

                // 3. Populate TVP table for unified PRC_Bulk_Insert_RawPunch
                var punchTable = ETimeTrackRepository.CreateRawPunchTable();
                var lines = body.Split(new[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);

                foreach (var line in lines)
                {
                    var parts = line.Split('\t');
                    if (parts.Length < 2)
                        continue;

                    string empId = parts[0];
                    if (!DateTime.TryParse(parts[1], out DateTime punchTime))
                        continue;

                    string punchState = parts.Length > 2 ? parts[2] : "0";
                    punchTable.Rows.Add(SN, empId, punchTime, line, punchState, "ADMS");
                }

                if (punchTable.Rows.Count > 0)
                {
                    var insertedRows = await _attendanceRepo.BulkInsertRawPunchAsync(punchTable);

                    if (insertedRows != null && insertedRows.Rows.Count > 0)
                    {
                        foreach (DataRow r in insertedRows.Rows)
                        {
                            long rawPunchId = Convert.ToInt64(r["RawPunchId"]);

                            await _taskQueue.QueueBackgroundWorkItem(async token =>
                            {
                                try
                                {
                                    using var scope = _scopeFactory.CreateScope();
                                    var repo = scope.ServiceProvider.GetRequiredService<IETimeTrackRepository>();
                                    await repo.ProcessDailyAttendance(rawPunchId);
                                }
                                catch (Exception ex)
                                {
                                    _logger.LogError(ex, "Background punch processing error for RawPunchId: {RawPunchId}", rawPunchId);
                                }
                            });
                        }
                    }
                }

                return Content("OK");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ReceiveData error for device SN: {SN}", SN);
                return Content("ERROR");
            }
        }
    }
}
