using Microsoft.AspNetCore.Http;

namespace ATS.API.Models
{
    public class SaveCandidateInfoRequest
    {
        public long CandidateId { get; set; } = 0;
        public int PostId { get; set; }
        public int CompanyId { get; set; }
        public int DepartmentId { get; set; }

        public string CandidateName { get; set; } = string.Empty;
        public string MailId { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;

        public IFormFile? Image { get; set; }
        public IFormFile? CV { get; set; }
        public IFormFile? PhotoFile { get; set; }
        public IFormFile? CVFile { get; set; }

        public string ImageName { get; set; } = string.Empty;
        public string OriginalCvName { get; set; } = string.Empty;
        public string SavedCvName { get; set; } = string.Empty;
        public string FileHash { get; set; } = string.Empty;
        public int AtsHeadRatingId { get; set; }
        public long? GeneratedCandidateId { get; set; }
        public string Status { get; set; } = "LmsApplication";
        public bool IsShortlisted { get; set; }
        public bool IsDuplicate { get; set; }
        public long? DuplicateOfLogId { get; set; }
        public string ScoreJson { get; set; } = string.Empty;
        public string CandidateJson { get; set; } = string.Empty;
    }

    public class SaveBulkResumeAtsScoreRequest : SaveCandidateInfoRequest
    {
    }

    public class BulkResumeManualExamLinkRequest
    {
        public long TempCandidateId { get; set; }
        public string ManualReason { get; set; } = string.Empty;
    }

    public class BulkResumeExamResultRequest
    {
        public long? TempCandidateId { get; set; }
        public long? CandidateId { get; set; }
        public decimal ExamMarksObtainScore { get; set; }
        public bool IsShortlisted { get; set; }
        public bool CreateCandidateOverride { get; set; }
        public string? ManualReason { get; set; } = string.Empty;
    }

    public class BulkResumeQueuedFile
    {
        public string OriginalFileName { get; set; } = string.Empty;
        public string SavedFileName { get; set; } = string.Empty;
        public string SavedFilePath { get; set; } = string.Empty;
        public string FileHash { get; set; } = string.Empty;
    }
}
