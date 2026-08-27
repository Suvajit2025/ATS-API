using ATS.API.Interface;
using ATS.API.Repository;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace ATS.API.Services
{
    public class MidnightAttendanceService : BackgroundService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly IConfiguration _config;
        private readonly ILogger<MidnightAttendanceService> _logger;

        public MidnightAttendanceService(
            IServiceScopeFactory scopeFactory,
            IConfiguration config,
            ILogger<MidnightAttendanceService> logger)
        {
            _scopeFactory = scopeFactory;
            _config = config;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Midnight Attendance background service started.");

            // Yield thread so ASP.NET Web API / Kestrel starts and binds ports immediately
            await Task.Yield();

            string timeStr = _config["AttendanceJobs:MidnightInitTime"] ?? "00:30";

            if (!int.TryParse(_config["AttendanceJobs:EmployeeBatchSize"], out int batchSize) || batchSize <= 0)
            {
                batchSize = 500;
            }

            if (!int.TryParse(_config["AttendanceJobs:TenantParallelWorkers"], out int tenantWorkers) || tenantWorkers <= 0)
            {
                tenantWorkers = 5;
            }

            if (!TimeSpan.TryParse(timeStr, out TimeSpan scheduled))
            {
                scheduled = new TimeSpan(0, 30, 0);
            }

            _logger.LogInformation("Midnight Attendance Service scheduled to run daily at {ScheduledTime}", scheduled);

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    DateTime now = DateTime.Now;
                    DateTime nextRun = DateTime.Today.Add(scheduled);

                    if (now >= nextRun)
                    {
                        nextRun = nextRun.AddDays(1);
                    }

                    TimeSpan delay = nextRun - now;
                    _logger.LogInformation("Next midnight attendance run scheduled at {NextRun} (waiting {Delay})", nextRun, delay);

                    await Task.Delay(delay, stoppingToken);

                    if (stoppingToken.IsCancellationRequested)
                        break;

                    _logger.LogInformation("Starting daily attendance initialization for all active tenants...");

                    using var scope = _scopeFactory.CreateScope();
                    var repo = scope.ServiceProvider.GetRequiredService<IETimeTrackRepository>();

                    await repo.CreateDailyAttendanceForAllTenants(batchSize, tenantWorkers, stoppingToken);

                    _logger.LogInformation("Completed daily attendance initialization for all active tenants.");
                }
                catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
                {
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error in Midnight Attendance background service");
                    // Delay a brief moment before retrying calculation next time
                    await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken);
                }
            }
        }
    }
}