using ATS.API.Models;
using ATS.API.Repository;
using Microsoft.Data.SqlClient;
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
            _logger.LogInformation("Fallback service started");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    using var scope = _scopeFactory.CreateScope();
                    var repo = scope.ServiceProvider.GetRequiredService<IETimeTrackRepository>();

                    // 🔥 Now returns RawPunchId + EmployeeId + PunchDate
                    var punches = await repo.GetUnprocessedPunchesAsync(_jobSettings.EmployeeBatchSize);

                    if (punches.Rows.Count == 0)
                    {
                        _logger.LogInformation("No pending punches");
                        await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken);
                        continue;
                    }

                    // ✅ GROUP BY Employee + Date (KEY FIX)
                    var groupedPunches = punches.Rows
                        .Cast<DataRow>()
                        .GroupBy(row => new
                        {
                            Emp = row["EmployeeId"].ToString(),
                            Date = Convert.ToDateTime(row["PunchDate"]).Date
                        })
                        .ToList();

                    var parallelOptions = new ParallelOptions
                    {
                        CancellationToken = stoppingToken,
                        MaxDegreeOfParallelism = Math.Min(3, _jobSettings.RawPunchParallelWorkers)
                    };

                    // 🔥 Parallel across employees only
                    await Parallel.ForEachAsync(groupedPunches, parallelOptions, async (group, token) =>
                    {
                        try
                        {
                            // 🔥 Sequential inside group (NO DEADLOCK)
                            foreach (var row in group.OrderBy(r => r["RawPunchId"]))
                            {
                                var id = Convert.ToInt64(row["RawPunchId"]);
                                await ProcessWithRetry(id, token);
                            }
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex, "Error processing group for Employee {Emp}", group.Key.Emp);
                        }
                    });

                    _logger.LogInformation(
                        "Processed {Count} punches in {Groups} groups",
                        punches.Rows.Count,
                        groupedPunches.Count);

                    await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error in fallback service loop");
                    await Task.Delay(TimeSpan.FromSeconds(15), stoppingToken);
                }
            }

            _logger.LogInformation("Fallback service stopped");
        }

        // 🔥 DEADLOCK RETRY (KEEP THIS)
        private async Task ProcessWithRetry(long id, CancellationToken token)
        {
            int retry = 0;
            int maxRetry = 3;

            while (true)
            {
                try
                {
                    token.ThrowIfCancellationRequested();

                    using var scope = _scopeFactory.CreateScope();
                    var repo = scope.ServiceProvider.GetRequiredService<IETimeTrackRepository>();

                    await repo.ProcessDailyAttendance(id);
                    return;
                }
                catch (SqlException ex) when (ex.Number == 1205)
                {
                    retry++;

                    _logger.LogWarning(
                        "Deadlock detected for RawPunchId {Id}, retry {Retry}",
                        id, retry);

                    if (retry > maxRetry)
                    {
                        _logger.LogError("Max retry reached for RawPunchId {Id}", id);
                        return;
                    }

                    await Task.Delay(200 * retry, token);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing RawPunchId {Id}", id);
                    return;
                }
            }
        }
    }
}