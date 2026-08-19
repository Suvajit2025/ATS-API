using ATS.API.Interface;
using CommonUtility.Interface;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Data;

namespace ATS.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RecruitmentDashboardController : ControllerBase
    {
        private readonly IDataService _dataService;
        private readonly IATSHelper _helper;
        private readonly string _connectionString;
        private readonly string _gptApi;

        public RecruitmentDashboardController(
            IDataService dataService,
            IATSHelper helper,
            IConfiguration configuration)
        {
            _dataService = dataService;
            _helper = helper;
            _connectionString = configuration.GetConnectionString("DBConnRecruitment");
            _gptApi = configuration["GptAPI"];
        }

        [HttpGet("summary")]
        public async Task<IActionResult> GetDashboardSummary([FromQuery] RecruitmentDashboardFilter filter)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_SUMMARY", BuildFilterParameters(filter));
        }

        [HttpGet("pipeline")]
        public async Task<IActionResult> GetHiringPipeline([FromQuery] RecruitmentDashboardFilter filter)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_PIPELINE", BuildFilterParameters(filter));
        }

        [HttpGet("candidates")]
        public async Task<IActionResult> GetCandidates([FromQuery] RecruitmentCandidateFilter filter)
        {
            var parameters = BuildFilterParameters(filter);
            parameters["@KEYWORD"] = filter.Keyword ?? string.Empty;
            parameters["@STATUS"] = filter.Status ?? string.Empty;
            parameters["@TAKE"] = filter.Take <= 0 ? 500 : filter.Take;

            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_CANDIDATES", parameters);
        }

        [HttpGet("candidate/{candidateId:int}")]
        public async Task<IActionResult> GetCandidate(int candidateId)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_CANDIDATE_360", CandidateIdParameters(candidateId));
        }

        [HttpGet("candidate/{candidateId:int}/ats")]
        public async Task<IActionResult> GetCandidateATS(int candidateId)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_CANDIDATE_ATS", CandidateIdParameters(candidateId));
        }

        [HttpGet("candidate/{candidateId:int}/interviews")]
        public async Task<IActionResult> GetCandidateInterviews(int candidateId)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_CANDIDATE_INTERVIEWS", CandidateIdParameters(candidateId));
        }

        [HttpGet("candidate/{candidateId:int}/tests")]
        public async Task<IActionResult> GetCandidateTests(int candidateId)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_CANDIDATE_TESTS", CandidateIdParameters(candidateId));
        }

        [HttpGet("candidate/{candidateId:int}/psychometric")]
        public async Task<IActionResult> GetCandidatePsychometric(int candidateId)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_CANDIDATE_PSYCHOMETRIC", CandidateIdParameters(candidateId));
        }

        [HttpGet("candidate/{candidateId:int}/documents")]
        public async Task<IActionResult> GetCandidateDocuments(int candidateId)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_CANDIDATE_DOCUMENTS", CandidateIdParameters(candidateId));
        }

        [HttpGet("candidate/{candidateId:int}/timeline")]
        public async Task<IActionResult> GetCandidateTimeline(int candidateId)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_CANDIDATE_TIMELINE", CandidateIdParameters(candidateId));
        }

        [HttpGet("candidate/{candidateId:int}/decision-summary")]
        public async Task<IActionResult> GetDecisionSummary(int candidateId)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_DECISION_SUMMARY", CandidateIdParameters(candidateId));
        }

        [HttpGet("md/decision-queue")]
        public async Task<IActionResult> GetMDDecisionQueue([FromQuery] RecruitmentDashboardFilter filter)
        {
            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_MD_DECISION_QUEUE", BuildFilterParameters(filter));
        }

        [HttpPost("candidate/{candidateId:int}/md-decision")]
        public async Task<IActionResult> SaveMDDecision(int candidateId, [FromBody] MDDecisionRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Decision))
                return BadRequest(new { Success = false, Message = "Decision is required." });

            var parameters = CandidateIdParameters(candidateId);
            parameters["@DECISION"] = request.Decision;
            parameters["@REMARKS"] = request.Remarks ?? string.Empty;
            parameters["@DECIDED_BY"] = request.DecidedBy ?? string.Empty;

            return await ExecuteCommandAsync("PRC_RECRUITMENT_DASHBOARD_SAVE_MD_DECISION", parameters);
        }

        [HttpGet("archive")]
        public async Task<IActionResult> GetArchivedCandidates([FromQuery] RecruitmentArchiveFilter filter)
        {
            var parameters = BuildFilterParameters(filter);
            parameters["@OLDER_THAN_MONTHS"] = filter.OlderThanMonths <= 0 ? 6 : filter.OlderThanMonths;
            parameters["@TAKE"] = filter.Take <= 0 ? 500 : filter.Take;

            return await ExecuteDataAsync("PRC_RECRUITMENT_DASHBOARD_ARCHIVE", parameters);
        }

        [HttpPost("agent/query")]
        public async Task<IActionResult> RecruitmentAgentQuery([FromBody] RecruitmentAgentQueryRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Question))
                return BadRequest(new { Success = false, Message = "Question is required." });

            var parameters = new Dictionary<string, object>
            {
                { "@QUESTION", request.Question },
                { "@CONTEXT_JSON", request.ContextJson ?? string.Empty }
            };

            DataTable context = await _dataService.GetDataAsync("PRC_RECRUITMENT_DASHBOARD_AGENT_CONTEXT", parameters, _connectionString);
            string prompt = BuildAgentPrompt(request.Question, ToRows(context));
            string response = await _helper.SendMessageAsync(prompt, ResolveGptApi(request.GptApiUrl));

            return Ok(new { Success = true, Question = request.Question, Response = response });
        }

        [HttpGet("agent/candidate/{candidateId:int}/analysis")]
        public async Task<IActionResult> GetAICandidateAnalysis(int candidateId, [FromQuery] string? gptApiUrl)
        {
            DataTable context = await _dataService.GetDataAsync(
                "PRC_RECRUITMENT_DASHBOARD_AGENT_CANDIDATE_ANALYSIS_CONTEXT",
                CandidateIdParameters(candidateId),
                _connectionString);

            string prompt = BuildCandidateAnalysisPrompt(candidateId, ToRows(context));
            string response = await _helper.SendMessageAsync(prompt, ResolveGptApi(gptApiUrl));

            return Ok(new { Success = true, CandidateId = candidateId, Analysis = response });
        }

        [HttpPost("agent/compare")]
        public async Task<IActionResult> CompareCandidates([FromBody] CompareCandidatesRequest request)
        {
            if (request?.CandidateIds == null || request.CandidateIds.Count == 0)
                return BadRequest(new { Success = false, Message = "At least one candidateId is required." });

            var parameters = new Dictionary<string, object>
            {
                { "@CANDIDATE_IDS", string.Join(",", request.CandidateIds.Distinct()) },
                { "@JOB_POST_ID", request.JobPostId ?? 0 }
            };

            DataTable context = await _dataService.GetDataAsync("PRC_RECRUITMENT_DASHBOARD_AGENT_COMPARE_CONTEXT", parameters, _connectionString);
            string prompt = BuildComparePrompt(ToRows(context));
            string response = await _helper.SendMessageAsync(prompt, ResolveGptApi(request.GptApiUrl));

            return Ok(new { Success = true, CandidateIds = request.CandidateIds, Comparison = response });
        }

        private async Task<IActionResult> ExecuteDataAsync(string procedureName, Dictionary<string, object> parameters)
        {
            try
            {
                DataTable dt = await _dataService.GetDataAsync(procedureName, parameters, _connectionString);
                return Ok(new { Success = true, Data = ToRows(dt) });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Success = false, Message = ex.Message, Procedure = procedureName });
            }
        }

        private async Task<IActionResult> ExecuteCommandAsync(string procedureName, Dictionary<string, object> parameters)
        {
            try
            {
                int result = await _dataService.AddAsync(procedureName, parameters, _connectionString);
                return Ok(new { Success = true, Result = result });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Success = false, Message = ex.Message, Procedure = procedureName });
            }
        }

        private static Dictionary<string, object> CandidateIdParameters(int candidateId)
        {
            return new Dictionary<string, object> { { "@CANDIDATE_ID", candidateId } };
        }

        private static Dictionary<string, object> BuildFilterParameters(RecruitmentDashboardFilter filter)
        {
            return new Dictionary<string, object>
            {
                { "@COMPANY_ID", filter.CompanyId ?? 0 },
                { "@DEPARTMENT_ID", filter.DepartmentId ?? 0 },
                { "@POST_ID", filter.PostId ?? 0 },
                { "@FROM_DATE", filter.FromDate ?? (object)DBNull.Value },
                { "@TO_DATE", filter.ToDate ?? (object)DBNull.Value }
            };
        }

        private static List<Dictionary<string, object?>> ToRows(DataTable dt)
        {
            var rows = new List<Dictionary<string, object?>>();

            if (dt == null)
                return rows;

            foreach (DataRow row in dt.Rows)
            {
                var item = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase);
                foreach (DataColumn column in dt.Columns)
                {
                    object? value = row[column];
                    item[column.ColumnName] = value == DBNull.Value ? null : value;
                }

                rows.Add(item);
            }

            return rows;
        }

        private string ResolveGptApi(string? overrideUrl)
        {
            return string.IsNullOrWhiteSpace(overrideUrl) ? _gptApi : overrideUrl;
        }

        private static string BuildAgentPrompt(string question, List<Dictionary<string, object?>> context)
        {
            return $@"
You are a recruitment dashboard assistant. Answer using only the supplied dashboard context.
If the answer is not present, say what data is missing. Keep it concise.

QUESTION
{question}

CONTEXT_JSON
{JsonConvert.SerializeObject(context)}
".Trim();
        }

        private static string BuildCandidateAnalysisPrompt(int candidateId, List<Dictionary<string, object?>> context)
        {
            return $@"
You are an HR candidate-360 analyst. Analyze candidate {candidateId} using only the supplied context.
Cover ATS, interviews, tests, psychometric data, risks, strengths, and final recommendation when present.
Return concise JSON with summary, strengths, risks, missing_data, recommendation.

CONTEXT_JSON
{JsonConvert.SerializeObject(context)}
".Trim();
        }

        private static string BuildComparePrompt(List<Dictionary<string, object?>> context)
        {
            return $@"
Compare candidates using only the supplied recruitment context.
Return concise JSON with ranking, candidate_summaries, strengths, risks, and recommendation.

CONTEXT_JSON
{JsonConvert.SerializeObject(context)}
".Trim();
        }
    }

    public class RecruitmentDashboardFilter
    {
        public int? CompanyId { get; set; }
        public int? DepartmentId { get; set; }
        public int? PostId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
    }

    public class RecruitmentCandidateFilter : RecruitmentDashboardFilter
    {
        public string? Keyword { get; set; }
        public string? Status { get; set; }
        public int Take { get; set; } = 500;
    }

    public class RecruitmentArchiveFilter : RecruitmentDashboardFilter
    {
        public int OlderThanMonths { get; set; } = 6;
        public int Take { get; set; } = 500;
    }

    public class MDDecisionRequest
    {
        public string Decision { get; set; }
        public string? Remarks { get; set; }
        public string? DecidedBy { get; set; }
    }

    public class RecruitmentAgentQueryRequest
    {
        public string Question { get; set; }
        public string? ContextJson { get; set; }
        public string? GptApiUrl { get; set; }
    }

    public class CompareCandidatesRequest
    {
        public List<int> CandidateIds { get; set; } = new List<int>();
        public int? JobPostId { get; set; }
        public string? GptApiUrl { get; set; }
    }
}
