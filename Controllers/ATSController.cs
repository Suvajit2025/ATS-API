using ATS.API.Interface;
using ATS.API.Models;
using CommonUtility.Interface;
using DocumentFormat.OpenXml.Drawing.Diagrams;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Text;
using System.Text.RegularExpressions;

namespace ATS.API.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ATSController : ControllerBase
    {
        private readonly IBackgroundTaskQueue _backgroundTaskQueue;
        private readonly ICommonService _commonService;
        private readonly IDataService _dataService;
        private readonly string _ConnectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IATSHelper _helper;
        public string _GptAPI;
        public string _ResumeSavePath;
        public string _ResumeSaveDB;

        public ATSController(ICommonService commonService, IDataService dataService, IHttpContextAccessor httpContextAccessor, IConfiguration configuration, IATSHelper aTSHelper, IBackgroundTaskQueue backgroundTaskQueue)
        {
            _commonService = commonService;
            _dataService = dataService;
            _ConnectionString = configuration.GetConnectionString("DBConnRecruitment");
            _httpContextAccessor = httpContextAccessor;
            _helper = aTSHelper;
            _backgroundTaskQueue = backgroundTaskQueue;
            _GptAPI = configuration["GptAPI"];
            _ResumeSavePath=configuration["ResumeSettings:SavePath"];
            _ResumeSaveDB = configuration["ResumeSettings:fileUrl"];
        }
        [HttpPost("ATSScore")]
        public async Task<IActionResult> AtsScoreByID(string username)
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
                    profileJson = dt.Rows[0]["JobDescription"].ToString();
                }

                if (string.IsNullOrWhiteSpace(profileJson))
                    return JsonConvert.SerializeObject(new { error = "No job profile data found." });

                var jobProfileArray = JsonConvert.DeserializeObject<JArray>(profileJson);
                var jobProfile = jobProfileArray.FirstOrDefault() as JObject;

                if (jobProfile == null)
                    return JsonConvert.SerializeObject(new { error = "Job profile format is invalid." });

                // Extract and simplify fields
                string title = jobProfile["JobTitle"]?.ToString() ?? "";
                string location = jobProfile["Location"]?.ToString() ?? "";
                string experience = jobProfile["Experience"]?.ToString() ?? "";
                string qualifications = jobProfile["Qualifications"]?.ToString() ?? "";

                // Merge RequiredSkill + TechnicalScope and compress
                string skills = $"{jobProfile["RequiredSkill"]?.ToString()} {jobProfile["TechnicalScope"]?.ToString()}";
                skills = Regex.Replace(skills, @"\s+", " ").Trim(); // remove line breaks and extra space
                string others = jobProfile["Others"]?.ToString() ?? "";
                // Shorten responsibilities to top 2–3 points (if possible)
                string responsibilities = jobProfile["JobResponsibility"]?.ToString() ?? "";
                var responsibilityItems = Regex.Split(responsibilities, "•").Where(r => !string.IsNullOrWhiteSpace(r)).Take(3);
                string topResponsibilities = string.Join("; ", responsibilityItems).Trim();

                // Final compressed object
                var compressed = new
                {
                    JobTitle = title,
                    Location = location,
                    Experience = experience,
                    Qualifications = qualifications,
                    Skills = skills,
                    KeyResponsibilities = topResponsibilities,
                    JD_Summary = $"We are hiring {title} in {location} with {experience}. Must have skills: {skills}. Responsibilities: {topResponsibilities}.Other Informations: {others}."
                };

                // Serialize the final job description to JSON and return
                string jobDescription = JsonConvert.SerializeObject(compressed);

                return jobDescription;
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
                string profileJson = string.Empty;

                var parameters = new Dictionary<string, object>
                {
                    { "@CandidateId", candidateId }
                };

                DataTable dt = await _dataService.GetDataAsync("SP_ATS_PROMT", parameters, _ConnectionString);

                if (dt.Rows.Count > 0)
                {
                    profileJson = dt.Rows[0]["AtsPrompt"]?.ToString();
                }

                if (string.IsNullOrWhiteSpace(profileJson))
                {
                    result.Prompt = JsonConvert.SerializeObject(new { error = "No data returned from stored procedure." });
                    return result;
                }

                var jObj = JObject.Parse(profileJson);

                decimal totalScore = jObj["Total Score"]?.Value<decimal>() ?? 100;
                string breakDownRaw = jObj["BreakDownScore"]?.ToString();
                string resultStatusRaw = jObj["Result Status"]?.ToString();

                var breakDownArray = JsonConvert.DeserializeObject<List<RatingItem>>(breakDownRaw);
                //var breakDownArray = JsonConvert.DeserializeObject<List<RatingItem>>(breakDownRaw);
                var resultStatusArray = JsonConvert.DeserializeObject<List<ResultStatusItem>>(resultStatusRaw);

                // Compressed format: Skill:30, Qualification:30...
                var breakdownScores = string.Join(", ", breakDownArray.Select(x => $"{x.Key}:{x.Value}"));
                var resultRules = string.Join(", ", resultStatusArray.Select(x => $"{x.Key}:{x.Value}"));

                // Inject keywords: Skills:React,Node.js; Qualification:MBA,B.Tech
                var keywordHints = string.Join("; ", breakDownArray
                    .Where(x => x.Keywords != null && x.Keywords.Any())
                    .Select(x => $"{x.Key}:{string.Join(",", x.Keywords)}"));

                // Output schema – breakdown and details keys only
                var breakdownSchema = string.Join(", ", breakDownArray.Select(x => $"\"{x.Key}\": number"));
                var detailSchema = string.Join(", ", breakDownArray.Select(x => $"\"{x.Key}\": string"));
    //            var detailSchema = string.Join(", ", breakDownArray.Select(x =>
    //$"\"{x.Key}\": {{ \"notes\": string, \"id\": number }}"));

                string statusInfo = string.Join(", ", resultStatusArray.Select(x => x.Key));

                // List out the category names for the generic instruction
                string categoryList = string.Join(", ",
                    breakDownArray.Select(x => x.Key));

                // 2) Compose a single, generic “scoring instruction” line
                //string scoringInstruction = $@"
                //        For each category in Breakdown [{categoryList}], assign points **only** if there is 
                //        explicit evidence in the CandidateProfile JSON or the Resume text; 
                //        otherwise assign 0 to that category.";
                string scoringInstruction = $@"
                For each category in Breakdown [{categoryList}], assign points **only** if there is 
                explicit evidence in the CandidateProfile JSON or the Resume text; 
                otherwise assign 0 to that category.
                Also, generate a brief 'notes' string per category to explain the score.";
                var breakdown = string.Join(",\n    ",
                          breakDownArray.Select(x => $"\"{x.Key}\": {x.Value}"));
                var details = string.Join(",\n    ",
                           breakDownArray.Select(x => $"\"{x.Key}\": {{ \"id\": {x.Id}, \"notes\": \"Give a clear and Proper explanation why the candidate got this score based on {x.Key},avoiding overly optimistic or pessimistic scoring. \" }}"));

                //string prompt = $@"
                //    You are an Applicant Tracking System (ATS) evaluator. Use ONLY the explicit information provided below—do NOT assume anything not literally in the data.

                //    Total Score: {totalScore}
                //    Breakdown: {breakdownScores}
                //    Result Rules: {resultRules}
                //    Keywords (internal use only): {keywordHints}

                //    Compare the following Job Description and Resume using keywords as scoring hints.
                //    Score each category accordingly and compute:

                //    - match_score = sum of section scores
                //    - percentage = match_score / Total Score × 100
                //    - Status = based on Result Rules

                //    Return JSON only:
                //    {{
                //      ""match_score"": number,
                //      ""percentage"": number,
                //      ""remarks"": string,
                //      ""Status"": one of [{statusInfo}],
                //      ""breakdown"": {{ {breakdownSchema} }},
                //      ""details"": {{ {detailSchema} }}
                //    }}

                //    JD: {jobText}
                //    Resume: {resumeText}
                //    temperature = 0.2
                //    ".Trim();

                // 3) Now build your prompt—notice there are no hard-coded rules anymore
                string prompt = $@"
                    You are an Applicant Tracking System (ATS) evaluator. Use **only** the explicit data supplied—do **not** infer or assume anything extra.

                    Total Score: {totalScore}
                    Breakdown: {breakdownScores}
                    Result Rules: {resultRules}
                    Keywords (internal use only): {keywordHints}

                    CandidateProfile JSON:
                    {JsonConvert.SerializeObject(jObj["CandidateProfile"], Formatting.None)}

                    JD: {jobText}
                    Resume: {resumeText}

                    {scoringInstruction}

                    Compute:
                    - match_score = sum of section scores  
                    - percentage = match_score / Total Score × 100  
                    - Status = choose based on the Result Rules  

                    Return JSON only:
                    {{
                      ""match_score"": number,
                      ""percentage"": number,
                      ""remarks"": string,
                      ""Status"": one of [{string.Join(", ", resultStatusArray.Select(x => $"\"{x.Key}\""))}],
                       
                      ""breakdown"": {{ {breakdown} }},
                      ""details"": {{ {details} }}
                    }}
                    temperature = 0.2
                    ".Trim();

                result.Prompt = prompt;
                result.TotalScore = totalScore;
                result.BreakDownArray = breakDownArray;
                result.ResultStatusArray = resultStatusArray;

                return result;
            }
            catch (Exception ex)
            {
                result.Prompt = JsonConvert.SerializeObject(new
                {
                    error = "An error occurred while generating Prompt For ATS.",
                    details = ex.Message
                });

                return result;
            }
        }


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

        private async Task<ResumeScore> SaveAtsResponseToDb(string rawJson, int candidateId, decimal totalScoreFromPrompt, List<RatingItem> breakDownArrayFromPrompt)
        {
            string cleanedJson = rawJson
                .Replace("```json", "")
                .Replace("```", "")
                .Replace("json\r\n", "")
                .Replace("json\n", "")
                .Trim('`', ' ', '\r', '\n');

            var jObject = JObject.Parse(cleanedJson);

            int matchScore = jObject["match_score"]?.Value<int>() ?? 0;
            string remarks = jObject["remarks"]?.ToString() ?? "";
            string status = jObject["Status"]?.ToString() ?? "";

            string detailsJson = jObject["details"]?.ToString(Newtonsoft.Json.Formatting.None) ?? "{}";

            // Step 1: Parse obtained breakdown from GPT
            var obtainedDict = JsonConvert.DeserializeObject<Dictionary<string, decimal>>(
                jObject["breakdown"]?.ToString() ?? "{}"
            );

            // Step 2: Merge with total config to build enriched breakdown
            decimal obtainedScore = 0;
            var enrichedBreakdown = new Dictionary<string, object>();

            foreach (var item in breakDownArrayFromPrompt)
            {
                string key = item.Key;
                decimal total = 0;
                decimal.TryParse(item.Value?.ToString(), out total);

                decimal obtained = obtainedDict.ContainsKey(key) ? obtainedDict[key] : 0;
                obtainedScore += obtained;

                enrichedBreakdown[key] = new Dictionary<string, object>
                {
                    { "Total", total },
                    { "Obtained", obtained }
                };
            }

            //enrichedBreakdown["TotalScore"] = totalScoreFromPrompt;
            //enrichedBreakdown["ObtainedScore"] = obtainedScore;

            string breakdownJson = JsonConvert.SerializeObject(enrichedBreakdown, Formatting.None);

            // Prepare resume score object
            var resumeScore = new ResumeScore
            {
                MatchScore = matchScore,
                CreatedAt = DateTime.UtcNow
            };

            int postId = 0, locId = 0, companyId = 0, departmentId = 0;

            var parameters = new Dictionary<string, object>
            {
                { "@CandidateId", candidateId }
            };

            DataTable dt = await _dataService.GetDataAsync("SP_ATS_GETCANDIDATEDETAILS", parameters, _ConnectionString);
            if (dt.Rows.Count > 0)
            {
                try
                {
                    postId = Convert.ToInt32(dt.Rows[0]["ActualPostID"]);
                    locId = Convert.ToInt32(dt.Rows[0]["locId"]);
                    companyId = Convert.ToInt32(dt.Rows[0]["companyId"]);
                    departmentId = Convert.ToInt32(dt.Rows[0]["Departmentid"]);
                }
                catch { }
            }

            var InsertParameters = new Dictionary<string, object>
            {
                { "@CANDIDATE_ID", candidateId },
                { "@POST_ID", postId },
                { "@LOCATION_ID", locId },
                { "@COMPANY_ID", companyId },
                { "@DEPARTMENT_ID", departmentId },
                { "@TOTAL_SCORE", totalScoreFromPrompt },              // from prompt
                { "@REMARKS", remarks },
                { "@STATUS", status },
                { "@BREAKDOWN_JSON", breakdownJson },
                { "@DETAILS_JSON", detailsJson },
                { "@OBTAINED_SCORE", obtainedScore }                  // calculated
            };

            try
            {
                int result = await _dataService.AddAsync("SP_SAVE_ATS_SCORE", InsertParameters, _ConnectionString);
            }
            catch (Exception ex)
            {
                // Optionally log exception
            }

            return resumeScore;
        }

    }
}
