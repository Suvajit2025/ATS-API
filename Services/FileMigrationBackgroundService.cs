namespace ATS.API.Services
{
    public class FileMigrationBackgroundService : BackgroundService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<FileMigrationBackgroundService> _logger;
        private readonly IConfiguration _config;

        public FileMigrationBackgroundService(
            IServiceScopeFactory scopeFactory,
            ILogger<FileMigrationBackgroundService> logger,
            IConfiguration config)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
            _config = config;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("File Migration Background Service started.");

            // Read settings from appsettings.json
            bool isEnabled = _config.GetValue<bool>("FileMigration:Enabled", true);
            int intervalMinutes = _config.GetValue<int>("FileMigration:IntervalMinutes", 30);
            int batchSize = _config.GetValue<int>("FileMigration:BatchSize", 500);

            if (intervalMinutes <= 0) intervalMinutes = 30;
            if (batchSize <= 0) batchSize = 500;

            // Initial delay of 1 minute after application start before starting the first migration
            await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);

            while (!stoppingToken.IsCancellationRequested)
            {
                if (isEnabled)
                {
                    try
                    {
                        _logger.LogInformation("Starting scheduled 30-min file migration cycle...");

                        using var scope = _scopeFactory.CreateScope();
                        var migrationService = scope.ServiceProvider.GetRequiredService<FileMigrationService>();

                        // 1. Process Images
                        _logger.LogInformation("Processing batch of up to {BatchSize} images...", batchSize);
                        await migrationService.MigrateImagesAsync(batchSize, stoppingToken);

                        // 2. Process Resumes
                        _logger.LogInformation("Processing batch of up to {BatchSize} resumes...", batchSize);
                        await migrationService.MigrateResumesAsync(batchSize, stoppingToken);

                        _logger.LogInformation("Completed scheduled file migration cycle.");
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Error occurred during file migration background job.");
                    }
                }

                _logger.LogInformation("File Migration Background Service sleeping for {Minutes} minutes...", intervalMinutes);
                await Task.Delay(TimeSpan.FromMinutes(intervalMinutes), stoppingToken);
            }

            _logger.LogInformation("File Migration Background Service stopping.");
        }
    }
}
