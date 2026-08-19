using ATS.API.Interface;
using ATS.API.Models;
using CommonUtility.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Text;
using System.Text.RegularExpressions;


namespace ATS.API.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ATSRecruitmentController : ControllerBase
    {
        private const int MaxJobTextChars = 3000;
        private const int MaxCandidateJsonChars = 2500;
        private const int MaxResumeTextChars = 6500;
        private const int MaxEvidenceSummaryChars = 2200;

        private readonly IBackgroundTaskQueue _backgroundTaskQueue;
        private readonly ICommonService _commonService;
        private readonly IDataService _dataService;
        private readonly string _ConnectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IATSHelper _helper;
        public string _ResumeSavePath;
        public string _GptAPI;
        public string _ResumeSaveDB;
        public ATSRecruitmentController(ICommonService commonService, IDataService dataService, IHttpContextAccessor httpContextAccessor, IConfiguration configuration, IATSHelper aTSHelper, IBackgroundTaskQueue backgroundTaskQueue)
        {
            _commonService = commonService;
            _dataService = dataService;
            _ConnectionString = configuration.GetConnectionString("DBConnRecruitmentDemo");
            _httpContextAccessor = httpContextAccessor;
            _helper = aTSHelper;
            _backgroundTaskQueue = backgroundTaskQueue;
            _GptAPI = configuration["GptAPI"];
            _ResumeSavePath = configuration["ResumeSettings:SavePathDemo"];
            _ResumeSaveDB = configuration["ResumeSettings:fileUrl"];
        }
        //[HttpPost("GenerateATSScore")]
        //public async Task<IActionResult> AtsScoreByID(string username)
        //{
        //    if (string.IsNullOrWhiteSpace(username))
        //        return BadRequest(new { message = "Username is required." });

        //    try
        //    {
        //        var parameters = new Dictionary<string, object> { { "@username", username } };
        //        DataTable dt = await _dataService.GetDataAsync("SP_ATS_GET_RESUME_BYID", parameters, _ConnectionString);

        //        if (dt.Rows.Count == 0)
        //            return NotFound(new { message = "No resume found for the given username." });

        //        DataRow row = dt.Rows[0];
        //        byte[] fileData = (byte[])row["resumefile"];
        //        string fileName = row["Name"].ToString();
        //        string contentType = row["ContentType"].ToString();
        //        int candidateId = (int)row["candidateid"];
        //        string CandidateName = row["Candidate_Name"].ToString();

        //        string fileExtension = contentType == "application/octet-stream"
        //            ? _helper.GetFileExtensionFromName(fileName)
        //            : _helper.GetExtensionFromContentType(contentType);

        //        string relativePath = _ResumeSavePath;
        //        string fileFolder = Path.Combine(Directory.GetCurrentDirectory(), relativePath);

        //        if (!Directory.Exists(fileFolder))
        //            Directory.CreateDirectory(fileFolder);

        //        //string tempFileName = $"Candidate_{candidateId}_{Guid.NewGuid()}{fileExtension}";

        //        string savedFileName = $"CV_{CandidateName}_{candidateId}{fileExtension}";

        //        string savedFilePath = Path.Combine(fileFolder, savedFileName);

        //        string fileUrl = _ResumeSaveDB + savedFileName;

        //        int SaveResume = await _dataService.AddAsync("SP_SAVE_RESUMEURL", new Dictionary<string, object>
        //        {
        //            { "@CandidateId", candidateId },
        //            { "@FileUrl", fileUrl },
        //        }, _ConnectionString);

        //        await System.IO.File.WriteAllBytesAsync(savedFilePath, fileData);

        //        await _backgroundTaskQueue.QueueBackgroundWorkItem(async token =>
        //        {
        //            try
        //            {
        //                await CandidateProfile(savedFilePath, candidateId);
        //            }
        //            finally
        //            {
        //                try { if (System.IO.File.Exists(savedFilePath)) System.IO.File.Delete(savedFilePath); }
        //                catch { }
        //            }
        //        });

        //        return Accepted(new { message = "Resume processing started." });
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode(500, new { error = ex.Message });
        //    }
        //}


        //private async Task CandidateProfile(string filePath, long candidateId)
        //{
        //    try
        //    {
        //        string resumeText = await _helper.ExtractTextAsync(filePath);


        //        string profileJson = string.Empty;

        //        var parameters = new Dictionary<string, object>
        //        {
        //            {"@CandidateId", (int)candidateId }
        //        };

        //        // Fetch data using GetDataAsync
        //        DataTable dt = await _dataService.GetDataAsync("SP_ATSCANDIDATEPROFILE", parameters, _ConnectionString);
        //        if (dt.Rows.Count > 0)
        //        {
        //            profileJson = dt.Rows[0]["StudentResume"].ToString();
        //        }

        //        // 🔹 Deserialize profileJson into dynamic object
        //        dynamic profile = JsonConvert.DeserializeObject(profileJson);

        //        // ✅ Trim the profile to reduce token size
        //        var trimmedProfile = new
        //        {
        //            ExperienceYears = profile.TotalExperience,
        //            NoticePeriodDays = profile.NoticePeriod,
        //            Languages = ((IEnumerable<dynamic>)profile.Languages ?? Enumerable.Empty<dynamic>())
        //                .Select(l => (string)l.LanguageName),
        //            Education = ((IEnumerable<dynamic>)profile.Education ?? Enumerable.Empty<dynamic>())
        //                .Reverse().Take(2).Select(e => new
        //                {
        //                    Degree = (string)e.DegreeName,
        //                    Year = $"{e.startingYear}–{e.yearmonthpassing}",
        //                    Institute = (string)e.institute,
        //                    Score = (string)e.marks
        //                }),
        //            Experience = ((IEnumerable<dynamic>)profile.Experience ?? Enumerable.Empty<dynamic>())
        //                .Take(2).Select(exp => new
        //                {
        //                    Company = (string)exp.employername,
        //                    Role = (string)exp.designation,
        //                    From = (string)exp.DurationFrom,
        //                    To = (string)exp.DurationTo
        //                })
        //        };

        //        // Combine resumeText and profileJson
        //        var combinedObject = new
        //        {
        //            ResumeText = resumeText,
        //            CandidateProfile = trimmedProfile //JsonConvert.DeserializeObject(profileJson)
        //        };

        //        string combinedJson = JsonConvert.SerializeObject(combinedObject);

        //        await CalculateAtsAndParseResumeInBackground((int)candidateId, combinedJson);
        //    }
        //    catch (Exception ex)
        //    {

        //    }

        //}
        //private async Task CalculateAtsAndParseResumeInBackground(int candidateId, string resumeText)
        //{
        //    try
        //    {



        //        string jobDescription = await GetJobDescriptionAsync(candidateId);

        //        //string promptTemplate = await GeneratePromptFromSpAsync(candidateId, jobDescription, resumeText);
        //        AtsPromptResult promptResult = await GeneratePromptFromSpAsync(candidateId, jobDescription, resumeText);

        //        var gptResponse = await _helper.SendMessageAsync(promptResult.Prompt, _GptAPI);


        //        if (!string.IsNullOrWhiteSpace(gptResponse))
        //        {
        //            var resumeScore = await SaveAtsResponseToDb(gptResponse, candidateId, promptResult.TotalScore, promptResult.BreakDownArray);
        //            Console.WriteLine("ATS Score calculated successfully.");
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine("Error calculating ATS Score: " + ex.Message);
        //    }
        //}

        //private async Task<string> GetJobDescriptionAsync(int candidateId)
        //{
        //    try
        //    {
        //        string profileJson = string.Empty;

        //        var parameters = new Dictionary<string, object>
        //        {
        //            { "@CandidateId", candidateId }
        //        };

        //        // Fetch data from the stored procedure
        //        DataTable dt = await _dataService.GetDataAsync("SP_ATS_JOBDESCRIPTION", parameters, _ConnectionString);
        //        if (dt.Rows.Count > 0)
        //        {
        //            profileJson = dt.Rows[0]["JobDescription"].ToString();
        //        }

        //        if (string.IsNullOrWhiteSpace(profileJson))
        //            return JsonConvert.SerializeObject(new { error = "No job profile data found." });

        //        var jobProfileArray = JsonConvert.DeserializeObject<JArray>(profileJson);
        //        var jobProfile = jobProfileArray.FirstOrDefault() as JObject;

        //        if (jobProfile == null)
        //            return JsonConvert.SerializeObject(new { error = "Job profile format is invalid." });

        //        // Extract and simplify fields
        //        string title = jobProfile["JobTitle"]?.ToString() ?? "";
        //        string location = jobProfile["Location"]?.ToString() ?? "";
        //        string experience = jobProfile["Experience"]?.ToString() ?? "";
        //        string qualifications = jobProfile["Qualifications"]?.ToString() ?? "";

        //        // Merge RequiredSkill + TechnicalScope and compress
        //        string skills = $"{jobProfile["RequiredSkill"]?.ToString()} {jobProfile["TechnicalScope"]?.ToString()}";
        //        skills = Regex.Replace(skills, @"\s+", " ").Trim(); // remove line breaks and extra space
        //        string others = jobProfile["Others"]?.ToString() ?? "";
        //        // Shorten responsibilities to top 2–3 points (if possible)
        //        string responsibilities = jobProfile["JobResponsibility"]?.ToString() ?? "";
        //        var responsibilityItems = Regex.Split(responsibilities, "•").Where(r => !string.IsNullOrWhiteSpace(r)).Take(3);
        //        string topResponsibilities = string.Join("; ", responsibilityItems).Trim();

        //        // Final compressed object
        //        var compressed = new
        //        {
        //            JobTitle = title,
        //            Location = location,
        //            Experience = experience,
        //            Qualifications = qualifications,
        //            Skills = skills,
        //            KeyResponsibilities = topResponsibilities,
        //            JD_Summary = $"We are hiring {title} in {location} with {experience}. Must have skills: {skills}. Responsibilities: {topResponsibilities}.Other Informations: {others}."
        //        };

        //        // Serialize the final job description to JSON and return
        //        string jobDescription = JsonConvert.SerializeObject(compressed);

        //        return jobDescription;
        //    }
        //    catch (Exception ex)
        //    {
        //        return JsonConvert.SerializeObject(new
        //        {
        //            error = "An error occurred while generating job description.",
        //            details = ex.Message
        //        });
        //    }
        //}



        //private async Task<AtsPromptResult> GeneratePromptFromSpAsync(int candidateId, string jobText, string resumeText)
        //{
        //    var result = new AtsPromptResult();

        //    try
        //    {
        //        string profileJson = string.Empty;

        //        var parameters = new Dictionary<string, object>
        //        {
        //            {"@CandidateId", candidateId }
        //        };

        //        DataTable dt = await _dataService.GetDataAsync("SP_ATS_PROMT", parameters, _ConnectionString);

        //        if (dt.Rows.Count > 0)
        //        {
        //            profileJson = dt.Rows[0]["AtsPrompt"]?.ToString();
        //        }

        //        if (string.IsNullOrWhiteSpace(profileJson))
        //        {
        //            result.Prompt = JsonConvert.SerializeObject(new { error = "No data returned from stored procedure." });
        //            return result;
        //        }

        //        var jObj = JObject.Parse(profileJson);

        //        decimal totalScore = jObj["Total Score"]?.Value<decimal>() ?? 100;
        //        string breakDownRaw = jObj["BreakDownScore"]?.ToString();
        //        string resultStatusRaw = jObj["Result Status"]?.ToString();

        //        var breakDownArray = JsonConvert.DeserializeObject<List<RatingItem>>(breakDownRaw);
        //        var resultStatusArray = JsonConvert.DeserializeObject<List<ResultStatusItem>>(resultStatusRaw);

        //        var breakdown = string.Join(",\n    ",
        //            breakDownArray.Select(x => $"\"{x.Key}\": {x.Value}"));

        //        var details = string.Join(",\n    ",
        //            breakDownArray.Select(x => $"\"{x.Key}\": {{ \"id\": {x.Id}, \"notes\": \"Give a clear and Proper explanation why the candidate got this score based on {x.Key},avoiding overly optimistic or pessimistic scoring. \" }}"));

        //        string statusInfo = string.Join(", ", resultStatusArray.Select(x => $"{x.Key} ({x.Value})"));
        //        string resultStatusJson = string.Join(",\n    ", resultStatusArray.Select(x => $"\"{x.Key}\": \"{x.Value}\""));


        //        string prompt = $@"
        //            You are an Applicant Tracking System (ATS) evaluator.

        //            You are trained using the following scoring configuration:
        //            {{
        //              ""TotalScore"": {totalScore},
        //              ""BreakDownScore"": {{
        //                {breakdown}
        //              }},
        //              ""ResultStatus"": {{
        //                {resultStatusJson} 
        //              }}
        //            }} 
        //            Compare the given Job Description and Resume, and perform the following:
        //            1. match_score is sum of breakdown scores.
        //            2. Score each category based on relevance.
        //            3. Calculate total score out of {totalScore} and sum of breakdown scores.
        //               Then compute the percentage using the formula:
        //               Percentage = (Total Score / Sum of Breakdown Scores) × 100.
        //            4. Based on the score, classify the result using the ResultStatus rules.
        //            5. Return the response in JSON format using this schema:

        //            {{
        //              ""match_score"": number,
        //              ""percentage"": number,
        //              ""remarks"": ""short summary of overall match/mismatch explanation"",
        //              ""Status"": ""One of: {statusInfo}"",
        //              ""breakdown"": {{
        //                {breakdown}
        //              }},
        //              ""details"": {{
        //                {details}
        //              }}
        //            }}

        //            DO NOT include any extra text, markdown, or comments. Only return the JSON object.

        //            Job Description: {jobText}

        //            Resume: {resumeText}

        //            temperature = 0.2
        //        ".Trim();
        //        // Set the result
        //        result.Prompt = prompt;
        //        result.TotalScore = totalScore;
        //        result.BreakDownArray = breakDownArray;
        //        result.ResultStatusArray = resultStatusArray;

        //        return result;
        //    }
        //    catch (Exception ex)
        //    {
        //        result.Prompt = JsonConvert.SerializeObject(new
        //        {
        //            error = "An error occurred while generating Prompt For ATS.",
        //            details = ex.Message
        //        });

        //        return result;
        //    }
        //}

        //private async Task<ResumeScore> SaveAtsResponseToDb(string rawJson, int candidateId, decimal totalScoreFromPrompt, List<RatingItem> breakDownArrayFromPrompt)
        //{
        //    string cleanedJson = rawJson
        //        .Replace("```json", "")
        //        .Replace("```", "")
        //        .Replace("json\r\n", "")
        //        .Replace("json\n", "")
        //        .Trim('`', ' ', '\r', '\n');

        //    var jObject = JObject.Parse(cleanedJson);

        //    int matchScore = jObject["match_score"]?.Value<int>() ?? 0;
        //    string remarks = jObject["remarks"]?.ToString() ?? "";
        //    string status = jObject["Status"]?.ToString() ?? "";

        //    string detailsJson = jObject["details"]?.ToString(Newtonsoft.Json.Formatting.None) ?? "{}";

        //    // Step 1: Parse obtained breakdown from GPT
        //    var obtainedDict = JsonConvert.DeserializeObject<Dictionary<string, decimal>>(
        //        jObject["breakdown"]?.ToString() ?? "{}"
        //    );

        //    // Step 2: Merge with total config to build enriched breakdown
        //    decimal obtainedScore = 0;
        //    var enrichedBreakdown = new Dictionary<string, object>();

        //    foreach (var item in breakDownArrayFromPrompt)
        //    {
        //        string key = item.Key;
        //        decimal total = 0;
        //        decimal.TryParse(item.Value?.ToString(), out total);

        //        decimal obtained = obtainedDict.ContainsKey(key) ? obtainedDict[key] : 0;
        //        obtainedScore += obtained;

        //        enrichedBreakdown[key] = new Dictionary<string, object>
        //        {
        //            { "Total", total },
        //            { "Obtained", obtained }
        //        };
        //    }

        //    //enrichedBreakdown["TotalScore"] = totalScoreFromPrompt;
        //    //enrichedBreakdown["ObtainedScore"] = obtainedScore;

        //    string breakdownJson = JsonConvert.SerializeObject(enrichedBreakdown, Formatting.None);

        //    // Prepare resume score object
        //    var resumeScore = new ResumeScore
        //    {
        //        MatchScore = matchScore,
        //        CreatedAt = DateTime.UtcNow
        //    };

        //    int postId = 0, locId = 0, companyId = 0, departmentId = 0;

        //    var parameters = new Dictionary<string, object>
        //    {
        //        { "@CandidateId", candidateId }
        //    };

        //    DataTable dt = await _dataService.GetDataAsync("SP_ATS_GETCANDIDATEDETAILS", parameters, _ConnectionString);
        //    if (dt.Rows.Count > 0)
        //    {
        //        try
        //        {
        //            postId = Convert.ToInt32(dt.Rows[0]["ActualPostID"]);
        //            locId = Convert.ToInt32(dt.Rows[0]["locId"]);
        //            companyId = Convert.ToInt32(dt.Rows[0]["companyId"]);
        //            departmentId = Convert.ToInt32(dt.Rows[0]["Departmentid"]);
        //        }
        //        catch { }
        //    }

        //    var InsertParameters = new Dictionary<string, object>
        //    {
        //        { "@CANDIDATE_ID", candidateId },
        //        { "@POST_ID", postId },
        //        { "@LOCATION_ID", locId },
        //        { "@COMPANY_ID", companyId },
        //        { "@DEPARTMENT_ID", departmentId },
        //        { "@TOTAL_SCORE", totalScoreFromPrompt },              // from prompt
        //        { "@REMARKS", remarks },
        //        { "@STATUS", status },
        //        { "@BREAKDOWN_JSON", breakdownJson },
        //        { "@DETAILS_JSON", detailsJson },
        //        { "@OBTAINED_SCORE", obtainedScore }                  // calculated
        //    };

        //    try
        //    {
        //        int result = await _dataService.AddAsync("SP_SAVE_ATS_SCORE", InsertParameters, _ConnectionString);
        //    }
        //    catch (Exception ex)
        //    {
        //        // Optionally log exception
        //    }

        //    return resumeScore;
        //}
        [HttpPost("GenerateATSScore")]
        public async Task<IActionResult> AtsScoreByID([FromQuery] string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return BadRequest(new { message = "Username is required." });

            try
            {
                var parameters = new Dictionary<string, object> { { "@username", username } };
                DataTable dt = await _dataService.GetDataAsync("SP_ATS_GET_RESUME_BYID", parameters, _ConnectionString);

                if (dt.Rows.Count == 0)
                    return NotFound(new { message = "No resume found for the given username." });

                DataRow row = dt.Rows[0];
                byte[] fileData = (byte[])row["resumefile"];
                string fileName = row["Name"].ToString();
                string contentType = row["ContentType"].ToString();
                int candidateId = (int)row["candidateid"];
                string CandidateName = row["Candidate_Name"].ToString();

                string fileExtension = contentType == "application/octet-stream"
                    ? _helper.GetFileExtensionFromName(fileName)
                    : _helper.GetExtensionFromContentType(contentType);

                string relativePath = _ResumeSavePath;
                string fileFolder = Path.Combine(Directory.GetCurrentDirectory(), relativePath);

                if (!Directory.Exists(fileFolder))
                    Directory.CreateDirectory(fileFolder);

                //string tempFileName = $"Candidate_{candidateId}_{Guid.NewGuid()}{fileExtension}";

                string savedFileName = $"CV_{CandidateName}_{candidateId}{fileExtension}";

                string savedFilePath = Path.Combine(fileFolder, savedFileName);

                string fileUrl = savedFileName;

                int SaveResume = await _dataService.AddAsync("SP_SAVE_RESUMEURL", new Dictionary<string, object>
                {
                    { "@CandidateId", candidateId },
                    { "@FileUrl", fileUrl },
                }, _ConnectionString);


                await System.IO.File.WriteAllBytesAsync(savedFilePath, fileData);

                await _backgroundTaskQueue.QueueBackgroundWorkItem(async token =>
                {
                    try
                    {
                        await CandidateProfile(savedFilePath, candidateId);
                    }
                    catch (Exception ex)
                    {
                        // Optional: log the error
                        Console.WriteLine($"Error in background task for candidateId {candidateId}: {ex.Message}");
                    }
                });


                return Accepted(new { message = "Resume processing started." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }
        private async Task CandidateProfile(string filePath, long candidateId)
        {
            try
            {
                // Extract text from resume
                string resumeText = await _helper.ExtractTextAsync(filePath);

                // Initialize profileJson variable
                string profileJson = string.Empty;

                var parameters = new Dictionary<string, object>
                {
                    {"@CandidateId", (int)candidateId }
                };

                // Fetch data using GetDataAsync (get the profile from DB)
                DataTable dt = await _dataService.GetDataAsync("SP_ATSCANDIDATEPROFILE", parameters, _ConnectionString);
                if (dt.Rows.Count > 0)
                {
                    profileJson = dt.Rows[0]["StudentResume"].ToString();
                }

                // Deserialize the profile JSON into a dynamic object
                dynamic profile = JsonConvert.DeserializeObject(profileJson);

                // Trim the profile to reduce token size (focusing on important data)
                var trimmedProfile = new
                {
                    ExperienceYears = profile.TotalExperience,
                    NoticePeriodDays = profile.NoticePeriod,
                    Languages = ((IEnumerable<dynamic>)profile.Languages ?? Enumerable.Empty<dynamic>())
                        .Select(l => (string)l.LanguageName),
                    Education = ((IEnumerable<dynamic>)profile.Education ?? Enumerable.Empty<dynamic>())
                        .Reverse().Take(2).Select(e => new
                        {
                            Degree = (string)e.DegreeName,
                            Year = $"{e.startingYear}–{e.yearmonthpassing}",
                            Institute = (string)e.institute,
                            Score = (string)e.marks
                        }),
                    Experience = ((IEnumerable<dynamic>)profile.Experience ?? Enumerable.Empty<dynamic>())
                        .Take(2).Select(exp => new
                        {
                            Company = (string)exp.employername,
                            Role = (string)exp.designation,
                            From = (string)exp.DurationFrom,
                            To = (string)exp.DurationTo
                        })
                };

                // Combine the resume text and trimmed profile into a single object
                var combinedObject = new
                {
                    ResumeText = resumeText,
                    CandidateProfile = trimmedProfile // The profile is trimmed for size optimization
                };

                // Serialize the combined object into JSON
                string combinedJson = JsonConvert.SerializeObject(combinedObject);

                // Pass the combined JSON to the ATS evaluator function
                await CalculateAtsAndParseResumeInBackground((int)candidateId, combinedJson);
            }
            catch (Exception ex)
            {
                // Handle exception here
                Console.WriteLine($"Error: {ex.Message}");
            }
        }

        //private async Task CandidateProfile(string filePath, long candidateId)
        //{
        //    try
        //    {
        //        string resumeText = await _helper.ExtractTextAsync(filePath);


        //        string profileJson = string.Empty;

        //        var parameters = new Dictionary<string, object>
        //        {
        //            {"@CandidateId", (int)candidateId }
        //        };

        //        // Fetch data using GetDataAsync
        //        DataTable dt = await _dataService.GetDataAsync("SP_ATSCANDIDATEPROFILE", parameters, _ConnectionString);
        //        if (dt.Rows.Count > 0)
        //        {
        //            profileJson = dt.Rows[0]["StudentResume"].ToString();
        //        }

        //        // 🔹 Deserialize profileJson into dynamic object
        //        dynamic profile = JsonConvert.DeserializeObject(profileJson);

        //        // ✅ Trim the profile to reduce token size
        //        var trimmedProfile = new
        //        {
        //            ExperienceYears = profile.TotalExperience,
        //            NoticePeriodDays = profile.NoticePeriod,
        //            Languages = ((IEnumerable<dynamic>)profile.Languages ?? Enumerable.Empty<dynamic>())
        //                .Select(l => (string)l.LanguageName),
        //            Education = ((IEnumerable<dynamic>)profile.Education ?? Enumerable.Empty<dynamic>())
        //                .Reverse().Take(2).Select(e => new
        //                {
        //                    Degree = (string)e.DegreeName,
        //                    Year = $"{e.startingYear}–{e.yearmonthpassing}",
        //                    Institute = (string)e.institute,
        //                    Score = (string)e.marks
        //                }),
        //            Experience = ((IEnumerable<dynamic>)profile.Experience ?? Enumerable.Empty<dynamic>())
        //                .Take(2).Select(exp => new
        //                {
        //                    Company = (string)exp.employername,
        //                    Role = (string)exp.designation,
        //                    From = (string)exp.DurationFrom,
        //                    To = (string)exp.DurationTo
        //                })
        //        }; 
        //        // Combine resumeText and profileJson
        //        var combinedObject = new
        //        {
        //            ResumeText = resumeText,
        //            CandidateProfile = trimmedProfile //JsonConvert.DeserializeObject(profileJson)
        //        };

        //        string combinedJson = JsonConvert.SerializeObject(combinedObject);

        //        await CalculateAtsAndParseResumeInBackground((int)candidateId, combinedJson);
        //    }
        //    catch (Exception ex)
        //    {

        //    }

        //}
        private async Task CalculateAtsAndParseResumeInBackground(int candidateId, string resumeText)
        {
            try
            {
                string jobDescription = await GetJobDescriptionAsync(candidateId);
                AtsPromptResult promptResult = await GeneratePromptFromSpAsync(candidateId, jobDescription, resumeText);

                var gptResponse = await _helper.SendMessageAsync(promptResult.Prompt, _GptAPI);

                if (IsAllZeroAtsResponse(gptResponse, promptResult.BreakDownArray)
                    && !string.IsNullOrWhiteSpace(promptResult.EvidenceSummary))
                {
                    string retryPrompt = BuildAtsRetryPrompt(promptResult);
                    string retryResponse = await _helper.SendMessageAsync(retryPrompt, _GptAPI);

                    if (!IsAllZeroAtsResponse(retryResponse, promptResult.BreakDownArray))
                    {
                        gptResponse = retryResponse;
                    }
                }


                if (!string.IsNullOrWhiteSpace(gptResponse))
                {
                    var resumeScore = await SaveAtsResponseToDb(gptResponse, candidateId, promptResult.TotalScore, promptResult.BreakDownArray);
                    Console.WriteLine("ATS Score calculated successfully.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error calculating ATS Score: " + ex.Message);
            }
        }

        private async Task<string> GetJobDescriptionAsync(int candidateId)
        {
            try
            {
                string profileJson = string.Empty;

                var parameters = new Dictionary<string, object>
                {
                    { "@CandidateId", candidateId }
                };

                // Fetch data from the stored procedure
                DataTable dt = await _dataService.GetDataAsync("SP_ATS_JOBDESCRIPTION", parameters, _ConnectionString);
                if (dt.Rows.Count > 0)
                {
                    profileJson = dt.Rows[0]["JobDescription"]?.ToString() ?? string.Empty;
                }

                if (string.IsNullOrWhiteSpace(profileJson))
                    return JsonConvert.SerializeObject(new { error = "No job profile data found." });

                JToken parsedToken;
                try
                {
                    parsedToken = JToken.Parse(profileJson);
                }
                catch
                {
                    return profileJson;
                }

                JObject? jobProfile = parsedToken switch
                {
                    JArray jArray => jArray.FirstOrDefault() as JObject,
                    JObject jObject => jObject,
                    _ => null
                };

                if (jobProfile == null)
                    return profileJson;

                return jobProfile.ToString(Formatting.None);
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    error = "An error occurred while generating job description.",
                    details = ex.Message
                });
            }
        }
        private async Task<AtsPromptResult> GeneratePromptFromSpAsync(int candidateId, string jobText, string resumeText)
        {
            var result = new AtsPromptResult();

            try
            {
                var parameters = new Dictionary<string, object>
                {
                    { "@CandidateId", candidateId }
                };

                DataTable dt = await _dataService.GetDataAsync(
                    "SP_ATS_PROMT",
                    parameters,
                    _ConnectionString);

                if (dt.Rows.Count == 0 || dt.Rows[0]["AtsPrompt"] == DBNull.Value)
                {
                    result.Prompt = JsonConvert.SerializeObject(new
                    {
                        error = "No ATS rating prompt data returned from stored procedure."
                    });

                    return result;
                }

                // ATS Configuration
                string profileJson = dt.Rows[0]["AtsPrompt"].ToString();
                JObject atsConfig = JObject.Parse(profileJson);

                // Resume JSON (if available)
                JObject resumeObj = null;

                try
                {
                    resumeObj = JObject.Parse(resumeText);
                }
                catch
                {
                    // Resume is plain text
                }

                string extractedResumeText =
                    resumeObj?["ResumeText"]?.ToString()
                    ?? resumeText
                    ?? "";

                JToken candidateProfile = HasCandidateEvidence(resumeObj?["CandidateProfile"])
                    ? resumeObj["CandidateProfile"]
                    : atsConfig["CandidateProfile"];

                decimal totalScore = atsConfig["Total Score"]?.Value<decimal>() ?? 100;

                var breakDownArray = JsonConvert.DeserializeObject<List<RatingItem>>(
                        atsConfig["BreakDownScore"]?.ToString() ?? "[]")
                    ?? new List<RatingItem>();

                var resultStatusArray = JsonConvert.DeserializeObject<List<ResultStatusItem>>(
                        atsConfig["Result Status"]?.ToString() ?? "[]")
                    ?? new List<ResultStatusItem>();

                if (totalScore <= 0)
                {
                    totalScore = breakDownArray.Sum(x =>
                    {
                        decimal.TryParse(x.Value, out decimal ratingValue);
                        return ratingValue;
                    });
                }

                if (totalScore <= 0)
                    totalScore = 100;

                string resultRules = string.Join(", ", resultStatusArray.Select(x => $"{x.Key}:{x.Value}"));

                string statusEvaluationInstructions = string.Join("\n", resultStatusArray.Select(x =>
                    $"   - Assign Status = \"{x.Key}\" when percentage satisfies rule: {x.Value}"
                ));

                string categoryRules = string.Join("\n", breakDownArray.Select(x =>
                {
                    string kws = (x.Keywords != null && x.Keywords.Any()) ? $"; keywords: {string.Join(", ", x.Keywords)}" : "";
                    return $"- {x.Key} | id:{x.Id} | max:{x.Value}{kws}";
                }));

                string scoresSchema = string.Join(",\n", breakDownArray.Select(x =>
                    $"    \"{x.Key}\": {{ \"total\": {x.Value}, \"obtained\": <0_to_{x.Value}>, \"id\": {x.Id}, \"notes\": \"short evidence\" }}"
                ));

                string candidateJson = TruncateText(candidateProfile?.ToString(Formatting.None) ?? "{}", MaxCandidateJsonChars);
                string compactJobText = BuildCompactJobText(jobText);
                string compactResumeText = BuildCompactResumeText(extractedResumeText, compactJobText, breakDownArray);
                string evidenceSummary = BuildEvidenceSummary(candidateJson, extractedResumeText, compactJobText, breakDownArray);

                string prompt = $@"
You are an ATS scoring engine. Score only from supplied data.

CONFIG
Total: {totalScore}
Categories:
{categoryRules}
Status rules: {resultRules}

RULES
- For every configured category, evaluate BOTH CANDIDATE_JSON and RESUME_TEXT.
- Candidate data is generic; do not depend on exact field names.
- Combine relevant evidence from both sources, then compare with JOB_DESCRIPTION and CONFIG keywords.
- Use semantic relevance; exact keyword match is not required.
- If a configured category name/keyword indicates location, relocation, city, state, country, or address, then candidate city/state/country/address evidence is relevant. If exact relocation readiness is absent but location evidence exists, award appropriate partial marks instead of 0.
- Do not invent missing facts. If sources conflict, use the most explicit relevant evidence.
- Award partial marks for incomplete but relevant evidence.
- Use 0 only when no relevant evidence exists in either source for that category.
- Clamp obtained: 0 <= obtained <= category total.
- match_score = sum obtained; percentage = round((match_score / {totalScore}) * 100, 2).
- Status must follow: {resultRules}
- Notes must be short evidence. If obtained is 0, notes = ""No relevant evidence found.""
- Return raw JSON only.

EVIDENCE_SUMMARY
{evidenceSummary}

JOB_DESCRIPTION
{compactJobText}

CANDIDATE_JSON
{candidateJson}

RESUME_TEXT
{compactResumeText}

JSON_SCHEMA
{{
  ""match_score"": <sum_of_obtained>,
  ""percentage"": <calculated_percentage>,
  ""remarks"": ""<short_fit_summary>"",
  ""Status"": ""<status_from_rules>"",
  ""scores"": {{
{scoresSchema}
  }}
}}
".Trim();

                result.Prompt = prompt;
                result.EvidenceSummary = evidenceSummary;
                result.JobText = compactJobText;
                result.CandidateJson = candidateJson;
                result.ResumeText = compactResumeText;
                result.TotalScore = totalScore;
                result.BreakDownArray = breakDownArray;
                result.ResultStatusArray = resultStatusArray;

                return result;
            }
            catch (Exception ex)
            {
                result.Prompt = JsonConvert.SerializeObject(new
                {
                    error = "An error occurred while generating ATS prompt.",
                    details = ex.Message
                });

                return result;
            }
        }

        private static bool IsAllZeroAtsResponse(string rawJson, List<RatingItem> breakDownArray)
        {
            if (string.IsNullOrWhiteSpace(rawJson))
                return false;

            try
            {
                string cleanedJson = rawJson
                    .Replace("```json", "")
                    .Replace("```", "")
                    .Trim('`', ' ', '\r', '\n');

                JObject jObject = JObject.Parse(cleanedJson);
                JObject scores = jObject["scores"] as JObject;
                if (scores == null)
                    return false;

                decimal matchScore = jObject["match_score"]?.Value<decimal>() ?? 0;
                if (matchScore > 0)
                    return false;

                foreach (RatingItem item in breakDownArray ?? new List<RatingItem>())
                {
                    decimal obtained = scores[item.Key]?["obtained"]?.Value<decimal>() ?? 0;
                    if (obtained > 0)
                        return false;
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        private static string BuildAtsRetryPrompt(AtsPromptResult promptResult)
        {
            string categoryRules = string.Join("\n", (promptResult.BreakDownArray ?? new List<RatingItem>()).Select(x =>
            {
                string keywords = x.Keywords != null && x.Keywords.Any()
                    ? $"; keywords: {string.Join(", ", x.Keywords)}"
                    : "";

                return $"- {x.Key} | id:{x.Id} | max:{x.Value}{keywords}";
            }));

            string statusRules = string.Join(", ", (promptResult.ResultStatusArray ?? new List<ResultStatusItem>())
                .Select(x => $"{x.Key}:{x.Value}"));

            string scoresSchema = string.Join(",\n", (promptResult.BreakDownArray ?? new List<RatingItem>()).Select(x =>
                $"    \"{x.Key}\": {{ \"total\": {x.Value}, \"obtained\": <0_to_{x.Value}>, \"id\": {x.Id}, \"notes\": \"short evidence\" }}"
            ));

            return $@"
You are an ATS scoring engine. The previous answer returned all zero, but candidate evidence is present.
Re-score using only supplied data. Do not return all zero when relevant evidence exists.

CONFIG
Total: {promptResult.TotalScore}
Categories:
{categoryRules}
Status rules: {statusRules}

DETECTED_CANDIDATE_EVIDENCE
{promptResult.EvidenceSummary}

JOB_DESCRIPTION
{promptResult.JobText}

CANDIDATE_JSON
{promptResult.CandidateJson}

RESUME_TEXT
{promptResult.ResumeText}

Rules:
- For every configured category, evaluate BOTH CANDIDATE_JSON and RESUME_TEXT.
- Combine evidence from both sources, compare with JOB_DESCRIPTION and CONFIG.
- Do not depend on exact field names; use semantic relevance.
- If a configured category name/keyword indicates location, relocation, city, state, country, or address, then candidate city/state/country/address evidence is relevant. If exact relocation readiness is absent but location evidence exists, award appropriate partial marks instead of 0.
- Do not invent missing facts. Award partial marks for incomplete but relevant evidence.
- Use 0 only when no relevant evidence exists in either source for that category.
- Clamp every obtained score: 0 <= obtained <= category total.
- match_score = sum of obtained scores.
- percentage = round((match_score / {promptResult.TotalScore}) * 100, 2).
- Return raw JSON only.

{{
  ""match_score"": <sum_of_obtained>,
  ""percentage"": <calculated_percentage>,
  ""remarks"": ""<short_fit_summary>"",
  ""Status"": ""<status_from_rules>"",
  ""scores"": {{
{scoresSchema}
  }}
}}
".Trim();
        }

        private static string BuildCompactJobText(string jobText)
        {
            return TruncateText(FlattenJsonOrText(jobText), MaxJobTextChars);
        }

        private static string BuildCompactResumeText(string resumeText, string jobText, List<RatingItem> breakDownArray)
        {
            if (string.IsNullOrWhiteSpace(resumeText))
                return string.Empty;

            string configAndJobTerms = BuildConfigAndJobTermSource(jobText, breakDownArray);
            var terms = ExtractEvidenceTerms(configAndJobTerms)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .Take(80)
                .ToList();

            string matchedLines = BuildLineEvidence(resumeText, terms, 35);
            if (!string.IsNullOrWhiteSpace(matchedLines))
                return TruncateText(matchedLines, MaxResumeTextChars);

            return TruncateText(resumeText, MaxResumeTextChars);
        }

        private static string BuildEvidenceSummary(string candidateJson, string resumeText, string jobText, List<RatingItem> breakDownArray)
        {
            var summary = new StringBuilder();

            if (!string.IsNullOrWhiteSpace(candidateJson) && candidateJson != "{}")
            {
                summary.AppendLine("Candidate profile:");
                summary.AppendLine(TruncateText(candidateJson, 900));
            }

            var detectedTerms = new SortedSet<string>(StringComparer.OrdinalIgnoreCase);
            string source = $"{candidateJson}\n{resumeText}";
            string configAndJobTerms = BuildConfigAndJobTermSource(jobText, breakDownArray);

            foreach (string term in ExtractEvidenceTerms(configAndJobTerms))
            {
                if (ContainsTerm(source, term))
                    detectedTerms.Add(term);
            }

            if (detectedTerms.Count > 0)
            {
                summary.AppendLine("Matched evidence terms from SP/JD:");
                summary.AppendLine(string.Join(", ", detectedTerms.Take(30)));
            }

            string matchedLineEvidence = BuildLineEvidence(resumeText, detectedTerms, 8);

            if (!string.IsNullOrWhiteSpace(matchedLineEvidence))
            {
                summary.AppendLine("Resume evidence lines matched from SP/JD:");
                summary.AppendLine(matchedLineEvidence);
            }

            string categoryEvidence = BuildCategoryEvidenceSummary(candidateJson, resumeText, jobText, breakDownArray);
            if (!string.IsNullOrWhiteSpace(categoryEvidence))
            {
                summary.AppendLine("Configured category evidence:");
                summary.AppendLine(categoryEvidence);
            }

            return summary.Length > 0
                ? TruncateText(summary.ToString().Trim(), MaxEvidenceSummaryChars)
                : TruncateText(resumeText, MaxEvidenceSummaryChars);
        }

        private static string BuildCategoryEvidenceSummary(string candidateJson, string resumeText, string jobText, List<RatingItem> breakDownArray)
        {
            if (breakDownArray == null || breakDownArray.Count == 0)
                return string.Empty;

            var summary = new StringBuilder();
            string source = $"{candidateJson}\n{resumeText}";
            var jobTerms = ExtractEvidenceTerms(FlattenJsonOrText(jobText))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .Take(80)
                .ToList();

            foreach (RatingItem item in breakDownArray)
            {
                var categoryTerms = new List<string>();

                if (!string.IsNullOrWhiteSpace(item.Key))
                    categoryTerms.Add(item.Key);

                if (item.Keywords != null)
                    categoryTerms.AddRange(item.Keywords.Where(x => !string.IsNullOrWhiteSpace(x)));

                categoryTerms.AddRange(jobTerms);

                var matchedTerms = ExtractEvidenceTerms(string.Join("\n", categoryTerms))
                    .Where(term => ContainsTerm(source, term))
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .Take(12)
                    .ToList();

                string matchedLines = BuildLineEvidence(resumeText, matchedTerms, 3);
                if (matchedTerms.Count == 0 && string.IsNullOrWhiteSpace(matchedLines))
                    continue;

                summary.AppendLine($"- {item.Key}: terms={string.Join(", ", matchedTerms)}");
                if (!string.IsNullOrWhiteSpace(matchedLines))
                    summary.AppendLine(TruncateText(matchedLines, 350));
            }

            return summary.ToString().Trim();
        }

        private static string BuildConfigAndJobTermSource(string jobText, List<RatingItem> breakDownArray)
        {
            var parts = new List<string>();

            if (breakDownArray != null)
            {
                foreach (RatingItem item in breakDownArray)
                {
                    if (!string.IsNullOrWhiteSpace(item.Key))
                        parts.Add(item.Key);

                    if (item.Keywords != null)
                        parts.AddRange(item.Keywords.Where(x => !string.IsNullOrWhiteSpace(x)));
                }
            }

            parts.Add(FlattenJsonOrText(jobText));

            return string.Join("\n", parts);
        }

        private static string FlattenJsonOrText(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                return string.Empty;

            try
            {
                JToken token = JToken.Parse(text);
                return string.Join("\n", FlattenJsonValues(token));
            }
            catch
            {
                return text;
            }
        }

        private static IEnumerable<string> FlattenJsonValues(JToken token)
        {
            if (token == null)
                yield break;

            if (token is JValue value)
            {
                string text = value.ToString();
                if (!string.IsNullOrWhiteSpace(text))
                    yield return text;

                yield break;
            }

            foreach (JToken child in token.Children())
            {
                foreach (string childValue in FlattenJsonValues(child))
                    yield return childValue;
            }
        }

        private static IEnumerable<string> ExtractEvidenceTerms(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                yield break;

            foreach (Match match in Regex.Matches(text, @"[A-Za-z][A-Za-z0-9+#./-]*(?:\s+[A-Za-z][A-Za-z0-9+#./-]*){0,2}"))
            {
                string term = match.Value.Trim().Trim(',', '.', ';', ':', ')', '(');
                if (term.Length >= 3 && !IsLowValueEvidenceTerm(term))
                    yield return term;
            }
        }

        private static bool IsLowValueEvidenceTerm(string term)
        {
            string normalized = term.Trim().ToLowerInvariant();

            return normalized is "and" or "the" or "with" or "for" or "from" or "using" or "must"
                or "have" or "either" or "this" or "that" or "required" or "optional" or "candidate"
                or "description" or "responsibilities" or "skills" or "experience" or "qualification";
        }

        private static bool ContainsTerm(string source, string term)
        {
            if (string.IsNullOrWhiteSpace(source) || string.IsNullOrWhiteSpace(term))
                return false;

            return source.IndexOf(term, StringComparison.OrdinalIgnoreCase) >= 0;
        }

        private static string BuildLineEvidence(string text, IEnumerable<string> terms, int maxLines)
        {
            if (string.IsNullOrWhiteSpace(text))
                return string.Empty;

            var lines = text
                .Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(x => x.Trim())
                .Where(x => x.Length > 0 && terms.Any(term => ContainsTerm(x, term)))
                .Distinct()
                .Take(maxLines);

            return string.Join("\n", lines);
        }

        private static string TruncateText(string text, int maxLength)
        {
            if (string.IsNullOrWhiteSpace(text) || text.Length <= maxLength)
                return text ?? string.Empty;

            return text.Substring(0, maxLength);
        }

        private static bool HasCandidateEvidence(JToken token)
        {
            if (token == null || token.Type == JTokenType.Null)
                return false;

            if (token.Type == JTokenType.Object)
                return token.Children<JProperty>().Any(p => HasCandidateEvidence(p.Value));

            if (token.Type == JTokenType.Array)
                return token.Children().Any(HasCandidateEvidence);

            return !string.IsNullOrWhiteSpace(token.ToString());
        }
        private async Task<ResumeScore> SaveAtsResponseToDb(string rawJson,int candidateId,decimal totalScoreFromPrompt,List<RatingItem> breakDownArrayFromPrompt)
        {
            string cleanedJson = rawJson
                .Replace("```json", "")
                .Replace("```", "")
                .Trim('`', ' ', '\r', '\n');

            var jObject = JObject.Parse(cleanedJson);

            int matchScore = jObject["match_score"]?.Value<int>() ?? 0;
            string remarks = jObject["remarks"]?.ToString() ?? "";
            string status = jObject["Status"]?.ToString() ?? "";

            // ✅ NEW: scores object
            var scoresToken = jObject["scores"] as JObject;
            if (scoresToken == null)
                throw new Exception("Invalid ATS response: scores missing.");

            decimal obtainedScore = 0;

            // -------- Build Breakdown JSON (Total + Obtained) --------
            var enrichedBreakdown = new Dictionary<string, object>();
            var detailsDict = new Dictionary<string, object>();

            foreach (var item in breakDownArrayFromPrompt)
            {
                string key = item.Key;
                decimal total = 0;
                decimal.TryParse(item.Value, out total);

                decimal obtained = scoresToken[key]?["obtained"]?.Value<decimal>() ?? 0;
                // Keep persisted ATS marks inside the configured category boundary.
                obtained = ClampObtainedScore(obtained, total);
                obtainedScore += obtained;
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

            if (totalScoreFromPrompt > 0 && obtainedScore > totalScoreFromPrompt)
                obtainedScore = totalScoreFromPrompt;

            matchScore = Convert.ToInt32(Math.Round(obtainedScore, 0, MidpointRounding.AwayFromZero));

            string breakdownJson = JsonConvert.SerializeObject(enrichedBreakdown, Formatting.None);
            string detailsJson = JsonConvert.SerializeObject(detailsDict, Formatting.None);

            // -------- Prepare ResumeScore --------
            var resumeScore = new ResumeScore
            {
                MatchScore = matchScore,
                CreatedAt = DateTime.UtcNow
            };

            // -------- Fetch Candidate Context --------
            int postId = 0, locId = 0, companyId = 0, departmentId = 0;

            var parameters = new Dictionary<string, object>
            {
                { "@CandidateId", candidateId }
            };

            DataTable dt = await _dataService.GetDataAsync(
                "SP_ATS_GETCANDIDATEDETAILS",
                parameters,
                _ConnectionString
            );

            if (dt.Rows.Count > 0)
            {
                postId = Convert.ToInt32(dt.Rows[0]["ActualPostID"]);
                locId = Convert.ToInt32(dt.Rows[0]["locId"]);
                companyId = Convert.ToInt32(dt.Rows[0]["companyId"]);
                departmentId = Convert.ToInt32(dt.Rows[0]["Departmentid"]);
            }

            // -------- Insert ATS Score --------
            var insertParams = new Dictionary<string, object>
            {
                { "@CANDIDATE_ID", candidateId },
                { "@POST_ID", postId },
                { "@LOCATION_ID", locId },
                { "@COMPANY_ID", companyId },
                { "@DEPARTMENT_ID", departmentId },
                { "@TOTAL_SCORE", totalScoreFromPrompt },
                { "@OBTAINED_SCORE", obtainedScore },   // ✅ correct
                { "@REMARKS", remarks },
                { "@STATUS", status },
                { "@BREAKDOWN_JSON", breakdownJson },
                { "@DETAILS_JSON", detailsJson }
            };

            int result = await _dataService.AddAsync(
                "SP_SAVE_ATS_SCORE",
                insertParams,
                _ConnectionString
            );

            return resumeScore;
        }

        private static decimal ClampObtainedScore(decimal obtained, decimal total)
        {
            if (obtained < 0)
                return 0;

            if (total > 0 && obtained > total)
                return total;

            return obtained;
        }


    }

}
