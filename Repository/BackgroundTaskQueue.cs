using ATS.API.Interface;
using System.Threading.Channels;

namespace ATS.API.Repository
{
    public class BackgroundTaskQueue : IBackgroundTaskQueue
    {
        private readonly Channel<Func<CancellationToken, Task>> _queue;
        private readonly int _maxConcurrency;

        public BackgroundTaskQueue(int maxConcurrency)
        {
            _maxConcurrency = maxConcurrency;

            _queue = Channel.CreateBounded<Func<CancellationToken, Task>>(
                new BoundedChannelOptions(2000)
                {
                    FullMode = BoundedChannelFullMode.Wait
                });
        }

        public async Task QueueBackgroundWorkItem(Func<CancellationToken, Task> workItem)
        {
            if (workItem == null)
                throw new ArgumentNullException(nameof(workItem));

            await _queue.Writer.WriteAsync(workItem);
        }

        public async Task ProcessQueueAsync(CancellationToken cancellationToken)
        {
            var workers = new List<Task>();

            for (int i = 0; i < _maxConcurrency; i++)
            {
                workers.Add(Task.Run(async () =>
                {
                    await foreach (var workItem in _queue.Reader.ReadAllAsync(cancellationToken))
                    {
                        try
                        {
                            await workItem(cancellationToken);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"Error processing background task: {ex.Message}");
                        }
                    }
                }, cancellationToken));
            }

            await Task.WhenAll(workers);
        }
    }
}