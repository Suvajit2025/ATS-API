using ATS.API.Interface;
using ATS.API.Repository;
using Microsoft.Extensions.Hosting;

public class MidnightAttendanceService : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly IConfiguration _config;
    private readonly ILogger<MidnightAttendanceService> _logger;

    private readonly Dictionary<string, DateTime> _lastRun = new();

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
        int batchSize = int.Parse(_config["AttendanceJobs:EmployeeBatchSize"] ?? "500");
        int tenantWorkers = int.Parse(_config["AttendanceJobs:TenantParallelWorkers"] ?? "5");

        // ✅ Read RunTimes from config
        var runTimeStrings = _config.GetSection("AttendanceJobs:RunTimes").Get<string[]>()
                             ?? Array.Empty<string>();

        var runTimes = new List<TimeSpan>();

        foreach (var timeStr in runTimeStrings)
        {
            if (TimeSpan.TryParse(timeStr, out var ts))
            {
                runTimes.Add(ts);
            }
            else
            {
                _logger.LogWarning($"Invalid time format in config: {timeStr}");
            }
        }

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                var now = DateTime.Now;

                foreach (var runTime in runTimes)
                {
                    string key = runTime.ToString();

                    if (!_lastRun.ContainsKey(key))
                        _lastRun[key] = DateTime.MinValue;

                    DateTime scheduled = DateTime.Today.Add(runTime);

                    // ✅ Run if time passed and not already executed today
                    if (now >= scheduled && _lastRun[key].Date != now.Date)
                    {
                        _logger.LogInformation($"Running attendance job for {runTime} at {now}");

                        using var scope = _scopeFactory.CreateScope();

                        var repo = scope.ServiceProvider
                            .GetRequiredService<IETimeTrackRepository>();

                        await repo.CreateDailyAttendanceForAllTenants(batchSize, tenantWorkers, stoppingToken);

                        _lastRun[key] = now;
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in MidnightAttendanceService");
            }

            await Task.Delay(TimeSpan.FromMinutes(2), stoppingToken);
        }
    }
}