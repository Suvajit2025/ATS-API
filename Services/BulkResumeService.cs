using ATS.API.Controllers;
using ATS.API.Interface;
using ATS.API.Models;
using ATS.API.Repository;
using CommonUtility.Interface;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Concurrent;
using System.Data;
using System.IO.Compression;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using MailSender = ATS.API.Services.MailService.MailService;

namespace ATS.API.Services
{
    public class BulkResumeService
    {
        private static readonly ConcurrentDictionary<string, byte> _activeProcessingHashes = new(StringComparer.OrdinalIgnoreCase);

        private readonly IDataService _dataService;
        private readonly IATSHelper _helper;
        private readonly string _connectionString;
        private readonly string _gptApi;
        private readonly string _resumeSavePath;
        private readonly string _bulkResumeSavePath;
        private readonly string _bulkResumeFileUrl;
        private readonly string _bulkProfilePicSavePath;
        private readonly string _bulkProfilePicUrl;
        private readonly string _candidateResumeResponseTemplate;
        private readonly string _openAiCandidateResumePrompt;
        private readonly string _candidateSignupUrl;
        private readonly MailSender _mailService;
        private readonly FtpStorageService _ftpStorage;
        private readonly string _ftpResumeFolder;
        private readonly string _ftpProfilePicFolder;

        public BulkResumeService(
            IDataService dataService, 
            IATSHelper atsHelper, 
            IConfiguration configuration, 
            MailSender mailService,
            FtpStorageService ftpStorage)
        {
            _dataService = dataService;
            _helper = atsHelper;
            _connectionString = configuration.GetConnectionString("DBConnRecruitment");
            _gptApi = configuration["GptAPI"];
            _resumeSavePath = configuration["ResumeSettings:SavePath"];
            _bulkResumeSavePath = configuration["ResumeSettings:BulkResumeSavePath"] ?? _resumeSavePath;
            _bulkResumeFileUrl = configuration["ResumeSettings:BulkResumeFileUrl"] ?? configuration["ResumeSettings:fileUrl"] ?? string.Empty;
            _bulkProfilePicSavePath = configuration["ResumeSettings:BulkProfilePicSavePath"] ?? string.Empty;
            _bulkProfilePicUrl = configuration["ResumeSettings:BulkProfilePicUrl"] ?? string.Empty;
            _candidateResumeResponseTemplate = configuration["CandidateResumeResponseTemplate"];
            _openAiCandidateResumePrompt = configuration["OpenAIJobdescriptionConfig:CandidateResumePrompt"];
            _candidateSignupUrl = configuration["BulkResumeSignup:RegisterCandidateUrl"]
                ?? configuration["BulkResumeSignup:CreateNewUserSoapUrl"];
            _mailService = mailService;
            _ftpStorage = ftpStorage;
            _ftpResumeFolder = configuration["FtpSettings:ResumeRemotePath"] ?? "/Documents/Resume";
            _ftpProfilePicFolder = configuration["FtpSettings:ProfilePicRemotePath"] ?? "/Documents/Profilepic";
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
            if (_ftpStorage.IsFtpEnabled)
            {
                string tempFolder = Path.Combine(Directory.GetCurrentDirectory(), "TempFiles", "Resumes");
                if (!Directory.Exists(tempFolder)) Directory.CreateDirectory(tempFolder);
                return tempFolder;
            }

            string uploadFolder = GetConfiguredFolder(_bulkResumeSavePath);
            EnsureWritableFolder(uploadFolder, "ResumeSettings:BulkResumeSavePath");
            return uploadFolder;
        }

