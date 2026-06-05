using ATS.API.Interface;
using ATS.API.Models;
using CommonUtility.Interface;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Xml.Linq;

namespace ATS.API.Controllers
{
    [Route("ATS")]
    [ApiController]
    public class BulkResumeController : ControllerBase
    {
        private readonly IDataService _dataService;
        private readonly IATSHelper _helper;
        private readonly string _connectionString;
        private readonly string _gptApi;
        private readonly string _resumeSavePath;
        private readonly string _candidateResumeResponseTemplate;
        private readonly string _openAiCandidateResumePrompt;
        private readonly string _candidateSignupSoapUrl;
        private readonly string _candidateSignupDefaultPassword;

        public BulkResumeController(
            IDataService dataService,
            IATSHelper atsHelper,
            IConfiguration configuration)
        {
            _dataService = dataService;
            _helper = atsHelper;
            _connectionString = configuration.GetConnectionString("DBConnRecruitment");
            _gptApi = configuration["GptAPI"];
            _resumeSavePath = configuration["ResumeSettings:SavePath"];
            _candidateResumeResponseTemplate = configuration["CandidateResumeResponseTemplate"];
            _openAiCandidateResumePrompt = configuration["OpenAIJobdescriptionConfig:CandidateResumePrompt"];
            _candidateSignupSoapUrl = configuration["BulkResumeSignup:CreateNewUserSoapUrl"];
            _candidateSignupDefaultPassword = configuration["BulkResumeSignup:DefaultPassword"];
        }

        [HttpPost("bulk-resume-upload-score-ats-generate")]
        public async Task<IActionResult> BulkResumeUploadScoreATSGenerate([FromForm] int postId, [FromForm] List<IFormFile> resumes)
        {
            try
            {
                if (resumes == null || resumes.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Please upload at least one resume."
                    });
                }

                var parameters = new Dictionary<string, object>
                {
                    { "@postId", postId }
                };

                DataTable dt = await _dataService.GetDataAsync("SP_ATS_GetJobDescriptionByPostId", parameters, _connectionString);

