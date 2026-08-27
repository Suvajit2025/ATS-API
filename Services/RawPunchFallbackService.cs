using ATS.API.Interface;
using ATS.API.Repository;
using System.Data;

namespace ATS.API.Services
{
    public class RawPunchFallbackService : BackgroundService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<RawPunchFallbackService> _logger;
        private readonly IBackgroundTaskQueue _taskQueue;
        private readonly IConfiguration _config;
        private readonly int _pollSeconds;

        public RawPunchFallbackService(
            IServiceScopeFactory scopeFactory,
            ILogger<RawPunchFallbackService> logger,
            IBackgroundTaskQueue taskQueue,
            IConfiguration config)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
            _taskQueue = taskQueue;
            _config = config;
            _pollSeconds = _config.GetValue<int>("AttendanceJobs:FallbackPollSeconds");
            if (_pollSeconds <= 0)
            {
                _pollSeconds = 60;
            }
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("RawPunch fallback processor background service started");

            // Yield thread so ASP.NET Web API / Kestrel starts and binds ports immediately
            await Task.Yield();
            await Task.Delay(TimeSpan.FromSeconds(15), stoppingToken);

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using var scope = _scopeFactory.CreateScope();

                    var repo = scope.ServiceProvider
                        .GetRequiredService<IETimeTrackRepository>();

                    var punches = await repo.GetUnprocessedPunchesAsync();

                    if (punches != null && punches.Rows.Count > 0)
                    {
                        foreach (DataRow row in punches.Rows)
                        {
                            if (row["RawPunchId"] != DBNull.Value && long.TryParse(row["RawPunchId"].ToString(), out long rawPunchId))
                            {
                                await _taskQueue.QueueBackgroundWorkItem(async token =>
                                {
                                    using var innerScope = _scopeFactory.CreateScope();

                                    var innerRepo = innerScope.ServiceProvider
                                        .GetRequiredService<IETimeTrackRepository>();

                                    await innerRepo.ProcessDailyAttendance(rawPunchId);
                                });
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "RawPunch fallback job error");
                }

                await Task.Delay(TimeSpan.FromSeconds(_pollSeconds), stoppingToken);
            }
        }
    }
}