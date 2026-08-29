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
            IConfiguration config,
            IBackgroundTaskQueue taskQueue)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
            _config = config;
            _taskQueue = taskQueue;
            _pollSeconds = _config.GetValue<int>("EtimePollSeconds");
            if (_pollSeconds <= 0)
            {
                _pollSeconds = 120;
            }
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("ETimeTrack collector background service started");

            // Yield thread so ASP.NET Web API / Kestrel starts and binds ports immediately
            await Task.Yield();
            await Task.Delay(TimeSpan.FromSeconds(10), stoppingToken);

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
                    _logger.LogError(ex, "ETimeTrack collector service error");
                }

                await Task.Delay(
                    TimeSpan.FromSeconds(_pollSeconds),
                    stoppingToken);
            }
        }

        private async Task ProcessTenants(IETimeTrackRepository repo)
        {
            var tenants = await repo.GetETimeTrackTenantsAsync();
            if (tenants == null || tenants.Rows.Count == 0)
                return;

            // Always sync current month + previous month (covers month-boundary punch gaps)
            var today = DateTime.Today;
             
            var monthsToSync = Enumerable.Range(0, 3) //For find Last # month Gap , we need to sync 3 months instead of 2 months.
                .Select(i =>
                {
                    var date = today.AddMonths(-i);
                    return (Month: date.Month, Year: date.Year);
                })
                .ToArray();
            foreach (DataRow row in tenants.Rows)
            {
                try
                {
                    Guid tenantId = Guid.Parse(row["TenantId"].ToString()!);
                    DateTime latestTime = DateTime.MinValue;

                    foreach (var (month, year) in monthsToSync)
                    {
                        _logger.LogInformation("Syncing eTimeTrack logs for Tenant {TenantId} - {Month}/{Year}", tenantId, month, year);

                        int batchSize = 1000;
                        int offset = 0;

                        while (true)
                        {
                            var logs = await repo.GetDeviceLogsAsync(tenantId,offset,batchSize,month,year);

                            if (logs == null || logs.Rows.Count == 0)
                                break;

                            // Build TVP DataTable
                            var table = ETimeTrackRepository.CreateRawPunchTable();

                            foreach (DataRow log in logs.Rows)
                            {
                                string employeeId = log["EmployeeId"]?.ToString() ?? string.Empty;
                                DateTime punchTime = Convert.ToDateTime(log["PunchTime"]);

                                string direction = "0";
                                if (log["Direction"] != DBNull.Value &&
                                    !string.IsNullOrWhiteSpace(log["Direction"].ToString()))
                                {
                                    direction = log["Direction"].ToString()!;
                                }

                                string deviceId = log["SerialNumber"]?.ToString() ?? string.Empty;
                                string rawPayload = $"{employeeId} {punchTime:yyyy-MM-dd HH:mm:ss} {direction}";
                                ETimeTrackRepository.AddRawPunchRow(table, deviceId, employeeId, punchTime, rawPayload, direction, "ESSL");

                                if (punchTime > latestTime)
                                    latestTime = punchTime;
                            }

                            // Bulk insert all rows via PRC_Bulk_Insert_RawPunch (single SP call)
                            var insertedRows = await repo.BulkInsertRawPunchAsync(table);

                            // Enqueue each inserted RawPunchId for SP_SaaS_Attendance_Process_V5
                            if (insertedRows != null && insertedRows.Rows.Count > 0)
                            {
                                _logger.LogInformation("Inserted {Count} punches for Tenant {TenantId} {Month}/{Year}. Enqueuing for processing...",
                                    insertedRows.Rows.Count, tenantId, month, year);

                                foreach (DataRow r in insertedRows.Rows)
                                {
                                    long rawPunchId = Convert.ToInt64(r["RawPunchId"]);

                                    await _taskQueue.QueueBackgroundWorkItem(async token =>
                                    {
                                        try
                                        {
                                            using var scope = _scopeFactory.CreateScope();
                                            var bgRepo = scope.ServiceProvider
                                                .GetRequiredService<IETimeTrackRepository>();
                                            await bgRepo.ProcessDailyAttendance(rawPunchId);
                                        }
                                        catch (Exception ex)
                                        {
                                            _logger.LogError(ex, "Background ProcessDailyAttendance failed for RawPunchId {RawPunchId}", rawPunchId);
                                        }
                                    });
                                }
                            }

                            offset += batchSize;
                        }
                    }

                    // Update LastSyncTime to the latest punch found across both months
                    if (latestTime != DateTime.MinValue)
                    {
                        await repo.UpdateLastSyncAsync(tenantId, latestTime);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing eTimeTrack logs for Tenant {TenantId}", row["TenantId"]);
                }
            }
        }
    }
}
