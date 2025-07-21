using ATS.API.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ATS.API.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ATSBatchProcessController : ControllerBase
    {
        private readonly ICandidateProcessor _candidateProcessor;
        public string _ProductionAPI;
        public string _DevelopmentAPI;
        // Constructor Injection
        public ATSBatchProcessController(ICandidateProcessor candidateProcessor, IConfiguration configuration)
        {
            _candidateProcessor = candidateProcessor;
            _ProductionAPI = configuration["ProductionATSApi"];
            _DevelopmentAPI = configuration["DevelopmentATSApi"];
        }

        [HttpPost("ProcessBatchProduction")]
        public async Task<IActionResult> ProcessCandidatesInBatch(List<string> candidateUsernames)
        {
            if (candidateUsernames == null || candidateUsernames.Count == 0)
            {
                return BadRequest(new { message = "Candidate usernames are required." });
            }

            try
            {
                // Use the production or development API URL based on the environment
                var atsUrl = _ProductionAPI; // Or _DevelopmentAPI, based on your environment settings

                // Process candidates using the maxConcurrency from appsettings.json
                await _candidateProcessor.ProcessCandidates(candidateUsernames, atsUrl);

                return Ok(new { message = "Candidates are being processed." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = "An error occurred while processing candidates.", details = ex.Message });
            }
        }
        [HttpPost("ProcessBatchDevelopment")]
        public async Task<IActionResult> ProcessBatch(List<string> candidateUsernames)
        {
            if (candidateUsernames == null || candidateUsernames.Count == 0)
            {
                return BadRequest(new { message = "Candidate usernames are required." });
            }

            try
            {
                // Use the production or development API URL based on the environment
                var atsUrl = _DevelopmentAPI; // Or _DevelopmentAPI, based on your environment settings

                // Process candidates using the maxConcurrency from appsettings.json
                await _candidateProcessor.ProcessCandidates(candidateUsernames, atsUrl);

                return Ok(new { message = "Candidates are being processed." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = "An error occurred while processing candidates.", details = ex.Message });
            }
        }
    }
}