                if (dt.Rows.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Job post not found."
                    });
                }

                string profileJson = dt.Rows[0]["JobDescription"]?.ToString();

                if (string.IsNullOrWhiteSpace(profileJson))
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Job description not found."
                    });
                }

                var profileData = JsonConvert.DeserializeObject<List<ATSJobDescription>>(profileJson);

                if (profileData == null || !profileData.Any())
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Invalid Job Description JSON."
                    });
                }

                ATSJobDescription jobDescription = profileData.First();
                int examTaggingId = jobDescription.ExamTaggingID;
                int atsHeadRatingId = jobDescription.ATS_HEAD_RATING_ID;
                int companyId = jobDescription.CompanyID;
                string companyName = jobDescription.COMPANY_NAME;
                int PostID = jobDescription.PostID;
                string postName = jobDescription.POST;

                if (examTaggingId == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Exam is not tagged for this job post."
                    });
                }

                if (atsHeadRatingId == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "ATS Rating configuration is not mapped for this job post."
                    });
                }

                string uploadFolder = System.IO.Path.Combine(Directory.GetCurrentDirectory(), _resumeSavePath);

                if (!Directory.Exists(uploadFolder))
                    Directory.CreateDirectory(uploadFolder);

                var results = new List<object>();

                foreach (IFormFile resume in resumes)
                {
                    if (resume == null || resume.Length == 0)
                    {
                        results.Add(new
                        {
                            FileName = resume?.FileName,
                            Success = false,
                            Message = "Empty resume file skipped."
                        });
                        continue;
                    }

                    string extension = _helper.GetFileExtensionFromName(resume.FileName);
                    string safeOriginalName = SanitizeFileName(System.IO.Path.GetFileNameWithoutExtension(resume.FileName));
                    string savedFileName = $"{safeOriginalName}_{Guid.NewGuid():N}{extension}";
                    string savedFilePath = System.IO.Path.Combine(uploadFolder, savedFileName);

                    await using (var stream = new FileStream(savedFilePath, FileMode.Create))
                    {
                        await resume.CopyToAsync(stream);
                    }

                    string fileHash = await ComputeFileHashAsync(savedFilePath);
                    JObject existingResume = await GetExistingBulkResumeByHashAsync(postId, fileHash);

                    if (existingResume != null)
                    {
                        long? duplicateOfLogId = existingResume["BulkResumeAtsScoreLogID"]?.Value<long?>();
                        var duplicateJson = new JObject
                        {
                            ["message"] = "Duplicate CV upload skipped. Existing ATS score log found for the same post and file hash.",
                            ["duplicateOfLogId"] = duplicateOfLogId,
                            ["existingCvName"] = existingResume["CV_NAME"],
                            ["existingSavedCvName"] = existingResume["SAVED_CV_NAME"],
                            ["existingStatus"] = existingResume["ATS_STATUS"],
                            ["fileHash"] = fileHash
                        };

                        await SaveBulkResumeAtsScoreAsync(postId,resume.FileName,savedFileName,fileHash,null,null,null,"Duplicate",false,duplicateJson,null,true,duplicateOfLogId);

                        results.Add(new
                        {
                            FileName = resume.FileName,
                            Success = true,
                            SavedFile = savedFileName,
                            Status = "Duplicate",
                            IsDuplicate = true,
                            FileHash = fileHash,
                            DuplicateOfLogId = duplicateOfLogId,
                            Message = "Duplicate CV upload skipped."
                        });

                        DeleteTempFile(savedFilePath);
                        continue;
                    }

                    string resumeText = await _helper.ExtractTextAsync(savedFilePath);

                    if (string.IsNullOrWhiteSpace(resumeText) || resumeText.StartsWith("[Unsupported", StringComparison.OrdinalIgnoreCase))
                    {
                        var extractionFailedJson = new JObject
                        {
                            ["message"] = "Resume text could not be extracted.",
                            ["reason"] = resumeText,
                            ["fileHash"] = fileHash
                        };
                        await SaveBulkResumeAtsScoreAsync(postId, resume.FileName, savedFileName, fileHash, null, null, null, "ExtractionFailed", false, extractionFailedJson, null, false, null);


                        results.Add(new
                        {
                            FileName = resume.FileName,
                            Success = false,
                            SavedFile = savedFileName,
                            Status = "ExtractionFailed",
                            IsDuplicate = false,
                            FileHash = fileHash,
                            Message = "Resume text could not be extracted."
                        });

                        DeleteTempFile(savedFilePath);
                        continue;
                    }

                    JObject candidateJson = await ParseCandidateResumeJsonAsync(resumeText);
                    string candidateName = GetCandidateName(candidateJson);
                    string mailId = GetJsonString(candidateJson, "Email");
                    string phoneNumber = GetJsonString(candidateJson, "Mobile");
                    JObject existingCandidate = await GetExistingCandidateByUsernameOrMailAsync(mailId, mailId);

                    if (existingCandidate != null)
                    {
                        var candidateAlreadyExistsJson = new JObject
                        {
                            ["message"] = "Candidate already exists. ATS score generation skipped.",
                            ["existingCandidate"] = existingCandidate,
                            ["fileHash"] = fileHash
                        };

                        await SaveBulkResumeAtsScoreAsync(postId, resume.FileName, savedFileName, fileHash, candidateName, mailId, phoneNumber, "CandidateAlreadyExists", false, candidateAlreadyExistsJson, candidateJson, false, null);

                        results.Add(new
                        {
                            FileName = resume.FileName,
                            Success = true,
                            SavedFile = savedFileName,
                            Status = "CandidateAlreadyExists",
                            IsDuplicate = false,
                            FileHash = fileHash,
                            CandidateName = candidateName,
                            MailId = mailId,
                            PhoneNumber = phoneNumber,
                            ExistingCandidate = existingCandidate,
                            Message = "Candidate already exists. ATS score generation skipped."
                        });

                        DeleteTempFile(savedFilePath);
                        continue;
                    }

                    AtsPromptResult promptResult = await GenerateBulkPromptFromAtsHeadRatingAsync(atsHeadRatingId, jobDescription, resumeText);
                    string scoreResponse = await _helper.SendMessageAsync(promptResult.Prompt, _gptApi);
                    JObject scoreJson = CleanAndParseJson(scoreResponse);
                    string atsStatus = scoreJson["Status"]?.ToString();
                    bool isShortlisted = IsAtsShortlisted(scoreJson);

                    JObject signupResult = null;

                    if (isShortlisted)
                    {
                        signupResult = await CreateShortlistedCandidateBySoapAsync(candidateJson, jobDescription);
                        scoreJson["ShortlistedSignupResult"] = signupResult;
                        candidateJson["ShortlistedSignupResult"] = signupResult;
                    }

                    await SaveBulkResumeAtsScoreAsync(postId, resume.FileName, savedFileName, fileHash, candidateName, mailId, phoneNumber, atsStatus, isShortlisted, scoreJson, candidateJson, false, null);

                    results.Add(new
                    {
                        FileName = resume.FileName,
                        Success = true,
                        SavedFile = savedFileName,
                        ATSScore = scoreJson,
                        CandidateJson = candidateJson,
                        Status = atsStatus,
                        IsDuplicate = false,
                        FileHash = fileHash,
                        CandidateName = candidateName,
                        MailId = mailId,
                        PhoneNumber = phoneNumber,
                        IsShortlisted = isShortlisted,
                        ShortlistedSignupResult = signupResult
                    });

                    DeleteTempFile(savedFilePath);
                }

                return Ok(new
                {
                    Success = true,
                    PostId = postId,
                    ExamTaggingID = examTaggingId,
                    ATSHeadRatingID = atsHeadRatingId,
                    Message = "ATS processing completed.",
                    Results = results
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    Success = false,
                    Message = ex.Message
                });
            }
        }

        private async Task SaveBulkResumeAtsScoreAsync(int postId,string originalCvName,string savedCvName,string fileHash,string candidateName,string mailId,string phoneNumber,string status,bool isShortlisted,JObject scoreJson,JObject candidateJson,bool isDuplicate,long? duplicateOfLogId)
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
                { "@ATS_STATUS", status ?? string.Empty },
                { "@IS_SHORTLISTED", isShortlisted },
                { "@FULL_JSON", scoreJson?.ToString(Formatting.None) ?? string.Empty },
                { "@CANDIDATE_JSON", candidateJson?.ToString(Formatting.None) ?? string.Empty },
                { "@IS_DUPLICATE", isDuplicate },
                { "@DUPLICATE_OF_LOG_ID", duplicateOfLogId.HasValue ? duplicateOfLogId.Value : DBNull.Value }
            };

            await _dataService.AddAsync("PRC_SAVE_BULK_RESUME_ATS_SCORE",parameters,_connectionString);
        }

        private async Task<JObject> GetExistingCandidateByUsernameOrMailAsync(string username, string mailId)
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

            var result = new JObject();

            foreach (DataColumn column in dt.Columns)
            {
                object value = dt.Rows[0][column];
                result[column.ColumnName] = value == DBNull.Value ? null : JToken.FromObject(value);
            }

            return result;
        }

        private async Task<JObject> GetExistingBulkResumeByHashAsync(int postId, string fileHash)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@POST_ID", postId },
                { "@FILE_HASH", fileHash }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_GET_BULK_RESUME_ATS_BY_HASH",parameters,_connectionString);

            if (dt.Rows.Count == 0)
                return null;

            var result = new JObject();

            foreach (DataColumn column in dt.Columns)
            {
                object value = dt.Rows[0][column];
                result[column.ColumnName] = value == DBNull.Value ? null : JToken.FromObject(value);
            }

            return result;
        }

        private async Task<string> ComputeFileHashAsync(string filePath)
        {
            await using FileStream stream = System.IO.File.OpenRead(filePath);
            byte[] hashBytes = await SHA256.HashDataAsync(stream);
            return Convert.ToHexString(hashBytes);
        }

        private void DeleteTempFile(string filePath)
        {
            if (string.IsNullOrWhiteSpace(filePath) || !System.IO.File.Exists(filePath))
                return;

            try
            {
                System.IO.File.Delete(filePath);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error deleting temp resume file '{filePath}': {ex.Message}");
            }
        }

        private async Task<AtsPromptResult> GenerateBulkPromptFromAtsHeadRatingAsync(int atsHeadRatingId, ATSJobDescription jobDescription, string resumeText)
        {
            var result = new AtsPromptResult();

            try
            {
                var parameters = new Dictionary<string, object>
                {
                    { "@ATS_HEAD_RATING_ID", atsHeadRatingId }
                };

                DataTable dt = await _dataService.GetDataAsync("SP_ATS_PROMT_BY_HEAD_RATING_ID",parameters,_connectionString);

                if (dt.Rows.Count == 0 || dt.Rows[0]["AtsPrompt"] == DBNull.Value)
                {
                    result.Prompt = JsonConvert.SerializeObject(
                        new { error = "No ATS rating prompt data returned from stored procedure." }
                    );
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

                string resultRules = string.Join(", ",
                    resultStatusArray.Select(x => $"{x.Key}:{x.Value}")
                );

                string statusOptions = string.Join(", ",
                    resultStatusArray.Select(x => $"\"{x.Key}\"")
                );

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

        private async Task<JObject> ParseCandidateResumeJsonAsync(string resumeText)
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

        private async Task<JObject> CreateShortlistedCandidateBySoapAsync(JObject candidateJson, ATSJobDescription jobDescription)
        {
            var result = new JObject
            {
                ["Success"] = false,
                ["Message"] = string.Empty,
                ["CandidateId"] = null
            };

            if (string.IsNullOrWhiteSpace(_candidateSignupSoapUrl))
            {
                result["Message"] = "BulkResumeSignup:CreateNewUserSoapUrl is not configured.";
                return result;
            }

            string email = GetJsonString(candidateJson, "Email");
            string mobile = GetJsonString(candidateJson, "Mobile");
            string username = !string.IsNullOrWhiteSpace(email) ? email : mobile;
            string password = !string.IsNullOrWhiteSpace(_candidateSignupDefaultPassword)
                ? _candidateSignupDefaultPassword
                : mobile;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(email))
            {
                result["Message"] = "Candidate email is required for CreateNewUser.";
                return result;
            }

            if (string.IsNullOrWhiteSpace(password))
            {
                result["Message"] = "Candidate password could not be prepared. Configure BulkResumeSignup:DefaultPassword or ensure Mobile is extracted.";
                return result;
            }

            try
            {
                string endpoint = NormalizeAsmxEndpoint(_candidateSignupSoapUrl);
                string soapEnvelope = BuildCreateNewUserSoapEnvelope(
                    username,
                    email,
                    password,
                    jobDescription.COMPANY_NAME ?? string.Empty,
                    jobDescription.POST ?? string.Empty,
                    jobDescription.CompanyID,
                    jobDescription.PostID
                );

                using var client = new HttpClient();
                using var request = new HttpRequestMessage(HttpMethod.Post, endpoint);
                request.Headers.Add("SOAPAction", "\"http://tempuri.org/CreateNewUser\"");
                request.Content = new StringContent(soapEnvelope, Encoding.UTF8, "text/xml");

                using HttpResponseMessage response = await client.SendAsync(request);
                string responseText = await response.Content.ReadAsStringAsync();

                result["HttpStatusCode"] = (int)response.StatusCode;
                result["RawResponse"] = responseText;

                if (!response.IsSuccessStatusCode)
                {
                    result["Message"] = $"CreateNewUser SOAP call failed with HTTP {(int)response.StatusCode}.";
                    return result;
                }

                string createUserResult = ExtractSoapResult(responseText, "CreateNewUserResult");
                result["CreateNewUserResult"] = createUserResult;

                if (long.TryParse(createUserResult, out long candidateId) && candidateId > 0)
                {
                    result["Success"] = true;
                    result["CandidateId"] = candidateId;
                    result["Message"] = "Shortlisted candidate created successfully.";
                    return result;
                }

                result["Message"] = string.IsNullOrWhiteSpace(createUserResult)
                    ? "CreateNewUser did not return a candidate id."
                    : createUserResult;

                return result;
            }
            catch (Exception ex)
            {
                result["Message"] = $"CreateNewUser SOAP call error: {ex.Message}";
                return result;
            }
        }

        private string BuildCreateNewUserSoapEnvelope(string username, string email, string password, string company, string post, long companyId, long postId)
        {
            return $@"<?xml version=""1.0"" encoding=""utf-8""?>
<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">
  <soap:Body>
    <CreateNewUser xmlns=""http://tempuri.org/"">
      <Username>{WebUtility.HtmlEncode(username)}</Username>
      <Email>{WebUtility.HtmlEncode(email)}</Email>
      <Password>{WebUtility.HtmlEncode(password)}</Password>
      <Company>{WebUtility.HtmlEncode(company)}</Company>
      <Post>{WebUtility.HtmlEncode(post)}</Post>
      <IDCompany>{companyId}</IDCompany>
      <IDPost>{postId}</IDPost>
    </CreateNewUser>
  </soap:Body>
</soap:Envelope>";
        }

        private string ExtractSoapResult(string responseText, string resultElementName)
        {
            if (string.IsNullOrWhiteSpace(responseText))
                return string.Empty;

            XDocument document = XDocument.Parse(responseText);
            return document
                .Descendants()
                .FirstOrDefault(x => x.Name.LocalName == resultElementName)
                ?.Value
                ?.Trim() ?? string.Empty;
        }

        private string NormalizeAsmxEndpoint(string endpoint)
        {
            int asmxIndex = endpoint.IndexOf(".asmx", StringComparison.OrdinalIgnoreCase);

            if (asmxIndex >= 0)
                return endpoint.Substring(0, asmxIndex + ".asmx".Length);

            return endpoint;
        }

        private string GetJsonString(JObject json, string propertyName)
        {
            return json?[propertyName]?.ToString()?.Trim() ?? string.Empty;
        }

        private string GetCandidateName(JObject candidateJson)
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

        private JObject CleanAndParseJson(string rawJson)
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

            return JObject.Parse(cleanedJson);
        }

        private bool IsAtsShortlisted(JObject scoreJson)
        {
            string status = scoreJson["Status"]?.ToString();
            bool recommended = scoreJson["RecommendedForATSShortlisting"]?.Value<bool?>() ?? false;

            return recommended ||
                   (!string.IsNullOrWhiteSpace(status) &&
                    status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase));
        }

        private string SanitizeFileName(string fileName)
        {
            if (string.IsNullOrWhiteSpace(fileName))
                return "resume";

            foreach (char invalidChar in System.IO.Path.GetInvalidFileNameChars())
            {
                fileName = fileName.Replace(invalidChar, '_');
            }

            return fileName.Trim();
        }
    }

}