        public string GetProfilePicFolder()
        {
            if (_ftpStorage.IsFtpEnabled)
            {
                string tempFolder = Path.Combine(Directory.GetCurrentDirectory(), "TempFiles", "ProfilePics");
                if (!Directory.Exists(tempFolder)) Directory.CreateDirectory(tempFolder);
                return tempFolder;
            }

            string profilePicFolder = GetConfiguredFolder(_bulkProfilePicSavePath);
            EnsureWritableFolder(profilePicFolder, "ResumeSettings:BulkProfilePicSavePath");
            return profilePicFolder;
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

            FileInfo savedFile = new FileInfo(savedFilePath);
            if (!savedFile.Exists || savedFile.Length == 0)
                throw new IOException($"Resume file was not saved correctly at '{savedFilePath}'.");

            // If FTP is enabled, upload copy to FTP server
            if (_ftpStorage.IsFtpEnabled)
            {
                byte[] resumeBytes = await File.ReadAllBytesAsync(savedFilePath);
                await _ftpStorage.UploadFileBytesAsync(_ftpResumeFolder, savedFileName, resumeBytes);
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

        public async Task<long?> SaveBulkResumeAtsScoreAsync(int postId, int companyId, int departmentId, string originalCvName, string savedCvName, string fileHash, string candidateName, string mailId, string phoneNumber, int atsHeadRatingId, long? generatedCandidateId, string status, bool isShortlisted, JObject scoreJson, JObject candidateJson, bool isDuplicate, long? duplicateOfLogId, string imageFileLocation = "", string imageName = "", long candidateId = 0, int locationId = 0)
        {
            string resumeFileLocation = string.IsNullOrWhiteSpace(savedCvName)
                ? string.Empty
                : BuildPublicFileLocation(_bulkResumeFileUrl, savedCvName);

            var parameters = new Dictionary<string, object>
            {
                { "@BulkResumeAtsScoreLogID", candidateId > 0 ? (object)candidateId : DBNull.Value },
                { "@POST_ID", postId },
                { "@COMPANY_ID", companyId },
                { "@DEPARTMENT_ID", departmentId },
                { "@LOCATION_ID", locationId },
                { "@CV_NAME", originalCvName ?? string.Empty },
                { "@SAVED_CV_NAME", savedCvName ?? string.Empty },
                { "@RESUME_FILE_LOCATION", resumeFileLocation },
                { "@IMAGE_FILE_LOCATION", imageFileLocation ?? string.Empty },
                { "@IMAGE_NAME", imageName ?? string.Empty },
                { "@FILE_HASH", fileHash ?? string.Empty },
                { "@CANDIDATE_NAME", candidateName ?? string.Empty },
                { "@MAIL_ID", mailId ?? string.Empty },
                { "@PHONE_NUMBER", phoneNumber ?? string.Empty },
                { "@ATS_HEAD_RATING_ID", atsHeadRatingId == 0 ? DBNull.Value : atsHeadRatingId },
                { "@GENERATED_CANDIDATE_ID", generatedCandidateId.HasValue && generatedCandidateId.Value > 0 ? generatedCandidateId.Value : DBNull.Value },
                { "@ATS_STATUS", status ?? string.Empty },
                { "@IS_SHORTLISTED", isShortlisted },
                { "@FULL_JSON", scoreJson?.ToString(Formatting.None) ?? string.Empty },
                { "@CANDIDATE_JSON", candidateJson?.ToString(Formatting.None) ?? string.Empty },
                { "@IS_DUPLICATE", isDuplicate },
                { "@DUPLICATE_OF_LOG_ID", duplicateOfLogId.HasValue ? duplicateOfLogId.Value : DBNull.Value }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_SAVE_BULK_RESUME_ATS_SCORE", parameters, _connectionString);

            // Defensive ensure status update via dedicated stored procedure if updating existing record
            if (candidateId > 0)
            {
                try
                {
                    await UpdateBulkResumeAtsStatusAsync(candidateId, status, isShortlisted, isDuplicate, duplicateOfLogId);
                }
                catch
                {
                    // Ignore fallback update errors if SP is still provisioning
                }
            }

            if (dt.Rows.Count == 0 || dt.Rows[0]["BulkResumeAtsScoreLogID"] == DBNull.Value)
                return candidateId > 0 ? candidateId : null;

            return Convert.ToInt64(dt.Rows[0]["BulkResumeAtsScoreLogID"]);
        }

        public async Task<bool> UpdateBulkResumeAtsStatusAsync(long bulkResumeAtsScoreLogId, string status, bool isShortlisted, bool isDuplicate, long? duplicateOfLogId = null)
        {
            if (bulkResumeAtsScoreLogId <= 0) return false;

            var parameters = new Dictionary<string, object>
            {
                { "@BulkResumeAtsScoreLogID", bulkResumeAtsScoreLogId },
                { "@ATS_STATUS", status ?? string.Empty },
                { "@IS_SHORTLISTED", isShortlisted },
                { "@IS_DUPLICATE", isDuplicate },
                { "@DUPLICATE_OF_LOG_ID", duplicateOfLogId.HasValue ? (object)duplicateOfLogId.Value : DBNull.Value }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_UPDATE_BULK_RESUME_ATS_STATUS", parameters, _connectionString);
            return dt.Rows.Count > 0;
        }

        public async Task<string> SaveBulkProfilePicAsync(IFormFile? photo)
        {
            if (photo == null || photo.Length == 0)
                return string.Empty;

            string extension = Path.GetExtension(photo.FileName);

            if (string.IsNullOrWhiteSpace(extension))
                extension = ".jpg";

            string savedImageFileName = $"profile_{Guid.NewGuid():N}{extension}";

            if (_ftpStorage.IsFtpEnabled)
            {
                using var ms = new MemoryStream();
                await photo.CopyToAsync(ms);
                await _ftpStorage.UploadFileBytesAsync(_ftpProfilePicFolder, savedImageFileName, ms.ToArray());
            }
            else
            {
                string savedImagePath = Path.Combine(GetProfilePicFolder(), savedImageFileName);

                await using (var stream = new FileStream(savedImagePath, FileMode.Create))
                {
                    await photo.CopyToAsync(stream);
                }
            }

            return BuildBulkProfilePicLocation(savedImageFileName);
        }

        public string BuildBulkProfilePicLocation(string savedImageFileName)
        {
            return BuildPublicFileLocation(_bulkProfilePicUrl, savedImageFileName);
        }

        public async Task<string> SaveBulkProfilePicFromBase64Async(string base64Data, string preferredExtension = ".jpg")
        {
            if (string.IsNullOrWhiteSpace(base64Data))
                return string.Empty;

            try
            {
                string cleanBase64 = base64Data.Trim();
                string extension = preferredExtension;

                if (cleanBase64.Contains(","))
                {
                    var parts = cleanBase64.Split(',', 2);
                    string header = parts[0];
                    cleanBase64 = parts[1];

                    if (header.Contains("image/png", StringComparison.OrdinalIgnoreCase))
                        extension = ".png";
                    else if (header.Contains("image/jpeg", StringComparison.OrdinalIgnoreCase) || header.Contains("image/jpg", StringComparison.OrdinalIgnoreCase))
                        extension = ".jpg";
                    else if (header.Contains("image/webp", StringComparison.OrdinalIgnoreCase))
                        extension = ".webp";
                }

                byte[] imageBytes = Convert.FromBase64String(cleanBase64);
                if (imageBytes.Length == 0)
                    return string.Empty;

                string savedImageFileName = $"profile_{Guid.NewGuid():N}{extension}";

                if (_ftpStorage.IsFtpEnabled)
                {
                    await _ftpStorage.UploadFileBytesAsync(_ftpProfilePicFolder, savedImageFileName, imageBytes);
                }
                else
                {
                    string savedImagePath = Path.Combine(GetProfilePicFolder(), savedImageFileName);
                    await File.WriteAllBytesAsync(savedImagePath, imageBytes);
                }

                return BuildBulkProfilePicLocation(savedImageFileName);
            }
            catch
            {
                return string.Empty;
            }
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
                { "@CANDIDATE_ID", generatedCandidateId.HasValue && generatedCandidateId.Value > 0 ? generatedCandidateId.Value : DBNull.Value }
            };

            await _dataService.AddAsync("PRC_UPDATE_BULK_RESUME_ATS_SCORE", parameters, _connectionString);
        }

        public async Task<JObject> GetExistingCandidateByUsernameOrMailAsync(string username, string mailId, int postId = 0)
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

        public async Task<JObject> GetExistingBulkResumeByHashAsync(int postId, string fileHash, int locationId = 0)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@POST_ID", postId },
                { "@LOCATION_ID", locationId > 0 ? locationId : DBNull.Value },
                { "@FILE_HASH", fileHash }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_GET_BULK_RESUME_ATS_BY_HASH", parameters, _connectionString);

            if (dt.Rows.Count == 0)
                return null;

            return ConvertFirstRowToJson(dt);
        }

        public async Task<JObject> GetBulkResumeAtsScoreLogByIdAsync(long bulkResumeAtsScoreLogId)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@BulkResumeAtsScoreLogID", bulkResumeAtsScoreLogId }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_GET_BULK_RESUME_ATS_BY_ID", parameters, _connectionString);

            if (dt.Rows.Count == 0)
                return null;

            return ConvertFirstRowToJson(dt);
        }

        public async Task<List<Dictionary<string, object?>>> GetBulkResumeAtsReportAsync(int? companyId, int? departmentId, int? postId, int? locationId, string keyword, DateTime? fromDate, DateTime? toDate, int take)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@COMPANY_ID", companyId.HasValue && companyId.Value > 0 ? companyId.Value : DBNull.Value },
                { "@DEPARTMENT_ID", departmentId.HasValue && departmentId.Value > 0 ? departmentId.Value : DBNull.Value },
                { "@POST_ID", postId.HasValue && postId.Value > 0 ? postId.Value : DBNull.Value },
                { "@LOCATION_ID", locationId.HasValue && locationId.Value > 0 ? locationId.Value : DBNull.Value },
                { "@KEYWORD", string.IsNullOrWhiteSpace(keyword) ? DBNull.Value : keyword.Trim() },
                { "@FROM_DATE", fromDate.HasValue ? fromDate.Value : DBNull.Value },
                { "@TO_DATE", toDate.HasValue ? toDate.Value : DBNull.Value },
                { "@TAKE", take <= 0 ? 500 : take }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_GET_BULK_RESUME_ATS_REPORT", parameters, _connectionString);
            return ConvertDataTableToDictionaryList(dt);
        }

