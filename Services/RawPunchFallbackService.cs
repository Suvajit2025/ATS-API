using ATS.API.Models;
using ATS.API.Repository;
using Microsoft.Extensions.Options;
using System.Data;

namespace ATS.API.Services
{
    public class RawPunchFallbackService : BackgroundService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<RawPunchFallbackService> _logger;
        private readonly AttendanceJobSettings _jobSettings;

        public RawPunchFallbackService(
            IServiceScopeFactory scopeFactory,
            ILogger<RawPunchFallbackService> logger,
            IOptions<AttendanceJobSettings> jobSettings)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
            _jobSettings = jobSettings.Value;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Fallback started");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    while (!stoppingToken.IsCancellationRequested)
                    {
                        using var scope = _scopeFactory.CreateScope();

                        var repo = scope.ServiceProvider
                            .GetRequiredService<IETimeTrackRepository>();

                        var punches = await repo.GetUnprocessedPunchesAsync();

                        if (punches.Rows.Count == 0)
                        {
                            _logger.LogInformation("No pending data");
                            break;
                        }

                        var rawPunchIds = punches.Rows
                            .Cast<DataRow>()
                            .Select(row => Convert.ToInt64(row["RawPunchId"]))
                            .ToList();

                        var parallelOptions = new ParallelOptions
                        {
                            CancellationToken = stoppingToken,
                            MaxDegreeOfParallelism = Math.Max(1, _jobSettings.RawPunchParallelWorkers)
                        };

                        await Parallel.ForEachAsync(rawPunchIds, parallelOptions, async (id, token) =>
                        {
                            using var innerScope = _scopeFactory.CreateScope();

                            var innerRepo = innerScope.ServiceProvider
                                .GetRequiredService<IETimeTrackRepository>();

                            await innerRepo.ProcessDailyAttendance(id);
                        });

                        _logger.LogInformation(
                            "Processed {Count} pending raw punches using {Workers} workers",
                            rawPunchIds.Count,
                            parallelOptions.MaxDegreeOfParallelism);

                        await Task.Delay(2_000, stoppingToken);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error in fallback");
                }

                await Task.Delay(TimeSpan.FromHours(1), stoppingToken);
            }
        }
    }
}
