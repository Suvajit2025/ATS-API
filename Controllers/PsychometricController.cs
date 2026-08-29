using ATS.API.Interface;
using ATS.API.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace ATS.API.Controllers
{
    [ApiController]
    [Route("api/psychometric")]
    public class PsychometricController : ControllerBase
    {
        private readonly IPsychometricRepository _psychometricRepository;

        public PsychometricController(IPsychometricRepository psychometricRepository)
        {
            _psychometricRepository = psychometricRepository;
        }

        [HttpGet("assessments/{assessmentCode}")]
        public async Task<IActionResult> GetAssessment(string assessmentCode, [FromQuery] PsychometricAssessmentQuery query)
        {
            if (string.IsNullOrWhiteSpace(query.TenantId))
                return BadRequest(new { Success = false, Message = "TenantId is required." });

            var result = await _psychometricRepository.GetAssessmentAsync(assessmentCode, query);
            return ToActionResult(result, notFoundWhenFailed: true);
        }

        [HttpPost("assessments/{assessmentCode}/attempts")]
        public async Task<IActionResult> StartAttempt(string assessmentCode, [FromBody] PsychometricStartAttemptRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.TenantId))
                return BadRequest(new { Success = false, Message = "TenantId is required." });

            if (!IsJsonOrEmptyOrSwaggerPlaceholder(request.ClientMetadataJson))
                return BadRequest(new { Success = false, Message = "ClientMetadataJson must be valid JSON." });

            var result = await _psychometricRepository.StartAttemptAsync(assessmentCode, request);
            return ToActionResult(result);
        }

        [HttpGet("attempts/{attemptId:long}")]
        public async Task<IActionResult> GetAttempt(long attemptId, [FromQuery] string tenantId)
        {
            if (string.IsNullOrWhiteSpace(tenantId))
                return BadRequest(new { Success = false, Message = "TenantId is required." });

            var result = await _psychometricRepository.GetAttemptAsync(attemptId, tenantId);
            return ToActionResult(result, notFoundWhenFailed: true);
        }

        [HttpPost("attempts/{attemptId:long}/responses")]
        public async Task<IActionResult> SaveResponses(long attemptId, [FromBody] PsychometricSaveResponsesRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.TenantId))
                return BadRequest(new { Success = false, Message = "TenantId is required." });

            if (request.Responses == null || request.Responses.Count == 0)
                return BadRequest(new { Success = false, Message = "At least one response is required." });

            foreach (var response in request.Responses)
            {
                if (response.AssessmentQuestionId <= 0)
                    return BadRequest(new { Success = false, Message = "AssessmentQuestionId is required for every response." });

                if (!IsJsonOrEmpty(response.JsonValue))
                    return BadRequest(new { Success = false, Message = $"JsonValue must be valid JSON for AssessmentQuestionId {response.AssessmentQuestionId}." });
            }

            var result = await _psychometricRepository.SaveResponsesAsync(attemptId, request);
            return ToActionResult(result);
        }

        [HttpPost("attempts/{attemptId:long}/complete")]
        public async Task<IActionResult> CompleteAttempt(long attemptId, [FromBody] PsychometricCompleteAttemptRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.TenantId))
                return BadRequest(new { Success = false, Message = "TenantId is required." });

            var result = await _psychometricRepository.CompleteAttemptAsync(attemptId, request);
            return ToActionResult(result);
        }

        [HttpGet("attempts/{attemptId:long}/result")]
        public async Task<IActionResult> GetResult(long attemptId, [FromQuery] string tenantId)
        {
            if (string.IsNullOrWhiteSpace(tenantId))
                return BadRequest(new { Success = false, Message = "TenantId is required." });

            var result = await _psychometricRepository.GetResultAsync(attemptId, tenantId);
            return ToActionResult(result, notFoundWhenFailed: true);
        }

        [HttpGet("reports/participants/{participantId:long}")]
        public async Task<IActionResult> GetParticipantReports(long participantId, [FromQuery] string tenantId)
        {
            if (string.IsNullOrWhiteSpace(tenantId))
                return BadRequest(new { Success = false, Message = "TenantId is required." });

            var result = await _psychometricRepository.GetParticipantReportsAsync(participantId, tenantId);
            return ToActionResult(result);
        }

        private IActionResult ToActionResult(PsychometricRepositoryResult result, bool notFoundWhenFailed = false)
        {
            if (!result.Success)
            {
                var body = new { Success = false, result.Message, result.ErrorData };
                return notFoundWhenFailed ? NotFound(body) : BadRequest(body);
            }

            return Ok(new { Success = true, result.Data });
        }

        private static bool IsJsonOrEmpty(string? value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return true;

            try
            {
                JsonConvert.DeserializeObject(value);
                return true;
            }
            catch
            {
                return false;
            }
        }

        private static bool IsJsonOrEmptyOrSwaggerPlaceholder(string? value)
        {
            return string.Equals(value?.Trim(), "string", StringComparison.OrdinalIgnoreCase)
                || IsJsonOrEmpty(value);
        }
    }
}
