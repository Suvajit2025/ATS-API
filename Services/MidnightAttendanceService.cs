using ATS.API.Interface;
using ATS.API.Repository;
using Microsoft.Extensions.Hosting;

public class MidnightAttendanceService : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly IConfiguration _config;

    public MidnightAttendanceService(
        IServiceScopeFactory scopeFactory,
        IConfiguration config)
    {
        _scopeFactory = scopeFactory;
        _config = config;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        string timeStr = _config["AttendanceJobs:MidnightInitTime"] ?? "00:30";

        int batchSize = int.Parse(_config["AttendanceJobs:EmployeeBatchSize"] ?? "500");
        int tenantWorkers = int.Parse(_config["AttendanceJobs:TenantParallelWorkers"] ?? "5");

        TimeSpan scheduled = TimeSpan.Parse(timeStr);

        while (!stoppingToken.IsCancellationRequested)
        {
            DateTime now = DateTime.Now;
            DateTime nextRun = DateTime.Today.Add(scheduled);

            if (now > nextRun)
                nextRun = nextRun.AddDays(1);

            TimeSpan delay = nextRun - now;

            await Task.Delay(delay, stoppingToken);

            // ✅ Create scope
            using var scope = _scopeFactory.CreateScope();

            var repo = scope.ServiceProvider
                .GetRequiredService<IETimeTrackRepository>();

            await repo.CreateDailyAttendanceForAllTenants(
                batchSize,
                tenantWorkers,
                stoppingToken);
        }
    }
}