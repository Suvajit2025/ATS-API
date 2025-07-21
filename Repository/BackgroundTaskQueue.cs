using ATS.API.Interface;
using System.Threading.Channels;

namespace ATS.API.Repository
{
    //public class BackgroundTaskQueue : IBackgroundTaskQueue
    //{
    //    private readonly Channel<Func<CancellationToken, Task>> _queue;

    //    public BackgroundTaskQueue()
    //    {
    //        _queue = Channel.CreateUnbounded<Func<CancellationToken, Task>>();
    //    }

    //    // Enqueue tasks to be processed
    //    public async Task QueueBackgroundWorkItem(Func<CancellationToken, Task> workItem)
    //    {
    //        await _queue.Writer.WriteAsync(workItem);
    //    }

    //    // Process the tasks from the queue
    //    public async Task ProcessQueueAsync(CancellationToken cancellationToken)
    //    {
    //        await foreach (var workItem in _queue.Reader.ReadAllAsync(cancellationToken))
    //        {
    //            try
    //            {
    //                await workItem(cancellationToken);  // Execute the background task
    //            }
    //            catch (Exception ex)
    //            {
    //                // Log error if something goes wrong with the task
    //                Console.WriteLine($"Error processing background task: {ex.Message}");
    //            }
    //        }
    //    }
    //}
    public class BackgroundTaskQueue : IBackgroundTaskQueue
    {
        private readonly Channel<Func<CancellationToken, Task>> _queue;
        private readonly int _maxConcurrency;

        public BackgroundTaskQueue(int maxConcurrency)
        {
            _queue = Channel.CreateUnbounded<Func<CancellationToken, Task>>();
            _maxConcurrency = maxConcurrency;
        }

        public async Task QueueBackgroundWorkItem(Func<CancellationToken, Task> workItem)
        {
            if (workItem == null) throw new ArgumentNullException(nameof(workItem));
            await _queue.Writer.WriteAsync(workItem);
        }

        public async Task ProcessQueueAsync(CancellationToken cancellationToken)
        {
            var semaphore = new SemaphoreSlim(_maxConcurrency);
            var tasks = new List<Task>();

            await foreach (var workItem in _queue.Reader.ReadAllAsync(cancellationToken))
            {
                await semaphore.WaitAsync(cancellationToken);

                var task = Task.Run(async () =>
                {
                    try
                    {
                        await workItem(cancellationToken);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error processing background task: {ex.Message}");
                    }
                    finally
                    {
                        semaphore.Release();
                    }
                }, cancellationToken);

                tasks.Add(task);
            }

            await Task.WhenAll(tasks);
        }
    }
  
}
