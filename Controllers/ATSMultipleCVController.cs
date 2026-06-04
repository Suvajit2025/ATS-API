using ATS.API.Interface;
using ATS.API.Models;
using CommonUtility.Interface;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Text.RegularExpressions;

namespace ATS.API.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ATSMultipleCVController : ControllerBase
    {
        private readonly IDataService _dataService;
        private readonly IATSHelper _helper;
        private readonly string _connectionString;
        private readonly string _gptApi;
        private readonly string _tempDirectory = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "TempFiles", "ATSMultipleCV");
        private const long MaxGptExtractionFileBytes = 4 * 1024 * 1024;

        public ATSMultipleCVController(IDataService dataService, IATSHelper helper, IConfiguration configuration)
        {
            _dataService = dataService;
            _helper = helper;
            _connectionString = configuration.GetConnectionString("DBConnRecruitment") ?? string.Empty;
            _gptApi = configuration["GptAPI"] ?? string.Empty;

            if (!Directory.Exists(_tempDirectory))
            {
                Directory.CreateDirectory(_tempDirectory);
            }
        }

        [HttpPost("UploadAndProcess")]
        public async Task<IActionResult> UploadAndProcess([FromForm] int postId, [FromForm] List<IFormFile> files)
        {
            if (postId <= 0)
            {
                return BadRequest(new { message = "Post id is required." });
            }

            if (files == null || files.Count == 0)
            {
                return BadRequest(new { message = "Please upload at least one CV." });
            }

            var results = new List<BatchCvProcessResult>();

            foreach (IFormFile file in files)
            {
                if (file == null || file.Length == 0)
                {
                    results.Add(new BatchCvProcessResult
                    {
                        FileName = file?.FileName ?? string.Empty,
                        Success = false,
                        Message = "File is empty."
                    });
                    continue;
                }

                string filePath = string.Empty;

                try
                {
                    filePath = await SaveFileAsync(file);
                    string resumeText = await _helper.ExtractTextAsync(filePath);
                    bool usedGptExtraction = false;

                    if (HasExtractionFailed(resumeText))
                    {
                        resumeText = await ExtractResumeTextWithGptAsync(filePath, file.FileName, resumeText);
                        usedGptExtraction = true;

                        if (HasExtractionFailed(resumeText))
                        {
                            results.Add(new BatchCvProcessResult
                            {
                                FileName = file.FileName,
                                Success = false,
                                Message = string.IsNullOrWhiteSpace(resumeText)
                                    ? "No text extracted from CV using normal extraction or GPT fallback."
                                    : resumeText
                            });
                            continue;
                        }
                    }

                    string jobDescription = await GetJobDescriptionByPostIdAsync(postId);
                    AtsPromptResult promptResult = await GeneratePromptFromPostAsync(postId, jobDescription, resumeText);

                    if (string.IsNullOrWhiteSpace(promptResult.Prompt) || promptResult.Prompt.Contains("\"error\""))
                    {
                        results.Add(new BatchCvProcessResult
                        {
                            FileName = file.FileName,
                            Success = false,
                            Message = "Unable to generate ATS prompt.",
                            Prompt = promptResult.Prompt
                        });
                        continue;
                    }

                    string gptResponse = await _helper.SendMessageAsync(promptResult.Prompt, _gptApi);
                    ResumeScore resumeScore = await SaveAtsResponseToDb(gptResponse, postId, file.FileName, promptResult.TotalScore, promptResult.BreakDownArray);

                    results.Add(new BatchCvProcessResult
                    {
                        FileName = file.FileName,
                        Success = true,
                        MatchScore = resumeScore.MatchScore,
                        Message = usedGptExtraction
                            ? "ATS score processed successfully using GPT CV extraction fallback."
                            : "ATS score processed successfully."
                    });
                }
                catch (Exception ex)
                {
                    results.Add(new BatchCvProcessResult
                    {
                        FileName = file.FileName,
                        Success = false,
                        Message = ex.Message
                    });
                }
                finally
                {
                    if (!string.IsNullOrWhiteSpace(filePath) && System.IO.File.Exists(filePath))
                    {
                        try
                        {
                            System.IO.File.Delete(filePath);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"Error deleting file {filePath}: {ex.Message}");
                        }
                    }
                }
            }

            return Ok(new
            {
                postId,
                totalFiles = files.Count,
                processed = results.Count(r => r.Success),
                results
            });
        }

        private async Task<string> SaveFileAsync(IFormFile file)
        {
            string safeFileName = SanitizeFileName(file.FileName);
            string filePath = System.IO.Path.Combine(_tempDirectory, $"{Guid.NewGuid()}_{safeFileName}");

            using FileStream stream = new FileStream(filePath, FileMode.Create);
            await file.CopyToAsync(stream);

            return filePath;
        }

        private async Task<string> ExtractResumeTextWithGptAsync(string filePath, string fileName, string extractionError)
        {
            if (string.IsNullOrWhiteSpace(_gptApi))
            {
                return "[Error extracting CV with GPT: GptAPI is not configured.]";
            }

            FileInfo fileInfo = new FileInfo(filePath);

            if (!fileInfo.Exists)
            {
                return "[Error extracting CV with GPT: uploaded file was not found.]";
            }

            if (fileInfo.Length > MaxGptExtractionFileBytes)
            {
                return $"[Error extracting CV with GPT: file is too large. Maximum allowed for GPT fallback is {MaxGptExtractionFileBytes / 1024 / 1024} MB.]";
            }

            byte[] fileBytes = await System.IO.File.ReadAllBytesAsync(filePath);
            string base64File = Convert.ToBase64String(fileBytes);
            string extension = System.IO.Path.GetExtension(fileName).ToLowerInvariant();
            string contentType = GetContentType(extension);

            string prompt = $@"
                You are a CV/resume extraction engine.

                Normal server-side extraction failed with:
                {extractionError}

                The uploaded CV file is provided below as Base64.
                FileName: {fileName}
                ContentType: {contentType}

                Task:
                - Read/decode the CV content if your API/model supports file or Base64 document understanding.
                - Extract all available resume text and candidate information.
                - Return plain text only.
                - Do not add markdown.
                - Do not invent missing information.
                - If you cannot read this file, return exactly:
                [Error extracting CV with GPT: unable to read uploaded CV content.]

                Base64 CV:
                {base64File}
                ".Trim();

            string gptResponse = await _helper.SendMessageAsync(prompt, _gptApi);

            if (string.IsNullOrWhiteSpace(gptResponse))
            {
                return "[Error extracting CV with GPT: empty response.]";
            }

            return gptResponse.Trim();
        }

        private async Task<string> GetJobDescriptionByPostIdAsync(int postId)
        {
            DataTable dt = await GetDataWithFallbackAsync("SP_ATS_JOBDESCRIPTION", postId, "@PostId", "@POST_ID", "@ActualPostID", "@CandidateId");

            if (dt.Rows.Count == 0 || dt.Rows[0]["JobDescription"] == DBNull.Value)
            {
                throw new Exception("No job description found for the given post id.");
            }

            string profileJson = dt.Rows[0]["JobDescription"]?.ToString() ?? string.Empty;

            if (string.IsNullOrWhiteSpace(profileJson))
            {
                throw new Exception("Job description is empty for the given post id.");
            }

            JToken jobProfileToken = JToken.Parse(profileJson);
            JObject jobProfile = jobProfileToken is JArray array
                ? array.FirstOrDefault() as JObject
                : jobProfileToken as JObject;

            if (jobProfile == null)
            {
                return profileJson;
            }

            string title = jobProfile["JobTitle"]?.ToString() ?? "";
            string location = jobProfile["Location"]?.ToString() ?? "";
            string experience = jobProfile["Experience"]?.ToString() ?? "";
            string qualifications = jobProfile["Qualifications"]?.ToString() ?? "";
            string skills = $"{jobProfile["RequiredSkill"]?.ToString()} {jobProfile["TechnicalScope"]?.ToString()} {jobProfile["Skills"]?.ToString()}";
            skills = Regex.Replace(skills, @"\s+", " ").Trim();
            string others = jobProfile["Others"]?.ToString() ?? "";
            string responsibilities = jobProfile["JobResponsibility"]?.ToString() ?? jobProfile["Jobresponsibility"]?.ToString() ?? "";
            string topResponsibilities = string.Join("; ", Regex.Split(responsibilities, "•").Where(r => !string.IsNullOrWhiteSpace(r)).Take(3)).Trim();

            var compressed = new
            {
                JobTitle = title,
                Location = location,
                Experience = experience,
                Qualifications = qualifications,
                Skills = skills,
                KeyResponsibilities = topResponsibilities,
                JD_Summary = $"We are hiring {title} in {location} with {experience}. Must have skills: {skills}. Responsibilities: {topResponsibilities}. Other Informations: {others}."
            };

            return JsonConvert.SerializeObject(compressed);
        }

        private async Task<AtsPromptResult> GeneratePromptFromPostAsync(int postId, string jobText, string resumeText)
        {
            DataTable dt = await GetDataWithFallbackAsync("SP_ATS_PROMT", postId, "@PostId", "@POST_ID", "@ActualPostID", "@CandidateId");

            if (dt.Rows.Count == 0 || dt.Rows[0]["AtsPrompt"] == DBNull.Value)
            {
                throw new Exception("No ATS prompt configuration found for the given post id.");
            }

            string profileJson = dt.Rows[0]["AtsPrompt"]?.ToString() ?? string.Empty;

            if (string.IsNullOrWhiteSpace(profileJson))
            {
                throw new Exception("ATS prompt configuration is empty for the given post id.");
            }

            JObject jObj = JObject.Parse(profileJson);
            decimal totalScore = jObj["Total Score"]?.Value<decimal>() ?? 100;
            var breakDownArray = JsonConvert.DeserializeObject<List<RatingItem>>(jObj["BreakDownScore"]?.ToString() ?? "[]") ?? new List<RatingItem>();
            var resultStatusArray = JsonConvert.DeserializeObject<List<ResultStatusItem>>(jObj["Result Status"]?.ToString() ?? "[]") ?? new List<ResultStatusItem>();

            string resultRules = string.Join(", ", resultStatusArray.Select(x => $"{x.Key}:{x.Value}"));
            string statusOptions = string.Join(", ", resultStatusArray.Select(x => $"\"{x.Key}\""));
            string keywordHints = string.Join("; ", breakDownArray
                .Where(x => x.Keywords != null && x.Keywords.Any())
                .Select(x => $"{x.Key}:{string.Join(",", x.Keywords)}"));

            string scoresSchema = string.Join(",\n    ", breakDownArray.Select(x =>
                $"\"{x.Key}\": {{ \"total\": {x.Value}, \"obtained\": number, \"id\": {x.Id}, \"notes\": string }}"));

            string prompt = $@"
You are an Applicant Tracking System (ATS) evaluator.
Use ONLY the explicit data supplied below. Do NOT infer or assume anything.

Total Score: {totalScore}
Result Rules: {resultRules}
Keywords (internal use only): {keywordHints}

Post Id:
{postId}

JD:
{jobText}

Resume:
{resumeText}

For each category, calculate an obtained score between 0 and the category's total using ONLY explicit evidence found in the Resume text.

Rules:
- Do NOT infer or assume missing information.
- obtained must be a number <= total.
- If no explicit evidence exists, obtained = 0.
- match_score MUST equal the sum of all obtained values.
- percentage = (match_score / {totalScore}) * 100.

Return JSON ONLY in the exact structure below:
{{
    ""match_score"": number,
    ""percentage"": number,
    ""remarks"": string,
    ""Status"": one of [{statusOptions}],
    ""scores"": {{
    {scoresSchema}
    }}
}}

temperature = 0.2
".Trim();

            return new AtsPromptResult
            {
                Prompt = prompt,
                TotalScore = totalScore,
                BreakDownArray = breakDownArray,
                ResultStatusArray = resultStatusArray
            };
        }

        private async Task<ResumeScore> SaveAtsResponseToDb(string rawJson, int postId, string fileName, decimal totalScoreFromPrompt, List<RatingItem> breakDownArrayFromPrompt)
        {
            string cleanedJson = rawJson
                .Replace("```json", "")
                .Replace("```", "")
                .Replace("json\r\n", "")
                .Replace("json\n", "")
                .Trim('`', ' ', '\r', '\n');

            JObject jObject = JObject.Parse(cleanedJson);

            int matchScore = jObject["match_score"]?.Value<int>() ?? 0;
            string remarks = jObject["remarks"]?.ToString() ?? "";
            string status = jObject["Status"]?.ToString() ?? "";
            JObject scoresToken = jObject["scores"] as JObject ?? throw new Exception("Invalid ATS response: scores missing.");

            var enrichedBreakdown = new Dictionary<string, object>();
            var detailsDict = new Dictionary<string, object>();

            foreach (RatingItem item in breakDownArrayFromPrompt)
            {
                string key = item.Key;
                decimal total = 0;
                decimal.TryParse(item.Value, out total);

                decimal obtained = scoresToken[key]?["obtained"]?.Value<decimal>() ?? 0;
                string notes = scoresToken[key]?["notes"]?.ToString() ?? "";
                int id = scoresToken[key]?["id"]?.Value<int>() ?? item.Id;

                enrichedBreakdown[key] = new
                {
                    Total = total,
                    Obtained = obtained
                };

                detailsDict[key] = new
                {
                    id,
                    notes
                };
            }

            var insertParams = new Dictionary<string, object>
            {
                { "@CANDIDATE_ID", 0 },
                { "@POST_ID", postId },
                { "@LOCATION_ID", 0 },
                { "@COMPANY_ID", 0 },
                { "@DEPARTMENT_ID", 0 },
                { "@TOTAL_SCORE", totalScoreFromPrompt },
                { "@OBTAINED_SCORE", matchScore },
                { "@REMARKS", $"{remarks} FileName: {fileName}" },
                { "@STATUS", status },
                { "@BREAKDOWN_JSON", JsonConvert.SerializeObject(enrichedBreakdown, Formatting.None) },
                { "@DETAILS_JSON", JsonConvert.SerializeObject(detailsDict, Formatting.None) }
            };

            await _dataService.AddAsync("SP_SAVE_ATS_SCORE", insertParams, _connectionString);

            return new ResumeScore
            {
                MatchScore = matchScore,
                Remarks = remarks,
                CreatedAt = DateTime.UtcNow
            };
        }

        private async Task<DataTable> GetDataWithFallbackAsync(string storedProcedure, int id, params string[] parameterNames)
        {
            Exception lastException = null;

            foreach (string parameterName in parameterNames)
            {
                try
                {
                    DataTable dt = await _dataService.GetDataAsync(
                        storedProcedure,
                        new Dictionary<string, object> { { parameterName, id } },
                        _connectionString
                    );

                    if (dt.Rows.Count > 0)
                    {
                        return dt;
                    }
                }
                catch (Exception ex)
                {
                    lastException = ex;
                }
            }

            if (lastException != null)
            {
                throw lastException;
            }

            return new DataTable();
        }

        private static string SanitizeFileName(string fileName)
        {
            string safeFileName = System.IO.Path.GetFileName(fileName);

            foreach (char invalidChar in System.IO.Path.GetInvalidFileNameChars())
            {
                safeFileName = safeFileName.Replace(invalidChar, '_');
            }

            return safeFileName;
        }

        private static bool HasExtractionFailed(string resumeText)
        {
            if (string.IsNullOrWhiteSpace(resumeText))
            {
                return true;
            }

            return resumeText.StartsWith("[Invalid", StringComparison.OrdinalIgnoreCase)
                || resumeText.StartsWith("[Unsupported", StringComparison.OrdinalIgnoreCase)
                || resumeText.StartsWith("[Error", StringComparison.OrdinalIgnoreCase);
        }

        private static string GetContentType(string extension)
        {
            return extension switch
            {
                ".pdf" => "application/pdf",
                ".doc" => "application/msword",
                ".docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                ".txt" => "text/plain",
                _ => "application/octet-stream"
            };
        }

        private class BatchCvProcessResult
        {
            public string FileName { get; set; } = string.Empty;
            public bool Success { get; set; }
            public int? MatchScore { get; set; }
            public string Message { get; set; } = string.Empty;
            public string Prompt { get; set; } = string.Empty;
        }
    }
}
