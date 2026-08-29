using ATS.API.Models;

namespace ATS.API.Interface
{
    public interface IPsychometricRepository
    {
        Task<PsychometricRepositoryResult> GetAssessmentAsync(string assessmentCode, PsychometricAssessmentQuery query);
        Task<PsychometricRepositoryResult> StartAttemptAsync(string assessmentCode, PsychometricStartAttemptRequest request);
        Task<PsychometricRepositoryResult> GetAttemptAsync(long attemptId, string tenantId);
        Task<PsychometricRepositoryResult> SaveResponsesAsync(long attemptId, PsychometricSaveResponsesRequest request);
        Task<PsychometricRepositoryResult> CompleteAttemptAsync(long attemptId, PsychometricCompleteAttemptRequest request);
        Task<PsychometricRepositoryResult> GetResultAsync(long attemptId, string tenantId);
        Task<PsychometricRepositoryResult> GetParticipantReportsAsync(long participantId, string tenantId);
    }
}
