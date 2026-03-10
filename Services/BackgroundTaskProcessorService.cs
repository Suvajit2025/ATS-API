using ATS.API.Interface;
using ATS.API.Repository; 

namespace ATS.API.Services
{
    public class BackgroundTaskProcessorService : BackgroundService
    {
        private readonly IBackgroundTaskQueue _taskQueue;
        private readonly ILogger<BackgroundTaskProcessorService> _logger;

        public BackgroundTaskProcessorService(IBackgroundTaskQueue taskQueue, ILogger<BackgroundTaskProcessorService> logger)
        {
            _taskQueue = taskQueue;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("Background task processing started...");
            await _taskQueue.ProcessQueueAsync(cancellationToken);
            _logger.LogInformation("Background task processing completed.");
        }
    }

}
