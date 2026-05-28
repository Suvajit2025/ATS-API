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

        public RawPunchFallbackService(IServiceScopeFactory scopeFactory,ILogger<RawPunchFallbackService> logger,IBackgroundTaskQueue taskQueue)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
            _taskQueue = taskQueue;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("RawPunch fallback processor started");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using var scope = _scopeFactory.CreateScope();

                    var repo = scope.ServiceProvider
                        .GetRequiredService<IETimeTrackRepository>();

                    var punches = await repo.GetUnprocessedPunchesAsync();

                    foreach (DataRow row in punches.Rows)
                    {
                        long rawPunchId = Convert.ToInt64(row["RawPunchId"]);

                        await _taskQueue.QueueBackgroundWorkItem(async token =>
                        {
                            using var innerScope = _scopeFactory.CreateScope();

                            var innerRepo = innerScope.ServiceProvider
                                .GetRequiredService<IETimeTrackRepository>();

                            await innerRepo.ProcessDailyAttendance(rawPunchId);
                        });
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Fallback job error");
                }

                await Task.Delay(TimeSpan.FromSeconds(60), stoppingToken);
            }
        }
    }
}