        public async Task<List<Dictionary<string, object?>>> GetBulkResumeCompanyListAsync()
        {
            DataTable dt = await _dataService.GetDataAsync("PRC_Receruitment_Company_List", new Dictionary<string, object>(), _connectionString);
            return ConvertDataTableToDictionaryList(dt);
        }

        public async Task<List<Dictionary<string, object?>>> GetBulkResumeDepartmentListAsync()
        {
            DataTable dt = await _dataService.GetDataAsync("PRC_Receruitment_DepartmentList", new Dictionary<string, object>(), _connectionString);
            return ConvertDataTableToDictionaryList(dt);
        }

        public async Task<List<Dictionary<string, object?>>> GetBulkResumePostListAsync(int? companyId = null, int? departmentId = null)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@CompanyID", companyId.HasValue && companyId.Value > 0 ? companyId.Value : DBNull.Value },
                { "@DepartmentID", departmentId.HasValue && departmentId.Value > 0 ? departmentId.Value : DBNull.Value }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_Receruitment_PostList", parameters, _connectionString);
            return ConvertDataTableToDictionaryList(dt);
        }

        public async Task UpdateBulkResumeExamResultAsync(long bulkResumeAtsScoreLogId, decimal examObtainedScore, bool examIsShortlisted, long? generatedCandidateId)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@BulkResumeAtsScoreLogID", bulkResumeAtsScoreLogId },
                { "@EXAM_OBTAINED_SCORE", examObtainedScore },
                { "@EXAM_IS_SHORTLISTED", examIsShortlisted },
                { "@GENERATED_CANDIDATE_ID", generatedCandidateId.HasValue && generatedCandidateId.Value > 0 ? generatedCandidateId.Value : DBNull.Value }
            };

            await _dataService.AddAsync("PRC_UPDATE_BULK_RESUME_EXAM_RESULT", parameters, _connectionString);
        }

        public async Task<bool> RecruitmentCandidateExistsAsync(long candidateId)
        {
            if (candidateId <= 0)
                return false;

            DataTable dt = await GetRecruitmentCandidateSignupByIdAsync(candidateId);
            return dt.Rows.Count > 0;
        }

        public async Task SaveLmsExamResultToHeadAtsScoreAsync(long candidateId, decimal examObtainedScore, bool examIsShortlisted)
        {
            /*
             * Existing recruitment candidate flow:
             * The real CandidateId is confirmed from trecruitcandidatesignup first.
             * Candidate detail fields are used only to populate post/location/company
             * metadata for HEAD_ATS_SCORE when they are available. LMS exam result
             * uses its own save/update SP because it only touches HEAD_ATS_SCORE,
             * not DTLS_ATS_SCORE breakdown rows.
             */
            DataTable signupCandidate = await GetRecruitmentCandidateSignupByIdAsync(candidateId);

            if (signupCandidate.Rows.Count == 0)
                throw new Exception("Candidate id was not found in trecruitcandidatesignup.");

            int postId = 0;
            int locId = 0;
            int companyId = 0;
            int departmentId = 0;
            DataTable candidateDetails = await GetRecruitmentCandidateDetailsAsync(candidateId);

            if (candidateDetails.Rows.Count > 0)
            {
                DataRow candidate = candidateDetails.Rows[0];
                postId = GetIntValue(candidate, "ActualPostID");
                locId = GetIntValue(candidate, "locId");
                companyId = GetIntValue(candidate, "companyId");
                departmentId = GetIntValue(candidate, "Departmentid");
            }

            string examStatus = examIsShortlisted ? "Passed" : "Failed";

            var insertParams = new Dictionary<string, object>
            {
                { "@CANDIDATE_ID", candidateId },
                { "@POST_ID", postId },
                { "@LOCATION_ID", locId },
                { "@COMPANY_ID", companyId },
                { "@DEPARTMENT_ID", departmentId },
                { "@ExamMarks", examObtainedScore },
                { "@ExamStatus", examStatus }
            };

            await _dataService.AddAsync("SP_SAVE_LMS_EXAM_RESULT_ATS_SCORE", insertParams, _connectionString);
        }

        private async Task<DataTable> GetRecruitmentCandidateSignupByIdAsync(long candidateId)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@CandidateID", candidateId }
            };

            return await _dataService.GetDataAsync("PRC_CHECK_RECRUIT_CANDIDATE_SIGNUP_BY_ID", parameters, _connectionString);
        }

        private async Task<DataTable> GetRecruitmentCandidateDetailsAsync(long candidateId)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@CandidateId", candidateId }
            };

            return await _dataService.GetDataAsync("SP_ATS_GETCANDIDATEDETAIL", parameters, _connectionString);
        }

        public async Task SaveTempCandidateDetailsAsync(long candidateId, JObject candidateJson, string resumeFileName, string originalFileName = "", byte[]? resumeBytes = null, string contentType = "")
        {
            byte[] fileBytes = resumeBytes ?? Array.Empty<byte>();
            string displayFileName = !string.IsNullOrWhiteSpace(originalFileName) ? originalFileName : resumeFileName;

            if ((fileBytes == null || fileBytes.Length == 0) && !string.IsNullOrWhiteSpace(resumeFileName))
            {
                string uploadFolder = GetUploadFolder();
                string filePath = Path.Combine(uploadFolder, resumeFileName);
                if (File.Exists(filePath))
                {
                    try
                    {
                        fileBytes = await File.ReadAllBytesAsync(filePath);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error reading resume file for candidate {candidateId}: {ex.Message}");
                    }
                }
            }

            if (string.IsNullOrWhiteSpace(contentType) && !string.IsNullOrWhiteSpace(displayFileName))
            {
                contentType = GetContentTypeFromFileName(displayFileName);
            }

            var parameters = new Dictionary<string, object>
            {
                { "@CandidateID", candidateId },
                { "@CandidateFirstName", GetJsonString(candidateJson, "CandidateFirstName") },
                { "@CandidateMiddleName", GetJsonString(candidateJson, "CandidateMiddleName") },
                { "@CandidateLastName", GetJsonString(candidateJson, "CandidateLastName") },
                { "@DateOfBirth", GetJsonString(candidateJson, "DateOfBirth") },
                { "@Address", GetJsonString(candidateJson, "Address") },
                { "@CityOrVillage", GetJsonString(candidateJson, "CityOrVillage") },
                { "@PostOffice", GetJsonString(candidateJson, "PostOffice") },
                { "@PinCode", GetJsonString(candidateJson, "PinCode") },
                { "@Country", GetJsonString(candidateJson, "Country") },
                { "@State", GetJsonString(candidateJson, "State") },
                { "@District", GetJsonString(candidateJson, "District") },
                { "@Email", GetJsonString(candidateJson, "Email") },
                { "@Mobile", GetJsonString(candidateJson, "Mobile") },
                { "@AnyProject", candidateJson?["AnyProject"]?.ToString(Formatting.None) ?? string.Empty },
                { "@NumberOfCompanyChanges", GetJsonString(candidateJson, "NumberOfCompanyChanges") },
                { "@ResumeContentType", contentType ?? string.Empty },
                { "@ResumeFileName", displayFileName ?? string.Empty },
                { "@ResumeFile", fileBytes ?? Array.Empty<byte>() },
                { "@QualificationJison", candidateJson?["Qualification"]?.ToString(Formatting.None) ?? "[]" }
            };

            await _dataService.AddAsync("PRC_SAVE_BULK_RESUME_TEMP_CANDIDATE_DETAILS", parameters, _connectionString);
        }

        private string GetContentTypeFromFileName(string fileName)
        {
            if (string.IsNullOrWhiteSpace(fileName))
                return "application/octet-stream";

            string ext = Path.GetExtension(fileName).ToLowerInvariant();
            return ext switch
            {
                ".pdf" => "application/pdf",
                ".docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                ".doc" => "application/msword",
                ".rtf" => "application/rtf",
                ".txt" => "text/plain",
                ".jpg" or ".jpeg" => "image/jpeg",
                ".png" => "image/png",
                _ => "application/octet-stream"
            };
        }

        public async Task<bool> SendCandidateCredentialMailAsync(string mailId, string candidateName, string username, string password, string companyName, string appliedPost)
        {
            if (string.IsNullOrWhiteSpace(mailId))
                return false;

            string subject = "Recruitment Portal Login Credentials";
            string displayName = string.IsNullOrWhiteSpace(candidateName) ? "Candidate" : candidateName;

            string body = $@"
                            <html>
                            <body style=""font-family:Calibri,Arial,sans-serif;font-size:14px;color:#333333;"">

                                Dear <b>{displayName}</b>,
                                <br/><br/>

                                Greetings from <b>{companyName ?? string.Empty}</b>.
                                <br/><br/>

                                <b>Congratulations!</b>
                                <br/><br/>

                                You have been shortlisted for the position of
                                <b>{appliedPost ?? string.Empty}</b>.
                                <br/><br/>

                                Please use the following credentials to log in to the Recruitment Portal:
                                <br/><br/>

                                <table border=""1"" cellpadding=""6"" cellspacing=""0"" style=""border-collapse:collapse;"">
                                    <tr style=""background-color:#f2f2f2;"">
                                        <td><b>Username</b></td>
                                        <td>{username ?? string.Empty}</td>
                                    </tr>
                                    <tr>
                                        <td><b>Password</b></td>
                                        <td>{password ?? string.Empty}</td>
                                    </tr>
                                </table>

                                <br/>

                                <b>Recruitment Portal:</b><br/>
                                    <a href=""https://recruitment.mendine.co.in/Account/Login.aspx"" target=""_blank"">
                                        Click Here to Login
                                    </a>

                                <br/><br/>

                                Kindly log in using the above credentials to continue with the recruitment process.

                                <br/><br/>

                                <b>Note:</b> For security purposes, we recommend changing your password after your first login.

                                <br/><br/>

                                Best Regards,<br/>
                                <b>Recruitment Team</b><br/>
                                {companyName ?? string.Empty}

                            </body>
                            </html>
                    ";

            return await _mailService.SendMailAsync(
                toEmail: mailId,
                fromEmail: null,
                bodyHtml: body,
                subject: subject,
                attachmentBytes: null,
                fileNameWithoutExt: null
            );
        }

        public async Task<string> ComputeFileHashAsync(string filePath)
        {
            await using FileStream stream = File.OpenRead(filePath);
            byte[] hashBytes = await SHA256.HashDataAsync(stream);
            return Convert.ToHexString(hashBytes);
        }

        public async Task<string> ComputeFileHashAsync(IFormFile file)
        {
            if (file == null || file.Length == 0)
                return string.Empty;

            await using Stream stream = file.OpenReadStream();
            byte[] hashBytes = await SHA256.HashDataAsync(stream);
            return Convert.ToHexString(hashBytes);
        }

        public bool IsResumeCurrentlyProcessing(int postId, string fileHash)
        {
            if (postId <= 0 || string.IsNullOrWhiteSpace(fileHash))
                return false;

            string lockKey = $"{postId}_{fileHash}";
            return _activeProcessingHashes.ContainsKey(lockKey);
        }

        public bool TryRegisterActiveProcessingHash(int postId, string fileHash)
        {
            if (postId <= 0 || string.IsNullOrWhiteSpace(fileHash))
                return false;

            string lockKey = $"{postId}_{fileHash}";
            return _activeProcessingHashes.TryAdd(lockKey, 1);
        }

        public void UnregisterActiveProcessingHash(int postId, string fileHash)
        {
            if (postId <= 0 || string.IsNullOrWhiteSpace(fileHash))
                return;

            string lockKey = $"{postId}_{fileHash}";
            _activeProcessingHashes.TryRemove(lockKey, out _);
        }

        public async Task<ResumeSecurityScanResult> ScanResumeFileAsync(string filePath, string originalFileName)
        {
            /*
             * Resume safety scan:
             * This is a lightweight server-side validation before resume parsing.
             * It checks:
             * 1. Allowed resume extensions: PDF, DOC, DOCX.
             * 2. Executable file header.
             * 3. Common script/malware test signatures.
             * 4. Macro or embedded object entries inside DOCX packages.
             *
             * Note:
             * This is not a replacement for enterprise antivirus software.
             * If HR/security needs full malware scanning, integrate an AV engine here.
             */
            var result = new ResumeSecurityScanResult
            {
                IsSafe = true,
                Message = "Resume security scan passed."
            };

            string extension = Path.GetExtension(originalFileName ?? filePath)?.ToLowerInvariant();
            string[] allowedExtensions = { ".pdf", ".doc", ".docx" };

            if (!allowedExtensions.Contains(extension))
            {
                result.IsSafe = false;
                result.Message = "Unsupported resume file format.";
                return result;
            }

            if (string.IsNullOrWhiteSpace(filePath) || !File.Exists(filePath))
            {
                result.IsSafe = false;
                result.Message = "Resume file was not found for security scan.";
                return result;
            }

            byte[] header = new byte[Math.Min(16, (int)new FileInfo(filePath).Length)];
            await using (FileStream stream = File.OpenRead(filePath))
            {
                await stream.ReadAsync(header, 0, header.Length);
            }

            if (header.Length >= 2 && header[0] == 0x4D && header[1] == 0x5A)
            {
                result.IsSafe = false;
                result.Message = "Executable content detected inside uploaded resume.";
                return result;
            }

            if (ContainsBlockedTextSignature(filePath))
            {
                result.IsSafe = false;
                result.Message = "Blocked script or malware test signature detected.";
                return result;
            }

            if (extension == ".docx" && ContainsUnsafeDocxPackageContent(filePath))
            {
                result.IsSafe = false;
                result.Message = "Macro or embedded object content detected in DOCX resume.";
                return result;
            }

            return result;
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

        public async Task<AtsPromptResult> GenerateBulkPromptFromAtsHeadRatingAsync(int atsHeadRatingId, ATSJobDescription jobDescription, string resumeText, JObject candidateJson = null)
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

                string defaultStatus = resultStatusArray.FirstOrDefault()?.Key ?? "Shortlisted";

                string prompt = $@"
                You are an ATS scoring engine. Score the candidate against the job using only the supplied candidate JSON, resume text, JD, and scoring configuration.

                CONFIG
                Total: {totalScore}
                Categories:
                {categoryRules}
                Status rules: {resultRules}

                SCORING CONTRACT
                - Use each configured category name, max score, id, and keywords. Keywords are hints, not mandatory exact matches.
                - Evidence can come from candidate JSON or resume text. JD is only the requirement source.
                - Candidate JSON fields are valid evidence. Use Qualification for education, AnyProject/projects for project/responsibility fit, LanguageKnown for language, Address/CityOrVillage/District/State/Country/PinCode for location, and any resume skills/experience text for skill/experience categories.
                - For location categories, search both candidate JSON and resume text for city/state/country. If candidate location is present but relocation is not stated, award partial marks; if it matches the JD location, award high/full marks.
                - Be moderately flexible for equivalent/related evidence across any role type: qualification, experience, skills, projects, responsibilities, industry/domain, location, language, notice period, CTC, certifications, or other configured criteria.
                - Award partial marks when evidence is relevant but incomplete. Do not make the whole category 0 because one requirement is missing.
                - Use 0 only when no relevant candidate evidence exists for that category.
                - If notes mention positive evidence, obtained must be greater than 0.
                - HARD LIMIT: obtained must always be less than or equal to that category total. Example: if total is 20, obtained cannot be 30; clamp it to 20.
                - Clamp every obtained score: 0 <= obtained <= category total.
                - match_score = sum of obtained scores. percentage = round((match_score / {totalScore}) * 100, 2).
                - Set Status by applying the configured status rules to percentage:
                {statusEvaluationInstructions}
                - Keep notes short and evidence-based. If obtained is 0, notes must be ""No relevant evidence found.""
                - Do not copy placeholder/sample values. Replace every placeholder with evaluated values.

                JOB_DESCRIPTION
                {JsonConvert.SerializeObject(jobDescription, Formatting.None)}

                CANDIDATE_JSON
                {JsonConvert.SerializeObject(candidateJson ?? new JObject(), Formatting.None)}

                RESUME_TEXT
                {resumeText}

                Return raw JSON only:
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

            EnrichResumeLocationFromText(resume, resumeText);
            await EnrichResumeLocationByPinCodeAsync(resume);
            EnrichProfessionalExperience(resume, resumeText);
            EnrichProjects(resume, resumeText);

            return resume;
        }

        public async Task<JObject> RegisterBulkResumeCandidateManuallyAsync(long tempCandidateId, string manualReason = "", int locationId = 0)
        {
            var result = new JObject
            {
                ["Success"] = false,
                ["Message"] = string.Empty,
                ["TempCandidateId"] = tempCandidateId,
                ["CandidateId"] = null
            };

            if (tempCandidateId <= 0)
            {
                result["Message"] = "Temp candidate id is required.";
                return result;
            }

            JObject tempCandidate = await GetBulkResumeAtsScoreLogByIdAsync(tempCandidateId);

            if (tempCandidate == null)
            {
                result["Message"] = "Temp candidate not found.";
                return result;
            }

            long? existingGeneratedId = tempCandidate["GENERATED_CANDIDATE_ID"]?.Value<long?>();

            if (existingGeneratedId.HasValue && existingGeneratedId.Value > 0)
            {
                result["Success"] = true;
                result["CandidateId"] = existingGeneratedId.Value;
                result["Message"] = $"Candidate ID {existingGeneratedId.Value} is already generated for this candidate.";
                return result;
            }

            int postId = tempCandidate["POST_ID"]?.Value<int>() ?? 0;
            if (locationId <= 0)
                locationId = tempCandidate["LOCATION_ID"]?.Value<int>() ?? 0;

            List<ATSJobDescription> jobs = postId > 0
                ? await GetJobDescriptionsByPostIdAsync(postId)
                : new List<ATSJobDescription>();

            if (jobs.Count == 0)
            {
                result["Message"] = "Job description not found for candidate post.";
                return result;
            }

            ATSJobDescription jobDescription = SelectJobDescriptionForLocation(jobs, locationId);
            string candidateJsonText = tempCandidate["CANDIDATE_JSON"]?.ToString();
            JObject candidateJson = TryParseJsonObject(candidateJsonText);

            string mailId = FirstNonEmpty(
                tempCandidate["MAIL_ID"]?.ToString(),
                GetJsonString(candidateJson, "Email"));

            if (string.IsNullOrWhiteSpace(mailId))
            {
                result["Message"] = "Candidate email is not available. Send EAF cannot be completed.";
                return result;
            }

            candidateJson["Email"] = mailId;

            if (string.IsNullOrWhiteSpace(GetJsonString(candidateJson, "Mobile")))
            {
                candidateJson["Mobile"] = tempCandidate["PHONE_NUMBER"]?.ToString() ?? string.Empty;
            }

            if (string.IsNullOrWhiteSpace(GetJsonString(candidateJson, "CandidateFirstName")))
            {
                string candidateName = tempCandidate["CANDIDATE_NAME"]?.ToString() ?? string.Empty;
                if (!string.IsNullOrWhiteSpace(candidateName))
                {
                    string[] nameParts = candidateName.Split(' ', StringSplitOptions.RemoveEmptyEntries);
                    if (nameParts.Length == 1)
                    {
                        candidateJson["CandidateFirstName"] = nameParts[0];
                    }
                    else if (nameParts.Length == 2)
                    {
                        candidateJson["CandidateFirstName"] = nameParts[0];
                        candidateJson["CandidateLastName"] = nameParts[1];
                    }
                    else if (nameParts.Length >= 3)
                    {
                        candidateJson["CandidateFirstName"] = nameParts[0];
                        candidateJson["CandidateMiddleName"] = nameParts[1];
                        candidateJson["CandidateLastName"] = string.Join(" ", nameParts.Skip(2));
                    }
                }
            }

            JObject signupResult = await RegisterShortlistedCandidateAsync(candidateJson, jobDescription);
            bool signupSuccess = signupResult["Success"]?.Value<bool>() ?? false;
            long? candidateId = signupResult["CandidateId"]?.Value<long?>();

            if (signupSuccess && candidateId.HasValue && candidateId.Value > 0)
            {
                string savedCvName = tempCandidate["SAVED_CV_NAME"]?.ToString() ?? string.Empty;
                string originalCvName = tempCandidate["CV_NAME"]?.ToString() ?? savedCvName;
                await SaveTempCandidateDetailsAsync(candidateId.Value, candidateJson, savedCvName, originalCvName);

                // Save official ATS score breakdown into HEAD_ATS_SCORE / DTLS_ATS_SCORE for real CandidateID
                int atsHeadRatingId = tempCandidate["ATS_HEAD_RATING_ID"]?.Value<int>() ?? jobDescription.ATS_HEAD_RATING_ID;
                string fullJson = tempCandidate["FULL_JSON"]?.ToString();

                if (atsHeadRatingId > 0 && !string.IsNullOrWhiteSpace(fullJson))
                {
                    try
                    {
                        var ratingConfig = await GetAtsRatingConfigAsync(atsHeadRatingId);
                        if (ratingConfig.BreakDownArray != null && ratingConfig.BreakDownArray.Count > 0)
                        {
                            await SaveAtsResponseToDb(fullJson, (int)candidateId.Value, ratingConfig.TotalScore, ratingConfig.BreakDownArray);
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Warning: Could not save ATS score breakdown to main database for CandidateId {candidateId.Value}: {ex.Message}");
                    }
                }

                string username = signupResult["Username"]?.ToString() ?? mailId;
                string password = signupResult["Password"]?.ToString() ?? string.Empty;
                string candidateName = GetCandidateName(candidateJson);

                await SendCandidateCredentialMailAsync(mailId, candidateName, username, password, jobDescription.COMPANY_NAME, jobDescription.POST);

                string fileHash = tempCandidate["FILE_HASH"]?.ToString() ?? string.Empty;
                string phoneNumber = tempCandidate["PHONE_NUMBER"]?.ToString() ?? string.Empty;

                await UpdateCandidateIdBulkResumeAtsScoreLog(postId, fileHash, candidateName, mailId, phoneNumber, candidateId.Value);

                result["Success"] = true;
                result["CandidateId"] = candidateId.Value;
                result["Message"] = $"Final Candidate ID {candidateId.Value} generated successfully for {candidateName}.";
                return result;
            }

            string signupMessage = signupResult["Message"]?.ToString();
            result["Message"] = !string.IsNullOrWhiteSpace(signupMessage)
                ? signupMessage
                : "Candidate registration service failed to generate Candidate ID.";
            return result;
        }

        private static string FirstNonEmpty(params string?[] values)
        {
            foreach (string? value in values)
            {
                if (!string.IsNullOrWhiteSpace(value))
                    return value.Trim();
            }

            return string.Empty;
        }
        private static JObject TryParseJsonObject(string? jsonText)
        {
            if (string.IsNullOrWhiteSpace(jsonText))
                return new JObject();

            try
            {
                return JObject.Parse(jsonText);
            }
            catch
            {
                return new JObject();
            }
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
                string postName = GetCleanPostName(jobDescription);

                var payload = new
                {
                    Username = username,
                    Email = email,
                    Password = password,
                    Company = jobDescription.COMPANY_NAME ?? string.Empty,
                    Post = postName,
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

        private static string GetCleanPostName(ATSJobDescription? jobDescription)
        {
            if (jobDescription == null)
                return string.Empty;

            string postName = FirstNonEmpty(
                jobDescription.POST,
                jobDescription.JobTitle
            );

            // Remove existing Department and Location if already present
            postName = RemoveTrailingPostPart(postName, jobDescription.LOCATION_NAME);
            postName = RemoveTrailingPostPart(postName, jobDescription.DEPARTMENT_NAME);

            var parts = new List<string>();

            if (!string.IsNullOrWhiteSpace(postName))
                parts.Add(postName.Trim());

            if (!string.IsNullOrWhiteSpace(jobDescription.DEPARTMENT_NAME))
                parts.Add(jobDescription.DEPARTMENT_NAME.Trim());

            if (!string.IsNullOrWhiteSpace(jobDescription.LOCATION_NAME))
                parts.Add(jobDescription.LOCATION_NAME.Trim());

            return string.Join(" - ", parts);
        }

        

        private static ATSJobDescription SelectJobDescriptionForLocation(List<ATSJobDescription> jobs, int locationId)
        {
            if (jobs == null || jobs.Count == 0)
                return new ATSJobDescription();

            if (locationId <= 0)
                return jobs.First();

            return jobs.FirstOrDefault(job =>
                    job.LocationID == locationId
                    || job.LOCATION_ID == locationId)
                ?? jobs.First();
        }

        private static string RemoveTrailingPostPart(string postName, string? trailingPart)
        {
            if (string.IsNullOrWhiteSpace(postName) || string.IsNullOrWhiteSpace(trailingPart))
                return postName?.Trim() ?? string.Empty;

            string suffix = " - " + trailingPart.Trim();
            return postName.EndsWith(suffix, StringComparison.OrdinalIgnoreCase)
                ? postName.Substring(0, postName.Length - suffix.Length).Trim()
                : postName.Trim();
        }

        public async Task<(decimal TotalScore, List<RatingItem> BreakDownArray)> GetAtsRatingConfigAsync(int atsHeadRatingId)
        {
            if (atsHeadRatingId <= 0)
                return (100, new List<RatingItem>());

            var parameters = new Dictionary<string, object>
            {
                { "@ATS_HEAD_RATING_ID", atsHeadRatingId }
            };

            DataTable dt = await _dataService.GetDataAsync("SP_ATS_PROMT_BY_HEAD_RATING_ID", parameters, _connectionString);

            if (dt.Rows.Count == 0 || dt.Rows[0]["AtsPrompt"] == DBNull.Value)
                return (100, new List<RatingItem>());

            string profileJson = dt.Rows[0]["AtsPrompt"].ToString();
            var jObj = JObject.Parse(profileJson);

            decimal totalScore = jObj["Total Score"]?.Value<decimal>() ?? 100;
            var breakDownArray = JsonConvert.DeserializeObject<List<RatingItem>>(
                jObj["BreakDownScore"]?.ToString() ?? "[]"
            ) ?? new List<RatingItem>();

            if (totalScore <= 0 && breakDownArray.Count > 0)
            {
                totalScore = breakDownArray.Sum(x =>
                {
                    decimal.TryParse(x.Value, out decimal ratingValue);
                    return ratingValue;
                });
            }

            if (totalScore <= 0)
                totalScore = 100;

            return (totalScore, breakDownArray);
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

            decimal obtainedScore = 0;
            var enrichedBreakdown = new Dictionary<string, object>();
            var detailsDict = new Dictionary<string, object>();

            foreach (var item in breakDownArrayFromPrompt)
            {
                string key = item.Key;
                decimal total = 0;
                decimal.TryParse(item.Value, out total);

                decimal obtained = scoresToken[key]?["obtained"]?.Value<decimal>() ?? 0;
                // GPT sometimes returns marks above the configured category total.
                // Persist only valid ATS marks: 0 <= obtained <= category total.
                obtained = ClampObtainedScore(obtained, total);
                obtainedScore += obtained;
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

            if (totalScoreFromPrompt > 0 && obtainedScore > totalScoreFromPrompt)
                obtainedScore = totalScoreFromPrompt;

            matchScore = Convert.ToInt32(Math.Round(obtainedScore, 0, MidpointRounding.AwayFromZero));

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
                postId =  Convert.ToInt32(dt.Rows[0]["ActualPostID"]);
                locId =Convert.ToInt32(dt.Rows[0]["locId"]);
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

        private static decimal ClampObtainedScore(decimal obtained, decimal total)
        {
            if (obtained < 0)
                return 0;

            if (total > 0 && obtained > total)
                return total;

            return obtained;
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

        public JObject SanitizeAndValidateAtsScoreJson(JObject scoreJson, AtsPromptResult promptResult)
        {
            if (scoreJson == null)
                scoreJson = new JObject();

            JObject scores = scoreJson["scores"] as JObject;
            if (scores == null)
            {
                scores = new JObject();
                scoreJson["scores"] = scores;
            }

            decimal totalObtainedSum = 0;
            decimal maxPossibleScore = promptResult?.TotalScore > 0 ? promptResult.TotalScore : 100;

            foreach (RatingItem item in promptResult?.BreakDownArray ?? new List<RatingItem>())
            {
                decimal.TryParse(item.Value, out decimal categoryTotal);

                JObject catObj = scores[item.Key] as JObject;
                if (catObj == null)
                {
                    catObj = new JObject();
                    scores[item.Key] = catObj;
                }

                catObj["total"] = categoryTotal;
                catObj["id"] = item.Id;

                decimal obtained = catObj["obtained"]?.Value<decimal>() ?? 0;

                // CRITICAL RULE: obtained score CANNOT be greater than category total
                if (obtained > categoryTotal)
                {
                    obtained = categoryTotal;
                }
                if (obtained < 0)
                {
                    obtained = 0;
                }

                catObj["obtained"] = Math.Round(obtained, 2);
                totalObtainedSum += obtained;
            }

            totalObtainedSum = Math.Min(totalObtainedSum, maxPossibleScore);
            scoreJson["match_score"] = Math.Round(totalObtainedSum, 2);

            decimal percentage = maxPossibleScore > 0 ? Math.Round((totalObtainedSum / maxPossibleScore) * 100, 2) : 0;
            if (percentage > 100) percentage = 100;
            if (percentage < 0) percentage = 0;
            scoreJson["percentage"] = percentage;

            string status = EvaluateStatusByRules(percentage, promptResult?.ResultStatusArray);
            if (!string.IsNullOrWhiteSpace(status))
            {
                scoreJson["Status"] = status;
            }

            return scoreJson;
        }

        public string EvaluateStatusByRules(decimal percentage, List<ResultStatusItem> resultStatusArray)
        {
            if (resultStatusArray == null || resultStatusArray.Count == 0)
                return percentage >= 50 ? "Shortlisted" : "Rejected";

            foreach (var rule in resultStatusArray)
            {
                string ruleValue = rule.Value?.Trim() ?? "";
                if (ruleValue.StartsWith(">="))
                {
                    if (decimal.TryParse(ruleValue.Substring(2), out decimal val) && percentage >= val)
                        return rule.Key;
                }
                else if (ruleValue.StartsWith(">"))
                {
                    if (decimal.TryParse(ruleValue.Substring(1), out decimal val) && percentage > val)
                        return rule.Key;
                }
                else if (ruleValue.StartsWith("<="))
                {
                    if (decimal.TryParse(ruleValue.Substring(2), out decimal val) && percentage <= val)
                        return rule.Key;
                }
                else if (ruleValue.StartsWith("<"))
                {
                    if (decimal.TryParse(ruleValue.Substring(1), out decimal val) && percentage < val)
                        return rule.Key;
                }
            }

            return resultStatusArray.FirstOrDefault()?.Key ?? (percentage >= 50 ? "Shortlisted" : "Rejected");
        }

        public bool IsAtsShortlisted(JObject scoreJson)
        {
            string status = scoreJson?["Status"]?.ToString();
            return !string.IsNullOrWhiteSpace(status) &&
                   status.Equals("Shortlisted", StringComparison.OrdinalIgnoreCase);
        }

        private void EnrichResumeLocationFromText(JObject resume, string resumeText)
        {
            if (resume == null || string.IsNullOrWhiteSpace(resumeText))
                return;

            bool hasLocation =
                !string.IsNullOrWhiteSpace(resume["CityOrVillage"]?.ToString()) ||
                !string.IsNullOrWhiteSpace(resume["State"]?.ToString()) ||
                !string.IsNullOrWhiteSpace(resume["Country"]?.ToString());

            if (hasLocation)
                return;

            Match match = Regex.Match(
                resumeText,
                @"\b(?<city>[A-Za-z][A-Za-z\s.-]{1,60}),\s*(?<state>[A-Za-z][A-Za-z\s.-]{1,60}),\s*(?<country>India)\b",
                RegexOptions.IgnoreCase);

            if (!match.Success)
                return;

            string city = Regex.Replace(match.Groups["city"].Value.Trim(), @"\s+", " ");
            string state = Regex.Replace(match.Groups["state"].Value.Trim(), @"\s+", " ");
            string country = match.Groups["country"].Value.Trim();
            string address = $"{city}, {state}, {country}";

            resume["CityOrVillage"] = city;
            resume["State"] = state;
            resume["Country"] = country;

            if (string.IsNullOrWhiteSpace(resume["Address"]?.ToString()))
                resume["Address"] = address;
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

        private void EnrichProfessionalExperience(JObject resume, string resumeText)
        {
            if (resume == null) return;

            string exp = resume["ProfessionalExperience"]?.ToString()
                         ?? resume["ProfessionalExp"]?.ToString()
                         ?? resume["TotalExperience"]?.ToString()
                         ?? resume["Experience"]?.ToString()
                         ?? string.Empty;

            if (!string.IsNullOrWhiteSpace(exp) && exp != "-")
            {
                resume["ProfessionalExperience"] = exp;
                return;
            }

            // 1. Try regex pattern match from resumeText
            if (!string.IsNullOrWhiteSpace(resumeText))
            {
                Match match = Regex.Match(
                    resumeText,
                    @"\b(?<exp>\d+(?:\.\d+)?\+?\s*(?:years?|yrs?|months?))\s*(?:of)?\s*(?:relevant|professional|total|work|IT)?\s*experience\b",
                    RegexOptions.IgnoreCase);

                if (match.Success)
                {
                    resume["ProfessionalExperience"] = match.Groups["exp"].Value.Trim();
                    return;
                }

                Match match2 = Regex.Match(
                    resumeText,
                    @"(?:Total|Professional|Work)\s*Experience\s*[:\-\s]\s*(?<exp>\d+(?:\.\d+)?\+?\s*(?:years?|yrs?|months?))",
                    RegexOptions.IgnoreCase);

                if (match2.Success)
                {
                    resume["ProfessionalExperience"] = match2.Groups["exp"].Value.Trim();
                    return;
                }
            }

            // 2. Try inferring from CompanyDetails if present
            if (resume["CompanyDetails"] is JArray companyArray && companyArray.Count > 0)
            {
                resume["ProfessionalExperience"] = $"{companyArray.Count} Role(s) Listed";
            }
        }

        private void EnrichProjects(JObject resume, string resumeText)
        {
            if (resume == null) return;

            JArray? anyProject = resume["AnyProject"] as JArray;
            bool hasValidProjects = anyProject != null && anyProject.Any(p => !string.IsNullOrWhiteSpace(p?.ToString()));

            if (hasValidProjects)
            {
                var cleaned = new JArray(anyProject!.Where(p => !string.IsNullOrWhiteSpace(p?.ToString())));
                if (cleaned.Count > 0)
                {
                    resume["AnyProject"] = cleaned;
                    return;
                }
            }

            var projectsList = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            // 1. Harvest project references from CompanyDetails responsibilities
            if (resume["CompanyDetails"] is JArray companyList)
            {
                foreach (var company in companyList)
                {
                    if (company["Responsibilities"] is JArray respArray)
                    {
                        foreach (var resp in respArray)
                        {
                            string text = resp?.ToString()?.Trim() ?? string.Empty;
                            if (string.IsNullOrWhiteSpace(text)) continue;

                            if (text.Contains("system", StringComparison.OrdinalIgnoreCase) ||
                                text.Contains("application", StringComparison.OrdinalIgnoreCase) ||
                                text.Contains("ATS", StringComparison.OrdinalIgnoreCase) ||
                                text.Contains("ERP", StringComparison.OrdinalIgnoreCase) ||
                                text.Contains("platform", StringComparison.OrdinalIgnoreCase) ||
                                text.Contains("portal", StringComparison.OrdinalIgnoreCase) ||
                                text.Contains("module", StringComparison.OrdinalIgnoreCase) ||
                                text.Contains("project", StringComparison.OrdinalIgnoreCase) ||
                                text.Contains("workflow", StringComparison.OrdinalIgnoreCase))
                            {
                                projectsList.Add(text);
                            }
                        }
                    }
                }
            }

            if (projectsList.Count > 0)
            {
                resume["AnyProject"] = new JArray(projectsList);
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

        private int GetIntValue(DataRow row, string columnName)
        {
            if (!row.Table.Columns.Contains(columnName) || row[columnName] == DBNull.Value)
                return 0;

            return int.TryParse(row[columnName]?.ToString(), out int value) ? value : 0;
        }

        private string GetConfiguredFolder(string configuredPath)
        {
            if (string.IsNullOrWhiteSpace(configuredPath))
                return Directory.GetCurrentDirectory();

            return Path.IsPathRooted(configuredPath)
                ? configuredPath
                : Path.Combine(Directory.GetCurrentDirectory(), configuredPath);
        }

        private void EnsureWritableFolder(string folderPath, string configurationKey)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(folderPath))
                    throw new InvalidOperationException($"{configurationKey} is empty.");

                if (!Directory.Exists(folderPath))
                    Directory.CreateDirectory(folderPath);

                string testFilePath = Path.Combine(folderPath, $".ats_write_test_{Guid.NewGuid():N}.tmp");
                File.WriteAllText(testFilePath, "ok");
                File.Delete(testFilePath);
            }
            catch (Exception ex)
            {
                throw new IOException(
                    $"Cannot write to configured folder '{folderPath}' from {configurationKey}. " +
                    "Verify the physical path exists on the ATS API server and the IIS app pool identity has Modify permission.",
                    ex);
            }
        }

        private string BuildPublicFileLocation(string baseUrl, string savedFileName)
        {
            if (string.IsNullOrWhiteSpace(savedFileName))
                return string.Empty;

            if (string.IsNullOrWhiteSpace(baseUrl))
                return Path.Combine(GetUploadFolder(), savedFileName);

            return baseUrl.TrimEnd('/', '\\') + "/" + savedFileName.TrimStart('/', '\\');
        }

        private List<Dictionary<string, object?>> ConvertDataTableToDictionaryList(DataTable dt)
        {
            var rows = new List<Dictionary<string, object?>>();

            foreach (DataRow row in dt.Rows)
            {
                var item = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase);

                foreach (DataColumn column in dt.Columns)
                {
                    object value = row[column];
                    item[column.ColumnName] = value == DBNull.Value ? null : value;
                }

                rows.Add(item);
            }

            return rows;
        }

        private string GetSignupPassword(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return string.Empty;

            int atIndex = email.IndexOf('@');
            string username = atIndex > 0 ? email.Substring(0, atIndex) : email;

            char[] specialChars = { '@', '#', '$', '%', '&', '*' };
            Random random = new Random();

            char special = specialChars[random.Next(specialChars.Length)];
            int number = random.Next(10, 100); // Generates 10-99 (2 digits)

            return $"{username}{special}{number}";
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

        private bool ContainsBlockedTextSignature(string filePath)
        {
            /*
             * Text signature scan:
             * Looks for obvious dangerous content inside the uploaded file bytes.
             * EICAR is the standard antivirus test string.
             */
            byte[] bytes = File.ReadAllBytes(filePath);
            string content = Encoding.ASCII.GetString(bytes);

            return content.Contains("EICAR-STANDARD-ANTIVIRUS-TEST-FILE", StringComparison.OrdinalIgnoreCase)
                || content.Contains("<script", StringComparison.OrdinalIgnoreCase)
                || content.Contains("javascript:", StringComparison.OrdinalIgnoreCase)
                || content.Contains("powershell", StringComparison.OrdinalIgnoreCase)
                || content.Contains("cmd.exe", StringComparison.OrdinalIgnoreCase);
        }

        private bool ContainsUnsafeDocxPackageContent(string filePath)
        {
            /*
             * DOCX package scan:
             * DOCX files are ZIP packages. This checks the package entries for
             * macros, OLE embedded objects, or script/executable files.
             */
            try
            {
                using ZipArchive archive = ZipFile.OpenRead(filePath);

                return archive.Entries.Any(entry =>
                    entry.FullName.Contains("vbaProject.bin", StringComparison.OrdinalIgnoreCase)
                    || entry.FullName.Contains("oleObject", StringComparison.OrdinalIgnoreCase)
                    || entry.FullName.EndsWith(".exe", StringComparison.OrdinalIgnoreCase)
                    || entry.FullName.EndsWith(".js", StringComparison.OrdinalIgnoreCase)
                    || entry.FullName.EndsWith(".vbs", StringComparison.OrdinalIgnoreCase)
                );
            }
            catch
            {
                return false;
            }
        }

    }

    public class ResumeSecurityScanResult
    {
        public bool IsSafe { get; set; }
        public string Message { get; set; } = string.Empty;
    }

}
