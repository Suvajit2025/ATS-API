using ATS.API.Interface;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace ATS.API.Repository
{
    public class CandidateProcessor : ICandidateProcessor
    {
        private readonly IATSHelper _atsHelper;
        private readonly int _maxConcurrency;

        public CandidateProcessor(IATSHelper atsHelper, int maxConcurrency)
        {
            _atsHelper = atsHelper;
            _maxConcurrency = maxConcurrency;
        }

        // Process candidates in batches with controlled concurrency
        public async Task ProcessCandidates(List<string> candidateUsernames, string atsUrl)
        {
            var semaphore = new SemaphoreSlim(_maxConcurrency);  // Limit concurrency based on _maxConcurrency
            var tasks = new List<Task>();

            foreach (var username in candidateUsernames)
            {
                await semaphore.WaitAsync(); // Wait until the semaphore allows

                tasks.Add(Task.Run(async () =>
                {
                    try
                    {
                        await _atsHelper.SendAtsScoreRequest(username, atsUrl); // Call the ATS API for each username
                    }
                    finally
                    {
                        semaphore.Release(); // Release the semaphore slot after completion
                    }
                }));
            }

            // Wait for all tasks to complete
            await Task.WhenAll(tasks);
            Console.WriteLine("All candidates processed.");
        }
    }
}
