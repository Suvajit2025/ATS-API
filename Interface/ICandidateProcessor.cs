namespace ATS.API.Interface
{
    public interface ICandidateProcessor
    {
        Task ProcessCandidates(List<string> candidateUsernames, String _ATSUrl);
    }
}
