using ATS.API.Controllers;
using ATS.API.Interface;
using ATS.API.Models;
using ATS.API.Repository;
using CommonUtility.Interface;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

namespace ATS.API.Services
{
    public class BulkResumeService
    {
        private readonly IDataService _dataService;
        private readonly IATSHelper _helper;
        private readonly string _connectionString;
        private readonly string _gptApi;
        private readonly string _resumeSavePath;
        private readonly string _candidateResumeResponseTemplate;
        private readonly string _openAiCandidateResumePrompt;
        private readonly string _candidateSignupUrl;

        public BulkResumeService(IDataService dataService, IATSHelper atsHelper, IConfiguration configuration)
        {
            _dataService = dataService;
            _helper = atsHelper;
            _connectionString = configuration.GetConnectionString("DBConnRecruitment");
            _gptApi = configuration["GptAPI"];
            _resumeSavePath = configuration["ResumeSettings:SavePath"];
            _candidateResumeResponseTemplate = configuration["CandidateResumeResponseTemplate"];
            _openAiCandidateResumePrompt = configuration["OpenAIJobdescriptionConfig:CandidateResumePrompt"];
            _candidateSignupUrl = configuration["BulkResumeSignup:RegisterCandidateUrl"]
                ?? configuration["BulkResumeSignup:CreateNewUserSoapUrl"];
        }

        public async Task<List<ATSJobDescription>> GetJobDescriptionsByPostIdAsync(int postId)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@postId", postId }
            };

            DataTable dt = await _dataService.GetDataAsync("SP_ATS_GetJobDescriptionByPostId", parameters, _connectionString);

            if (dt.Rows.Count == 0)
                return new List<ATSJobDescription>();

            string profileJson = dt.Rows[0]["JobDescription"]?.ToString();

            if (string.IsNullOrWhiteSpace(profileJson))
                return new List<ATSJobDescription>();

