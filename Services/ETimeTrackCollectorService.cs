using ATS.API.Interface;
using ATS.API.Repository;
using System.Data;

namespace ATS.API.Services
{
    public class ETimeTrackCollectorService : BackgroundService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<ETimeTrackCollectorService> _logger;
        private readonly IConfiguration _config;
        private readonly IBackgroundTaskQueue _taskQueue;
        private readonly int _pollSeconds;

        public ETimeTrackCollectorService(
            IServiceScopeFactory scopeFactory,
            ILogger<ETimeTrackCollectorService> logger,
            IConfiguration config, IBackgroundTaskQueue taskQueue)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
            _config = config;
            _taskQueue = taskQueue;
            _pollSeconds = _config.GetValue<int>("EtimePollSeconds");
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("ETimeTrack collector started");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using var scope = _scopeFactory.CreateScope();

                    var repo = scope.ServiceProvider
                        .GetRequiredService<IETimeTrackRepository>();

                    await ProcessTenants(repo);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Collector error");
                }

                await Task.Delay(
                    TimeSpan.FromSeconds(_pollSeconds),
                    stoppingToken);
            }
        }

        private async Task ProcessTenants(IETimeTrackRepository repo)
        {
            var tenants = await repo.GetETimeTrackTenantsAsync();

            foreach (DataRow row in tenants.Rows)
            {
                Guid tenantId = Guid.Parse(row["TenantId"].ToString());

                int batchSize = 1000;
                int offset = 0;
                DateTime latestTime = DateTime.MinValue;

                while (true)
                {
                    var logs = await repo.GetDeviceLogsAsync(
                        tenantId,
                        offset,
                        batchSize);

                    if (logs.Rows.Count == 0)
                        break;

                    // TVP DataTable
                    var table = new DataTable();
                    table.Columns.Add("SN", typeof(string));
                    table.Columns.Add("EmployeeId", typeof(string));
                    table.Columns.Add("PunchTime", typeof(DateTime));
                    table.Columns.Add("RawPayload", typeof(string));
                    table.Columns.Add("PunchState", typeof(string));
                    table.Columns.Add("DeviceType", typeof(string));

                    foreach (DataRow log in logs.Rows)
                    {
                        string employeeId = log["EmployeeId"].ToString();
                        DateTime punchTime = Convert.ToDateTime(log["PunchTime"]);

                        string direction = "0";
                        if (log["Direction"] != DBNull.Value &&
                            !string.IsNullOrWhiteSpace(log["Direction"].ToString()))
                        {
                            direction = log["Direction"].ToString();
                        }

                        string deviceId = log["SerialNumber"]?.ToString();

                        string rawPayload = $"{employeeId} {punchTime:yyyy-MM-dd HH:mm:ss} {direction}";

                        table.Rows.Add(deviceId,employeeId,punchTime,rawPayload,direction,"ESSL");

                        if (punchTime > latestTime)
                            latestTime = punchTime;
                    }

                    // Bulk insert once
                    var insertedRows = await repo.BulkInsertRawPunchAsync(table);

                    // send RawPunchId to background processor
                    foreach (DataRow r in insertedRows.Rows)
                    {
                        long rawPunchId = Convert.ToInt64(r["RawPunchId"]);

                        _taskQueue.QueueBackgroundWorkItem(async token =>
                        {
                            using var scope = _scopeFactory.CreateScope();

                            var bgRepo = scope.ServiceProvider
                                .GetRequiredService<IETimeTrackRepository>();

                            await bgRepo.ProcessDailyAttendance(rawPunchId);
                        });
                    }

                    offset += batchSize;
                }
                if (latestTime != DateTime.MinValue)
                {
                    await repo.UpdateLastSyncAsync(tenantId, latestTime);
                }
            }
        }
    }
}