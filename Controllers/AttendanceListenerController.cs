using ATS.API.Interface;
using ATS.API.Repository;
using CommonUtility.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Text;

namespace ATS.API.Controllers
{
    [Route("iclock/cdata")]
    [ApiController]
    public class AttendanceListenerController : ControllerBase
    {
        private readonly IBackgroundTaskQueue _taskQueue;
        private readonly IDataService _dataService;
        private readonly string _ConnectionString;
        private readonly IETimeTrackRepository _attendanceRepo;
        private readonly IServiceScopeFactory _scopeFactory;
        public AttendanceListenerController(IBackgroundTaskQueue taskQueue, IConfiguration configuration, IDataService dataService, IETimeTrackRepository eTimeTrackRepository, IServiceScopeFactory scopeFactory)
        {
            _dataService = dataService;
            _ConnectionString = configuration.GetConnectionString("DBConnSaaSEssP");
            _taskQueue = taskQueue;
            _attendanceRepo = eTimeTrackRepository;
            _scopeFactory = scopeFactory;
        }
        // ===============================================================
        // 1. HEARTBEAT
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

                return Content("ERROR: Unknown Device");
            }
            catch
            {
                return Content("ERROR");
            }
        }
        
        [HttpPost]
        public async Task<IActionResult> ReceiveData(string SN, string table, int Stamp = 0)
        {
            // 1. Quick exit if not the correct table
            if (table != "ATTLOG")
                return Content("OK");

            try
            {
                // 2. Validate device first
                var parameters = new Dictionary<string, object>
                {
                    { "@DeviceSerialNumber", SN }
                };

                DataTable dtDevice = await _dataService.GetDataAsync("PRC_API_Check_Attendance_Device", parameters, _ConnectionString);

                if (dtDevice == null || dtDevice.Rows.Count == 0)
                    return Content("ERROR: Device Not Authorized");

                // 3. Read the payload body
                string body;
                using (var reader = new StreamReader(Request.Body, Encoding.UTF8))
                {
                    body = await reader.ReadToEndAsync();
                }

                if (string.IsNullOrWhiteSpace(body))
                    return Content("OK");

                // 4. Parse Lines
                var lines = body.Split(new[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);

                foreach (var line in lines)
                {
                    var parts = line.Split('\t');

                    // Skip malformed lines
                    if (parts.Length < 2)
                        continue;

                    string empId = parts[0];

                    // Try to parse the DateTime from the second column
                    if (!DateTime.TryParse(parts[1], out DateTime punchTime))
                        continue;

                    // Optional status column
                    string punchState = parts.Length > 2 ? parts[2] : "0";

                    // 5. Queue background processing
                    // We capture 'line', 'empId', 'punchTime', and 'punchState' inside the loop
                    await _taskQueue.QueueBackgroundWorkItem(async token =>
                    {
                        try
                        {
                            using var scope = _scopeFactory.CreateScope();
                            var repo = scope.ServiceProvider.GetRequiredService<IETimeTrackRepository>();

                            // Call the Stored Procedure (with Transaction logic we added earlier)
                            long rawPunchId = await repo.InsertRawPunchAsync(SN, empId, punchTime, line, punchState, "DEVICE");

                            // If it was inserted (and wasn't a duplicate), process it
                            if (rawPunchId > 0)
                            {
                                await repo.ProcessDailyAttendance(rawPunchId);
                            }
                        }
                        catch (Exception ex)
                        {
                            // Log the error (consider using ILogger instead of Console)
                            Console.WriteLine($"Punch processing error for {empId}: {ex.Message}");
                        }
                    });
                }

                return Content("OK");
            }
            catch (Exception ex)
            {
                // Log the specific exception here if possible
                return Content("ERROR");
            }
        }
    }
}
