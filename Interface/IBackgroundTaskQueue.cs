namespace ATS.API.Interface
{
    //public interface IBackgroundTaskQueue
    //{
    //    Task QueueBackgroundWorkItem(Func<CancellationToken, Task> workItem);
    //}
    public interface IBackgroundTaskQueue
    {
        Task QueueBackgroundWorkItem(Func<CancellationToken, Task> workItem);
        Task ProcessQueueAsync(CancellationToken cancellationToken); // ← add this if not already
    }
}
