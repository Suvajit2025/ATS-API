using System.ComponentModel.DataAnnotations;

namespace ATS.API.Models
{
    public class PsychometricRepositoryResult
    {
        public bool Success { get; set; }
        public string? Message { get; set; }
        public object? Data { get; set; }
        public object? ErrorData { get; set; }

        public static PsychometricRepositoryResult Ok(object? data)
        {
            return new PsychometricRepositoryResult
            {
                Success = true,
                Data = data
            };
        }

        public static PsychometricRepositoryResult Fail(string message, object? errorData = null)
        {
            return new PsychometricRepositoryResult
            {
                Success = false,
                Message = message,
                ErrorData = errorData
            };
        }
    }

    public class PsychometricAssessmentQuery
    {
        [Required]
        public string TenantId { get; set; } = string.Empty;
        public long? CompanyId { get; set; }
        public string LanguageCode { get; set; } = "en";
    }

    public class PsychometricStartAttemptRequest
    {
        [Required]
        public string TenantId { get; set; } = string.Empty;
        public long? CompanyId { get; set; }
        public long? ParticipantId { get; set; }
        public string? ExternalParticipantId { get; set; }
        public long? EmployeeId { get; set; }
        public long? CandidateId { get; set; }
        public string? DisplayName { get; set; }
        public string? Email { get; set; }
        public string? MobileNo { get; set; }
        public long? AssessmentAssignmentId { get; set; }
        public long? AnonymousGroupId { get; set; }
        public string? ProtectedParticipantReference { get; set; }
        public string LanguageCode { get; set; } = "en";
        public string? ClientMetadataJson { get; set; }
    }

    public class PsychometricSaveResponsesRequest
    {
        [Required]
        public string TenantId { get; set; } = string.Empty;

        [Required]
        public List<PsychometricQuestionResponseRequest> Responses { get; set; } = new();
    }

    public class PsychometricQuestionResponseRequest
    {
        public long AssessmentQuestionId { get; set; }
        public string ResponseType { get; set; } = "OPTION";
        public string? TextValue { get; set; }
        public decimal? NumericValue { get; set; }
        public bool? BooleanValue { get; set; }
        public string? JsonValue { get; set; }
        public List<PsychometricResponseOptionRequest> Options { get; set; } = new();
    }

    public class PsychometricResponseOptionRequest
    {
        public long QuestionOptionId { get; set; }
        public decimal? AllocatedValue { get; set; }
        public int? RankValue { get; set; }
        public bool IsMost { get; set; }
        public bool IsLeast { get; set; }
        public bool SelectedFlag { get; set; } = true;
    }

    public class PsychometricCompleteAttemptRequest
    {
        [Required]
        public string TenantId { get; set; } = string.Empty;
    }
}