            return JsonConvert.DeserializeObject<List<ATSJobDescription>>(profileJson)
                ?? new List<ATSJobDescription>();
        }

        public string GetUploadFolder()
        {
            string uploadFolder = Path.Combine(Directory.GetCurrentDirectory(), _resumeSavePath);

            if (!Directory.Exists(uploadFolder))
                Directory.CreateDirectory(uploadFolder);

            return uploadFolder;
        }

        public async Task<(string SavedFileName, string SavedFilePath)> SaveResumeTempFileAsync(IFormFile resume, string uploadFolder)
        {
            string extension = _helper.GetFileExtensionFromName(resume.FileName);
            string safeOriginalName = SanitizeFileName(Path.GetFileNameWithoutExtension(resume.FileName));
            string savedFileName = $"{safeOriginalName}_{Guid.NewGuid():N}{extension}";
            string savedFilePath = Path.Combine(uploadFolder, savedFileName);

            await using (var stream = new FileStream(savedFilePath, FileMode.Create))
            {
                await resume.CopyToAsync(stream);
            }

            return (savedFileName, savedFilePath);
        }

        public async Task<string> ExtractResumeTextAsync(string savedFilePath)
        {
            return await _helper.ExtractTextAsync(savedFilePath);
        }

        public async Task<string> SendGptMessageAsync(string prompt)
        {
            return await _helper.SendMessageAsync(prompt, _gptApi);
        }

        public async Task SaveBulkResumeAtsScoreAsync(int postId, string originalCvName, string savedCvName, string fileHash, string candidateName, string mailId, string phoneNumber, long? generatedCandidateId, string status, bool isShortlisted, JObject scoreJson, JObject candidateJson, bool isDuplicate, long? duplicateOfLogId)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@POST_ID", postId },
                { "@CV_NAME", originalCvName ?? string.Empty },
                { "@SAVED_CV_NAME", savedCvName ?? string.Empty },
                { "@FILE_HASH", fileHash ?? string.Empty },
                { "@CANDIDATE_NAME", candidateName ?? string.Empty },
                { "@MAIL_ID", mailId ?? string.Empty },
                { "@PHONE_NUMBER", phoneNumber ?? string.Empty },
                { "@CANDIDATE_ID", generatedCandidateId.HasValue ? generatedCandidateId.Value : DBNull.Value },
                { "@ATS_STATUS", status ?? string.Empty },
                { "@IS_SHORTLISTED", isShortlisted },
                { "@FULL_JSON", scoreJson?.ToString(Formatting.None) ?? string.Empty },
                { "@CANDIDATE_JSON", candidateJson?.ToString(Formatting.None) ?? string.Empty },
                { "@IS_DUPLICATE", isDuplicate },
                { "@DUPLICATE_OF_LOG_ID", duplicateOfLogId.HasValue ? duplicateOfLogId.Value : DBNull.Value }
            };

            await _dataService.AddAsync("PRC_SAVE_BULK_RESUME_ATS_SCORE", parameters, _connectionString);
        }

        public async Task UpdateCandidateIdBulkResumeAtsScoreLog(int postId, string fileHash, string candidateName, string mailId, string phoneNumber, long? generatedCandidateId)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@POST_ID", postId },
                { "@FILE_HASH", fileHash ?? string.Empty },
                { "@CANDIDATE_NAME", candidateName ?? string.Empty },
                { "@MAIL_ID", mailId ?? string.Empty },
                { "@PHONE_NUMBER", phoneNumber ?? string.Empty },
                { "@CANDIDATE_ID", generatedCandidateId.HasValue ? generatedCandidateId.Value : DBNull.Value }
            };

            await _dataService.AddAsync("PRC_UPDATE_BULK_RESUME_ATS_SCORE", parameters, _connectionString);
        }

        public async Task<JObject> GetExistingCandidateByUsernameOrMailAsync(string username, string mailId)
        {
            if (string.IsNullOrWhiteSpace(username) && string.IsNullOrWhiteSpace(mailId))
                return null;

            var parameters = new Dictionary<string, object>
            {
                { "@username", username ?? string.Empty },
                { "@mailid", mailId ?? string.Empty }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_CHECK_BULK_RESUME_CANDIDATE_EXISTS", parameters, _connectionString);

            if (dt.Rows.Count == 0)
                return null;

            return ConvertFirstRowToJson(dt);
        }

        public async Task<JObject> GetExistingBulkResumeByHashAsync(int postId, string fileHash)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@POST_ID", postId },
                { "@FILE_HASH", fileHash }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_GET_BULK_RESUME_ATS_BY_HASH", parameters, _connectionString);

            if (dt.Rows.Count == 0)
                return null;

            return ConvertFirstRowToJson(dt);
        }

        public async Task<string> ComputeFileHashAsync(string filePath)
        {
            await using FileStream stream = File.OpenRead(filePath);
            byte[] hashBytes = await SHA256.HashDataAsync(stream);
            return Convert.ToHexString(hashBytes);
        }

        public void DeleteTempFile(string filePath)
        {
            if (string.IsNullOrWhiteSpace(filePath) || !File.Exists(filePath))
                return;

            try
            {
                File.Delete(filePath);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error deleting temp resume file '{filePath}': {ex.Message}");
            }
        }

        public async Task<AtsPromptResult> GenerateBulkPromptFromAtsHeadRatingAsync(int atsHeadRatingId, ATSJobDescription jobDescription, string resumeText)
        {
            var result = new AtsPromptResult();

            try
            {
                var parameters = new Dictionary<string, object>
                {
                    { "@ATS_HEAD_RATING_ID", atsHeadRatingId }
                };

                DataTable dt = await _dataService.GetDataAsync("SP_ATS_PROMT_BY_HEAD_RATING_ID", parameters, _connectionString);

                if (dt.Rows.Count == 0 || dt.Rows[0]["AtsPrompt"] == DBNull.Value)
                {
                    result.Prompt = JsonConvert.SerializeObject(new { error = "No ATS rating prompt data returned from stored procedure." });
                    return result;
                }

                string profileJson = dt.Rows[0]["AtsPrompt"].ToString();
                var jObj = JObject.Parse(profileJson);

                decimal totalScore = jObj["Total Score"]?.Value<decimal>() ?? 100;

                var breakDownArray = JsonConvert.DeserializeObject<List<RatingItem>>(
                    jObj["BreakDownScore"]?.ToString() ?? "[]"
                ) ?? new List<RatingItem>();

                var resultStatusArray = JsonConvert.DeserializeObject<List<ResultStatusItem>>(
                    jObj["Result Status"]?.ToString() ?? "[]"
                ) ?? new List<ResultStatusItem>();

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
                string statusOptions = string.Join(", ", resultStatusArray.Select(x => $"\"{x.Key}\""));

                string keywordHints = string.Join("; ",
                    breakDownArray
                        .Where(x => x.Keywords != null && x.Keywords.Any())
                        .Select(x => $"{x.Key}:{string.Join(",", x.Keywords)}")
                );

                string scoresSchema = string.Join(",\n    ",
                    breakDownArray.Select(x =>
                        $"\"{x.Key}\": {{ \"total\": {x.Value}, \"obtained\": number, \"id\": {x.Id}, \"notes\": string }}"
                    )
                );

                string scoringInstruction = $@"
                    For each category, calculate an obtained score between 0 and the category's total
                    using ONLY explicit evidence found in the Job Description JSON or Resume text.

                    Rules:
                    - Do NOT infer or assume missing information.
                    - obtained must be a number <= total.
                    - If no explicit evidence exists, obtained = 0.
                    - match_score MUST equal the sum of all obtained values.
                    - percentage = (match_score / {totalScore}) * 100.
                    - percentage must be a finite number. Never return Infinity, -Infinity, or NaN.
                    ";

                string prompt = $@"
                    You are an Applicant Tracking System (ATS) evaluator.
                    Use ONLY the explicit data supplied below. Do NOT infer or assume anything.

                    Total Score: {totalScore}
                    Result Rules: {resultRules}
                    Keywords (internal use only): {keywordHints}

                    JD:
                    {JsonConvert.SerializeObject(jobDescription, Formatting.None)}

                    Resume:
                    {resumeText}

                    {scoringInstruction}

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
                    error = "An error occurred while generating bulk ATS prompt.",
                    details = ex.Message
                });

                return result;
            }
        }

        public async Task<JObject> ParseCandidateResumeJsonAsync(string resumeText)
        {
            if (string.IsNullOrWhiteSpace(resumeText))
                return new JObject();

            string prompt = _openAiCandidateResumePrompt.Replace("{ResumeDescription}", resumeText);
            prompt += _candidateResumeResponseTemplate;

            string gptResponse = await _helper.SendMessageAsync(prompt, _gptApi);
            JObject resume = CleanAndParseJson(gptResponse);

            await EnrichResumeLocationByPinCodeAsync(resume);

            return resume;
        }

        public async Task<JObject> RegisterShortlistedCandidateAsync(JObject candidateJson, ATSJobDescription jobDescription)
        {
            var result = new JObject
            {
                ["Success"] = false,
                ["Message"] = string.Empty,
                ["CandidateId"] = null
            };

            if (string.IsNullOrWhiteSpace(_candidateSignupUrl))
            {
                result["Message"] = "BulkResumeSignup:RegisterCandidateUrl is not configured.";
                return result;
            }

            string email = GetJsonString(candidateJson, "Email");
            string mobile = GetJsonString(candidateJson, "Mobile");
            string username = !string.IsNullOrWhiteSpace(email) ? email : mobile;
            string password = GetSignupPassword(email);

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(email))
            {
                result["Message"] = "Candidate email is required for RegisterCandidate.";
                return result;
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                result["Message"] = "Candidate password could not be prepared from email.";
                return result;
            }

            try
            {
                var payload = new
                {
                    Username = username,
                    Email = email,
                    Password = password,
                    Company = jobDescription.COMPANY_NAME ?? string.Empty,
                    Post = jobDescription.POST ?? string.Empty,
                    IDCompany = jobDescription.CompanyID,
                    IDPost = jobDescription.PostID
                };

                using var client = new HttpClient();
                using var request = new HttpRequestMessage(HttpMethod.Post, _candidateSignupUrl);
                request.Content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");

                using HttpResponseMessage response = await client.SendAsync(request);
                string responseText = await response.Content.ReadAsStringAsync();

                result["HttpStatusCode"] = (int)response.StatusCode;
                result["RawResponse"] = responseText;
                result["Username"] = username;
                result["Email"] = email;
                result["Password"] = password;

                if (!response.IsSuccessStatusCode)
                {
                    result["Message"] = $"RegisterCandidate call failed with HTTP {(int)response.StatusCode}.";
                    return result;
                }

                JObject responseJson = CleanAndParseJson(responseText);
                string registerResult = responseJson["d"]?.ToString() ?? string.Empty;
                result["RegisterCandidateResult"] = registerResult;

                long? candidateId = ExtractCandidateId(registerResult);

                if (candidateId.HasValue && candidateId.Value > 0)
                {
                    result["Success"] = true;
                    result["CandidateId"] = candidateId.Value;
                    result["Message"] = "Shortlisted candidate created successfully.";
                    return result;
                }

                result["Message"] = string.IsNullOrWhiteSpace(registerResult)
                    ? "RegisterCandidate did not return a candidate id."
                    : registerResult;

                return result;
            }
            catch (Exception ex)
            {
                result["Message"] = $"RegisterCandidate call error: {ex.Message}";
                return result;
            }
        }

        public async Task<ResumeScore> SaveAtsResponseToDb(string rawJson, int candidateId, decimal totalScoreFromPrompt, List<RatingItem> breakDownArrayFromPrompt)
        {
            string cleanedJson = rawJson
                .Replace("```json", "")
                .Replace("```", "")
                .Trim('`', ' ', '\r', '\n');

            var jObject = JObject.Parse(cleanedJson);

            int matchScore = jObject["match_score"]?.Value<int>() ?? 0;
            string remarks = jObject["remarks"]?.ToString() ?? string.Empty;
            string status = jObject["Status"]?.ToString() ?? string.Empty;

            var scoresToken = jObject["scores"] as JObject;
            if (scoresToken == null)
                throw new Exception("Invalid ATS response: scores missing.");

            decimal obtainedScore = matchScore;
            var enrichedBreakdown = new Dictionary<string, object>();
            var detailsDict = new Dictionary<string, object>();

            foreach (var item in breakDownArrayFromPrompt)
            {
                string key = item.Key;
                decimal total = 0;
                decimal.TryParse(item.Value, out total);

                decimal obtained = scoresToken[key]?["obtained"]?.Value<decimal>() ?? 0;
                string notes = scoresToken[key]?["notes"]?.ToString() ?? string.Empty;
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

            string breakdownJson = JsonConvert.SerializeObject(enrichedBreakdown, Formatting.None);
            string detailsJson = JsonConvert.SerializeObject(detailsDict, Formatting.None);

            var resumeScore = new ResumeScore
            {
                MatchScore = matchScore,
                CreatedAt = DateTime.UtcNow
            };

            int postId = 0;
            int locId = 0;
            int companyId = 0;
            int departmentId = 0;

            var parameters = new Dictionary<string, object>
            {
                { "@CandidateId", candidateId }
            };

            DataTable dt = await _dataService.GetDataAsync("SP_ATS_GETCANDIDATEDETAIL", parameters, _connectionString);

            if (dt.Rows.Count > 0)
            {
                postId = Convert.ToInt32(dt.Rows[0]["ActualPostID"]);
                locId = Convert.ToInt32(dt.Rows[0]["locId"]);
                companyId = Convert.ToInt32(dt.Rows[0]["companyId"]);
                departmentId = Convert.ToInt32(dt.Rows[0]["Departmentid"]);
            }

            var insertParams = new Dictionary<string, object>
            {
                { "@CANDIDATE_ID", candidateId },
                { "@POST_ID", postId },
                { "@LOCATION_ID", locId },
                { "@COMPANY_ID", companyId },
                { "@DEPARTMENT_ID", departmentId },
                { "@TOTAL_SCORE", totalScoreFromPrompt },
                { "@OBTAINED_SCORE", obtainedScore },
                { "@REMARKS", remarks },
                { "@STATUS", status },
                { "@BREAKDOWN_JSON", breakdownJson },
                { "@DETAILS_JSON", detailsJson }
            };

            await _dataService.AddAsync("SP_SAVE_ATS_SCORE", insertParams, _connectionString);

            return resumeScore;
        }

        public string GetJsonString(JObject json, string propertyName)
        {
            return json?[propertyName]?.ToString()?.Trim() ?? string.Empty;
        }

        public string GetCandidateName(JObject candidateJson)
        {
            string firstName = GetJsonString(candidateJson, "CandidateFirstName");
            string middleName = GetJsonString(candidateJson, "CandidateMiddleName");
            string lastName = GetJsonString(candidateJson, "CandidateLastName");

            string fullName = string.Join(" ",
                new[] { firstName, middleName, lastName }
                    .Where(x => !string.IsNullOrWhiteSpace(x))
            );

            if (!string.IsNullOrWhiteSpace(fullName))
                return fullName;

            string email = GetJsonString(candidateJson, "Email");
            if (!string.IsNullOrWhiteSpace(email))
                return email;

            return GetJsonString(candidateJson, "Mobile");
        }

        public JObject CleanAndParseJson(string rawJson)
        {
            if (string.IsNullOrWhiteSpace(rawJson))
                throw new Exception("GPT response is empty.");

            string cleanedJson = rawJson
                .Replace("```json", "")
                .Replace("```", "")
                .Replace("json\r\n", "")
                .Replace("json\n", "")
                .Trim('`', ' ', '\r', '\n');

            int firstBrace = cleanedJson.IndexOf('{');
            int lastBrace = cleanedJson.LastIndexOf('}');

            if (firstBrace >= 0 && lastBrace > firstBrace)
                cleanedJson = cleanedJson.Substring(firstBrace, lastBrace - firstBrace + 1);

            cleanedJson = Regex.Replace(cleanedJson, @":\s*(Infinity|-Infinity|NaN)(\s*[,}])", ": 0$2", RegexOptions.IgnoreCase);

            return JObject.Parse(cleanedJson);
        }

        public JObject BuildAtsScoreParseFailedJson(string rawResponse, AtsPromptResult promptResult)
        {
            var scoreJson = new JObject
            {
                ["match_score"] = 0,
                ["percentage"] = 0,
                ["remarks"] = "ATS score response could not be parsed. Candidate marked as rejected.",
                ["Status"] = GetRejectedStatus(promptResult),
                ["scores"] = new JObject(),
                ["RawAtsResponse"] = rawResponse ?? string.Empty
            };

            JObject scores = (JObject)scoreJson["scores"];

            foreach (RatingItem item in promptResult?.BreakDownArray ?? new List<RatingItem>())
            {
                decimal.TryParse(item.Value, out decimal total);

                scores[item.Key] = new JObject
                {
                    ["total"] = total,
                    ["obtained"] = 0,
                    ["id"] = item.Id,
                    ["notes"] = "ATS score response could not be parsed."
                };
            }

            return scoreJson;
        }

        public bool IsAtsShortlisted(JObject scoreJson)
        {
            string status = scoreJson["Status"]?.ToString();
            bool recommended = scoreJson["RecommendedForATSShortlisting"]?.Value<bool?>() ?? false;

            return recommended ||
                   (!string.IsNullOrWhiteSpace(status) &&
                    status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase));
        }

        private async Task EnrichResumeLocationByPinCodeAsync(JObject resume)
        {
            string pinCode = resume["PinCode"]?.ToString();

            if (string.IsNullOrWhiteSpace(pinCode))
                return;

            try
            {
                using var client = new HttpClient();
                string apiResponse = await client.GetStringAsync($"https://api.postalpincode.in/pincode/{pinCode}");
                var result = JArray.Parse(apiResponse);

                if (result[0]["Status"]?.ToString() == "Success")
                {
                    JToken postOffice = result[0]["PostOffice"]?[0];

                    if (postOffice != null)
                    {
                        resume["District"] = postOffice["District"]?.ToString();
                        resume["State"] = postOffice["State"]?.ToString();
                        resume["Country"] = postOffice["Country"]?.ToString();
                    }
                }
            }
            catch (Exception)
            {
                resume["District"] = "";
                resume["State"] = "";
                resume["Country"] = "";
            }
        }

        private JObject ConvertFirstRowToJson(DataTable dt)
        {
            var result = new JObject();

            foreach (DataColumn column in dt.Columns)
            {
                object value = dt.Rows[0][column];
                result[column.ColumnName] = value == DBNull.Value ? null : JToken.FromObject(value);
            }

            return result;
        }

        private string GetSignupPassword(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return string.Empty;

            int atIndex = email.IndexOf('@');
            return atIndex > 0 ? email.Substring(0, atIndex) : email;
        }

        private long? ExtractCandidateId(string registerResult)
        {
            if (string.IsNullOrWhiteSpace(registerResult))
                return null;

            string candidateIdText = registerResult.Contains(':')
                ? registerResult.Split(':').LastOrDefault()
                : registerResult;

            return long.TryParse(candidateIdText?.Trim(), out long candidateId)
                ? candidateId
                : null;
        }

        private string GetRejectedStatus(AtsPromptResult promptResult)
        {
            string rejectedStatus = promptResult?.ResultStatusArray?
                .FirstOrDefault(x => !string.IsNullOrWhiteSpace(x.Key) &&
                                     x.Key.Contains("reject", StringComparison.OrdinalIgnoreCase))
                ?.Key;

            return string.IsNullOrWhiteSpace(rejectedStatus) ? "Rejected" : rejectedStatus;
        }

        private string SanitizeFileName(string fileName)
        {
            if (string.IsNullOrWhiteSpace(fileName))
                return "resume";

            foreach (char invalidChar in Path.GetInvalidFileNameChars())
            {
                fileName = fileName.Replace(invalidChar, '_');
            }

            return fileName.Trim();
        }

    }
}
