using ATS.API.Interface;
using ATS.API.Models;
using ATS.API.Services;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace ATS.API.Controllers
{
    /// <summary>
    /// API Controller handling bulk resume processing, automated ATS (Applicant Tracking System) scoring,
    /// manual recruitment actions (EAF / Candidate registration, Exam link dispatch), and LMS exam callback integrations.
    /// </summary>
    [Route("ATS")]
    [ApiController]
    public class BulkResumeController : ControllerBase
    {
        private readonly BulkResumeService _bulkResumeService;
        private readonly IBackgroundTaskQueue _backgroundTaskQueue;
        private readonly IServiceScopeFactory _serviceScopeFactory;
        private readonly LmsExamLinkService _lmsExamLinkService;

        /// <summary>
        /// Initializes a new instance of the <see cref="BulkResumeController"/> class.
        /// </summary>
        /// <param name="bulkResumeService">Domain service providing file parsing, duplicate checks, AI prompting, and database persistence.</param>
        /// <param name="backgroundTaskQueue">Queue for dispatching asynchronous background workloads (e.g. bulk parsing and scoring).</param>
        /// <param name="serviceScopeFactory">Factory used to create independent DI scopes during background job execution.</param>
        /// <param name="lmsExamLinkService">Service for generating and dispatching LMS assessment exam links.</param>
        public BulkResumeController(
            BulkResumeService bulkResumeService, 
            IBackgroundTaskQueue backgroundTaskQueue, 
            IServiceScopeFactory serviceScopeFactory,
            LmsExamLinkService lmsExamLinkService)
        {
            _bulkResumeService = bulkResumeService;
            _backgroundTaskQueue = backgroundTaskQueue;
            _serviceScopeFactory = serviceScopeFactory;
            _lmsExamLinkService = lmsExamLinkService;
        }

        /// <summary>
        /// Uploads up to 50 resumes for a designated job post and enqueues them for background ATS scoring.
        /// </summary>
        /// <remarks>
        /// Workflow:
        /// 1. Validates input resume count (1 to 50 files).
        /// 2. Verifies existence of the Job Description and ATS rating configuration for the given Post ID.
        /// 3. Performs multi-level deduplication per file:
        ///    - Within current batch (MD5/SHA hash).
        ///    - Currently active background processing.
        ///    - Existing resume records in database for this post.
        /// 4. Saves valid files to temporary storage and dispatches batch to the background task queue.
        /// </remarks>
        /// <param name="postId">The unique identifier of the Job Post.</param>
        /// <param name="resumes">List of resume files (PDF, DOCX, DOC) uploaded via multipart form data.</param>
        /// <returns>HTTP 202 Accepted with batch details on success, or HTTP 400 Bad Request on validation failure.</returns>
        [HttpPost("bulk-resume-upload")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> BulkResumeUploadScoreATSGenerate([FromForm] BulkResumeUploadRequest request)
        {
            int postId = request.PostId;
            List<IFormFile> resumes = request.Resumes;
            int locationId = request.LocationId;
            try
            {
                // Validate that at least one resume file was provided
                if (resumes == null || resumes.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Please upload at least one resume."
                    });
                }

                // Enforce maximum batch size limit
                if (resumes.Count > 50)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        MaxAllowed = 50,
                        UploadedCount = resumes.Count,
                        Message = "Maximum 50 resumes are allowed in one bulk upload."
                    });
                }

                // Retrieve job description details associated with the Post ID
                List<ATSJobDescription> jobs = await _bulkResumeService.GetJobDescriptionsByPostIdAsync(postId);

                if (jobs.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Job description not found."
                    });
                }

                ATSJobDescription jobDescription = jobs.First();
                int atsHeadRatingId = jobDescription.ATS_HEAD_RATING_ID;
                if (locationId <= 0)
                    locationId = ResolveLocationId(jobDescription);

                // Validate that the job description contains sufficient content for AI evaluation
                if (!HasProperJobDescription(jobDescription))
                {
                    return BadRequest(new
                    {
                        Success = false,
                        PostId = postId,
                        Post = jobDescription.POST,
                        Message = "Proper job description is not available for this post. ATS score cannot be generated."
                    });
                }
                 
                // Validate that ATS Head Rating criteria is mapped
                if (atsHeadRatingId == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "ATS Rating configuration is not mapped for this job post."
                    });
                }

                string uploadFolder = _bulkResumeService.GetUploadFolder();
                var queuedFiles = new List<BulkResumeQueuedFile>();
                var rejectedFiles = new List<object>();
                var batchHashes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

                // Iterate through files, validate, check duplicates, and stage for background execution
                foreach (IFormFile resume in resumes.Where(x => x != null))
                {
                    if (resume.Length == 0)
                    {
                        rejectedFiles.Add(new
                        {
                            FileName = resume.FileName,
                            Reason = "Empty resume file skipped."
                        });
                        continue;
                    }

                    string fileHash = await _bulkResumeService.ComputeFileHashAsync(resume);

                    // 1. Check duplicate within current upload batch
                    if (!string.IsNullOrWhiteSpace(fileHash) && batchHashes.Contains(fileHash))
                    {
                        rejectedFiles.Add(new
                        {
                            FileName = resume.FileName,
                            Reason = "Duplicate CV upload skipped. Identical file found in the same bulk upload request."
                        });
                        continue;
                    }

                    // 2. Check if identical resume content is currently processing in background
                    if (!string.IsNullOrWhiteSpace(fileHash) && _bulkResumeService.IsResumeCurrentlyProcessing(postId, fileHash))
                    {
                        rejectedFiles.Add(new
                        {
                            FileName = resume.FileName,
                            Reason = "Duplicate CV upload skipped. A resume with identical content is currently being processed for this job post."
                        });
                        continue;
                    }

                    // 3. Check duplicate in database for this post
                    if (!string.IsNullOrWhiteSpace(fileHash))
                    {
                        JObject existingResume = await _bulkResumeService.GetExistingBulkResumeByHashAsync(postId, fileHash, 0);
                        if (existingResume != null)
                        {
                            rejectedFiles.Add(new
                            {
                                FileName = resume.FileName,
                                Reason = "Duplicate CV upload skipped. A resume with identical content already exists for this job post.",
                                ExistingCvName = existingResume["CV_NAME"]?.ToString(),
                                ExistingSavedCvName = existingResume["SAVED_CV_NAME"]?.ToString()
                            });
                            continue;
                        }

                        batchHashes.Add(fileHash);
                        _bulkResumeService.TryRegisterActiveProcessingHash(postId, fileHash);
                    }

                    // Persist file to local disk for background worker consumption
                    (string savedFileName, string savedFilePath) = await _bulkResumeService.SaveResumeTempFileAsync(resume, uploadFolder);

                    queuedFiles.Add(new BulkResumeQueuedFile
                    {
                        OriginalFileName = resume.FileName,
                        SavedFileName = savedFileName,
                        SavedFilePath = savedFilePath,
                        FileHash = fileHash
                    });
                }

                // If all files in the batch were rejected / invalid
                if (queuedFiles.Count == 0)
                {
                    string rejectionMessage = "No valid resume files found for background processing.";
                    if (rejectedFiles.Count == 1)
                    {
                        var first = rejectedFiles[0];
                        string reason = first.GetType().GetProperty("Reason")?.GetValue(first)?.ToString() ?? string.Empty;
                        if (!string.IsNullOrWhiteSpace(reason))
                        {
                            rejectionMessage = reason;
                        }
                    }
                    else if (rejectedFiles.Count > 1)
                    {
                        rejectionMessage = "All uploaded resume files were skipped (duplicate or invalid files). Please review the rejected files list.";
                    }

                    return BadRequest(new
                    {
                        Success = false,
                        TotalUploaded = resumes.Count,
                        RejectedBeforeQueue = rejectedFiles,
                        Message = rejectionMessage
                    });
                }

                string batchId = Guid.NewGuid().ToString("N");

                // Enqueue background processing task with dedicated DI scope
                await _backgroundTaskQueue.QueueBackgroundWorkItem(async token =>
                {
                    using var scope = _serviceScopeFactory.CreateScope();
                    var bulkResumeService = scope.ServiceProvider.GetRequiredService<BulkResumeService>();
                    await ProcessBulkResumeBatchAsync(batchId, bulkResumeService, postId, locationId, jobDescription, queuedFiles, token);
                });

                return Accepted(new
                {
                    Success = true,
                    BatchId = batchId,
                    PostId = postId,
                    ATSHeadRatingID = atsHeadRatingId,
                    TotalUploaded = resumes.Count,
                    AcceptedForBackgroundProcessing = queuedFiles.Count,
                    RejectedBeforeQueue = rejectedFiles,
                    message = "Bulk resume files accepted. ATS processing is running in background. Exam tagging is not required during bulk CV upload."
                });
            }
            catch (Exception ex)
            {
                string detailedMessage = ex.InnerException != null
                    ? $"{ex.Message} Inner: {ex.InnerException.Message}"
                    : ex.Message;

                return StatusCode(500, new
                {
                    Success = false,
                    Message = detailedMessage
                });
            }
        }

        /// <summary>
        /// Asynchronously processes a batch of staged resume files in the background.
        /// Executes security scans, file hash verification, text extraction, candidate profile extraction,
        /// AI ATS rating evaluation via LLM, and persists results into the ATS database log.
        /// </summary>
        /// <param name="batchId">Unique tracking identifier for this upload batch.</param>
        /// <param name="bulkResumeService">Scoped instance of BulkResumeService.</param>
        /// <param name="postId">Target Job Post ID.</param>
        /// <param name="jobDescription">Associated job description model.</param>
        /// <param name="queuedFiles">List of queued resume files to process.</param>
        /// <param name="token">Cancellation token for background task termination.</param>
        private async Task ProcessBulkResumeBatchAsync(string batchId, BulkResumeService bulkResumeService, int postId, int locationId, ATSJobDescription jobDescription, List<BulkResumeQueuedFile> queuedFiles, CancellationToken token)
        {
            int atsHeadRatingId = jobDescription.ATS_HEAD_RATING_ID;
            int companyId = jobDescription.CompanyID;
            int departmentId = jobDescription.DepartmentID > 0 ? jobDescription.DepartmentID : jobDescription.DEPARTMENT_ID;
            if (locationId <= 0)
                locationId = ResolveLocationId(jobDescription);

            var parallelOptions = new ParallelOptions
            {
                MaxDegreeOfParallelism = Math.Min(5, Environment.ProcessorCount * 2),
                CancellationToken = token
            };

            await Parallel.ForEachAsync(queuedFiles, parallelOptions, async (queuedFile, ct) =>
            {
                if (ct.IsCancellationRequested)
                    return;

                string fileHash = !string.IsNullOrWhiteSpace(queuedFile.FileHash)
                    ? queuedFile.FileHash
                    : await bulkResumeService.ComputeFileHashAsync(queuedFile.SavedFilePath);

                string candidateName = string.Empty;
                string mailId = string.Empty;
                string phoneNumber = string.Empty;
                JObject candidateJson = null;

                try
                {
                    // 1. Security scan: verify file header, signature, and malicious content
                    ResumeSecurityScanResult scanResult = await bulkResumeService.ScanResumeFileAsync(queuedFile.SavedFilePath, queuedFile.OriginalFileName);

                    if (!scanResult.IsSafe)
                    {
                        var scanFailedJson = new JObject
                        {
                            ["batchId"] = batchId,
                            ["message"] = "Resume file failed security scan.",
                            ["reason"] = scanResult.Message
                        };

                        await bulkResumeService.SaveBulkResumeAtsScoreAsync(postId, companyId, departmentId, queuedFile.OriginalFileName, queuedFile.SavedFileName, fileHash, null, null, null, atsHeadRatingId, null, "SecurityScanFailed", false, scanFailedJson, null, false, null, locationId: locationId);
                        return;
                    }

                    // 2. Re-verify database deduplication in case a parallel worker finished earlier
                    JObject existingResume = await bulkResumeService.GetExistingBulkResumeByHashAsync(postId, fileHash, 0);

                    if (existingResume != null)
                    {
                        // Completely skip without saving duplicate record into database
                        return;
                    }

                    // 3. Extract text content from the uploaded resume file
                    string resumeText = await bulkResumeService.ExtractResumeTextAsync(queuedFile.SavedFilePath);

                    if (string.IsNullOrWhiteSpace(resumeText) || resumeText.StartsWith("[Unsupported", StringComparison.OrdinalIgnoreCase))
                    {
                        var extractionFailedJson = new JObject
                        {
                            ["batchId"] = batchId,
                            ["message"] = "Resume text could not be extracted.",
                            ["reason"] = resumeText,
                            ["fileHash"] = fileHash
                        };

                        await bulkResumeService.SaveBulkResumeAtsScoreAsync(postId, companyId, departmentId, queuedFile.OriginalFileName, queuedFile.SavedFileName, fileHash, null, null, null, atsHeadRatingId, null, "ExtractionFailed", false, extractionFailedJson, null, false, null, locationId: locationId);
                        return;
                    }

                    // 4. Parse structured candidate contact details and experience from resume text
                    candidateJson = await bulkResumeService.ParseCandidateResumeJsonAsync(resumeText);
                    candidateName = bulkResumeService.GetCandidateName(candidateJson);
                    mailId = bulkResumeService.GetJsonString(candidateJson, "Email");
                    phoneNumber = bulkResumeService.GetJsonString(candidateJson, "Mobile");

                    string bulkRegNo = string.Empty;
                    long? existingRegCandidateId = null;
                    if (!string.IsNullOrWhiteSpace(mailId))
                    {
                        JObject existingCandidate = await bulkResumeService.GetExistingCandidateByUsernameOrMailAsync(null, mailId, postId);
                        if (existingCandidate != null)
                        {
                            existingRegCandidateId = existingCandidate["CandidateID"]?.Value<long?>();
                            string foundRegNo = FirstNonEmpty(
                                existingCandidate["RegistrationNo"]?.ToString(),
                                existingCandidate["registrationnumber"]?.ToString());
                            bulkRegNo = !string.IsNullOrWhiteSpace(foundRegNo) ? foundRegNo : "Not Generated";
                        }
                    }

                    // 5. Build prompt based on head rating criteria, send to LLM/GPT for ATS scoring
                    AtsPromptResult promptResult = await bulkResumeService.GenerateBulkPromptFromAtsHeadRatingAsync(atsHeadRatingId, jobDescription, resumeText, candidateJson);
                    string scoreResponse = await bulkResumeService.SendGptMessageAsync(promptResult.Prompt);
                    JObject scoreJson;

                    try
                    {
                        scoreJson = bulkResumeService.CleanAndParseJson(scoreResponse);
                    }
                    catch
                    {
                        scoreJson = bulkResumeService.BuildAtsScoreParseFailedJson(scoreResponse, promptResult);
                    }

                    // 7. Sanitize, tag metadata, determine shortlisting status, and persist score
                    scoreJson = bulkResumeService.SanitizeAndValidateAtsScoreJson(scoreJson, promptResult);
                    scoreJson["batchId"] = batchId;
                    bool isShortlisted = bulkResumeService.IsAtsShortlisted(scoreJson);
                    string atsStatus = BulkResumeService.NormalizeAtsStatus(scoreJson["Status"]?.ToString(), isShortlisted);
                    bool isDuplicate = false;

                    scoreJson["manualActionRequired"] = true;
                    scoreJson["manualActionMessage"] = "HR must manually send the exam link or register the candidate for EAF from the bulk resume action screen.";

                    await bulkResumeService.SaveBulkResumeAtsScoreAsync(
                        postId,
                        companyId,
                        departmentId,
                        queuedFile.OriginalFileName,
                        queuedFile.SavedFileName,
                        fileHash,
                        candidateName,
                        mailId,
                        phoneNumber,
                        atsHeadRatingId,
                        existingRegCandidateId,
                        atsStatus,
                        isShortlisted,
                        scoreJson,
                        candidateJson,
                        isDuplicate,
                        null,
                        locationId: locationId,
                        registrationNo: bulkRegNo);
                }
                catch (Exception ex)
                {
                    try
                    {
                        string detailedReason = ex.InnerException != null ? $"{ex.Message} -> {ex.InnerException.Message}" : ex.Message;
                        JObject errorJson = new JObject
                        {
                            ["batchId"] = batchId,
                            ["message"] = "Background ATS processing failed.",
                            ["reason"] = detailedReason,
                            ["details"] = ex.ToString(),
                            ["fileHash"] = fileHash
                        };

                        await bulkResumeService.SaveBulkResumeAtsScoreAsync(postId, companyId, departmentId, queuedFile.OriginalFileName, queuedFile.SavedFileName, fileHash, candidateName, mailId, phoneNumber, atsHeadRatingId, null, "ProcessingFailed", false, errorJson, candidateJson, false, null, locationId: locationId);
                    }
                    catch
                    {
                        // Ignore logging failure so remaining resumes in the batch can continue processing without disruption
                    }
                }
                finally
                {
                    // Clean up active processing lock for this file hash
                    if (!string.IsNullOrWhiteSpace(fileHash))
                    {
                        bulkResumeService.UnregisterActiveProcessingHash(postId, fileHash);
                    }
                }
            });
        }
         
        /// <summary>
        /// Saves or updates candidate information, profile photograph, CV file, and ATS score log entry directly from LMS or recruitment UI.
        /// Supports two main LMS workflows:
        /// 1. Initial creation (CandidateId = 0): Saves candidate metadata, uploads Image &amp; CV, inserts into BulkResumeAtsScoreLog, and returns CandidateID.
        /// 2. Profile photo update (CandidateId &gt; 0): Uploads new Image, updates BulkResumeAtsScoreLog, and returns CandidateID.
        /// </summary>
        /// <param name="request">Multipart form data containing candidate details, job post mappings, optional CV and Image files.</param>
        /// <returns>HTTP 200 OK with CandidateID on success, or HTTP 400/500 on failure.</returns>
        [HttpPost("save-candidate-info")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> SaveCandidateInfo([FromForm] SaveCandidateInfoRequest request)
        {
            try
            {
                if (request == null)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Request body is required."
                    });
                }

                long candidateId = request.CandidateId;
                if (candidateId == 0 && Request.HasFormContentType)
                {
                    if (long.TryParse(Request.Form["CandidateID"], out long cid) && cid > 0) candidateId = cid;
                    else if (long.TryParse(Request.Form["TempCandidateId"], out long tcid) && tcid > 0) candidateId = tcid;
                    else if (long.TryParse(Request.Form["BulkResumeAtsScoreLogID"], out long bid) && bid > 0) candidateId = bid;
                    else if (long.TryParse(Request.Form["Id"], out long id) && id > 0) candidateId = id;
                }

                int postId = request.PostId;
                if (postId <= 0 && Request.HasFormContentType)
                {
                    if (int.TryParse(Request.Form["PostID"], out int pid) && pid > 0) postId = pid;
                    else if (int.TryParse(Request.Form["ActualPostId"], out int apid) && apid > 0) postId = apid;
                    else if (int.TryParse(Request.Form["JobId"], out int jid) && jid > 0) postId = jid;
                }

                int companyId = request.CompanyId;
                if (companyId <= 0 && Request.HasFormContentType)
                {
                    if (int.TryParse(Request.Form["CompanyID"], out int cid) && cid > 0) companyId = cid;
                    else if (int.TryParse(Request.Form["Companyid"], out int cidi) && cidi > 0) companyId = cidi;
                    else if (int.TryParse(Request.Form["ComanyId"], out int cmid) && cmid > 0) companyId = cmid;
                    else if (int.TryParse(Request.Form["ComanyID"], out int cmidi) && cmidi > 0) companyId = cmidi;
                }

                int departmentId = request.DepartmentId;
                if (departmentId <= 0 && Request.HasFormContentType)
                {
                    if (int.TryParse(Request.Form["DepartmentID"], out int did) && did > 0) departmentId = did;
                    else if (int.TryParse(Request.Form["Departmentid"], out int didi) && didi > 0) departmentId = didi;
                }

                int locationId = request.LocationId;
                if (locationId <= 0 && Request.HasFormContentType)
                {
                    if (int.TryParse(Request.Form["LocationID"], out int lid) && lid > 0) locationId = lid;
                    else if (int.TryParse(Request.Form["LocationId"], out int lidi) && lidi > 0) locationId = lidi;
                    else if (int.TryParse(Request.Form["LocId"], out int locid) && locid > 0) locationId = locid;
                    else if (int.TryParse(Request.Form["locid"], out int locidi) && locidi > 0) locationId = locidi;
                }

                string candidateName = FirstNonEmpty(
                    request.CandidateName,
                    Request.HasFormContentType ? Request.Form["CandidateName"].ToString() : null,
                    Request.HasFormContentType ? Request.Form["Name"].ToString() : null);

                string mailId = FirstNonEmpty(
                    request.MailId,
                    Request.HasFormContentType ? Request.Form["MailId"].ToString() : null,
                    Request.HasFormContentType ? Request.Form["Email"].ToString() : null);

                string phoneNumber = FirstNonEmpty(
                    request.PhoneNumber,
                    Request.HasFormContentType ? Request.Form["PhoneNumber"].ToString() : null,
                    Request.HasFormContentType ? Request.Form["PhoneNo"].ToString() : null,
                    Request.HasFormContentType ? Request.Form["Mobile"].ToString() : null,
                    Request.HasFormContentType ? Request.Form["Phone"].ToString() : null);

                string registrationNo = FirstNonEmpty(
                    request.RegistrationNo,
                    Request.HasFormContentType ? Request.Form["RegistrationNo"].ToString() : null,
                    Request.HasFormContentType ? Request.Form["RegNo"].ToString() : null,
                    Request.HasFormContentType ? Request.Form["REGISTRATION_NO"].ToString() : null);

                // Resolve uploaded Photo / Image file from model binding or form files collection
                IFormFile? photoFile = request.Image
                    ?? (Request.HasFormContentType && Request.Form.Files.Count > 0 ? (Request.Form.Files["Image"] ?? Request.Form.Files["Photo"] ?? Request.Form.Files["image"] ?? Request.Form.Files["photo"]) : null);

                // Resolve uploaded CV / Resume file from model binding or form files collection
                IFormFile? cvFile = request.CV
                    ?? (Request.HasFormContentType && Request.Form.Files.Count > 0 ? (Request.Form.Files["CV"] ?? Request.Form.Files["Resume"] ?? Request.Form.Files["cv"] ?? Request.Form.Files["resume"]) : null);

                // =========================================================================
                // WORKFLOW 2: Update existing candidate (CandidateId > 0, e.g. updating Image)
                // =========================================================================
                if (candidateId > 0)
                {
                    JObject existingCandidate = await _bulkResumeService.GetBulkResumeAtsScoreLogByIdAsync(candidateId);
                    if (existingCandidate == null)
                    {
                        return NotFound(new
                        {
                            Success = false,
                            CandidateID = candidateId,
                            Message = $"Candidate with ID {candidateId} was not found."
                        });
                    }

                    int existingPostId = existingCandidate["POST_ID"]?.Value<int>() ?? postId;
                    int existingCompanyId = existingCandidate["COMPANY_ID"]?.Value<int>() ?? companyId;
                    int existingDepartmentId = existingCandidate["DEPARTMENT_ID"]?.Value<int>() ?? departmentId;
                    int existingLocationId = existingCandidate["LOCATION_ID"]?.Value<int>() ?? locationId;
                    int existingAtsHeadRatingId = existingCandidate["ATS_HEAD_RATING_ID"]?.Value<int>() ?? request.AtsHeadRatingId;
                    string existingCandidateName = existingCandidate["CANDIDATE_NAME"]?.ToString() ?? candidateName;
                    string existingMailId = existingCandidate["MAIL_ID"]?.ToString() ?? mailId;
                    string existingPhoneNumber = existingCandidate["PHONE_NUMBER"]?.ToString() ?? phoneNumber;
                    string existingOriginalCv = existingCandidate["CV_NAME"]?.ToString() ?? request.OriginalCvName;
                    string existingSavedCv = existingCandidate["SAVED_CV_NAME"]?.ToString() ?? request.SavedCvName;
                    string existingFileHash = existingCandidate["FILE_HASH"]?.ToString() ?? request.FileHash;
                    string existingStatus = CleanString(request.Status);
                    if (string.IsNullOrWhiteSpace(existingStatus))
                    {
                        existingStatus = existingCandidate["ATS_STATUS"]?.ToString() ?? "LmsApplication";
                    }

                    // Only if ATS_STATUS = Shortlisted then IS_SHORTLISTED = 1 else 0
                    bool existingIsShortlisted = string.Equals(existingStatus, "Shortlisted", StringComparison.OrdinalIgnoreCase);

                    // When ATS_STATUS = 'Duplicate' then IS_DUPLICATE = 1 else 0
                    bool existingIsDuplicate = string.Equals(existingStatus, "Duplicate", StringComparison.OrdinalIgnoreCase);

                    long? existingDuplicateOfLogId = null;
                    long? existingGeneratedCandidateId = existingCandidate["GENERATED_CANDIDATE_ID"]?.Value<long?>() ?? request.GeneratedCandidateId;
                    string existingRegistrationNo = FirstNonEmpty(
                        registrationNo,
                        existingCandidate["REGISTRATION_NO"]?.ToString(),
                        existingGeneratedCandidateId?.ToString());
                    string existingImageLocation = existingCandidate["IMAGE_FILE_LOCATION"]?.ToString() ?? string.Empty;
                    string existingImageName = FirstNonEmpty(
                        existingCandidate["ImageName"]?.ToString(),
                        existingCandidate["IMAGE_NAME"]?.ToString(),
                        !string.IsNullOrWhiteSpace(existingImageLocation) ? Path.GetFileName(existingImageLocation) : string.Empty);

                    // If a new photo file was uploaded
                    if (photoFile != null && photoFile.Length > 0)
                    {
                        string savedLocation = await _bulkResumeService.SaveBulkProfilePicAsync(photoFile);
                        if (!string.IsNullOrWhiteSpace(savedLocation))
                        {
                            existingImageName = Path.GetFileName(savedLocation);
                            existingImageLocation = _bulkResumeService.BuildBulkProfilePicLocation(existingImageName);
                        }
                    }
                    else
                    {
                        string clientImageName = FirstNonEmpty(request.ImageName, Request.HasFormContentType ? Request.Form["ImageName"].ToString() : null, Request.HasFormContentType ? Request.Form["Photo"].ToString() : null);
                        if (!string.IsNullOrWhiteSpace(clientImageName))
                        {
                            existingImageName = Path.GetFileName(clientImageName);
                            existingImageLocation = _bulkResumeService.BuildBulkProfilePicLocation(existingImageName);
                        }
                    }

                    // If a new CV file was uploaded
                    if (cvFile != null && cvFile.Length > 0)
                    {
                        string uploadFolder = _bulkResumeService.GetUploadFolder();
                        (string updateSavedCvName, string updateSavedCvPath) = await _bulkResumeService.SaveResumeTempFileAsync(cvFile, uploadFolder);
                        existingOriginalCv = cvFile.FileName;
                        existingSavedCv = updateSavedCvName;
                        existingFileHash = await _bulkResumeService.ComputeFileHashAsync(updateSavedCvPath);
                    }
                    else if (!string.IsNullOrWhiteSpace(existingSavedCv))
                    {
                        string uploadFolder = _bulkResumeService.GetUploadFolder();
                        string updateSavedCvPath = Path.Combine(uploadFolder, existingSavedCv);
                        if (System.IO.File.Exists(updateSavedCvPath))
                        {
                            existingFileHash = await _bulkResumeService.ComputeFileHashAsync(updateSavedCvPath);
                        }
                    }

                    JObject existingScoreJson = TryParseJsonObject(existingCandidate["FULL_JSON"]?.ToString());
                    JObject existingCandidateJson = TryParseJsonObject(existingCandidate["CANDIDATE_JSON"]?.ToString());

                    if (existingCandidateJson.HasValues)
                    {
                        if (!string.IsNullOrWhiteSpace(existingImageName))
                            existingCandidateJson["ImageName"] = existingImageName;
                        if (!string.IsNullOrWhiteSpace(existingImageLocation))
                            existingCandidateJson["Photo"] = existingImageLocation;
                    }

                    long? updatedId = await _bulkResumeService.SaveBulkResumeAtsScoreAsync(
                        existingPostId,
                        existingCompanyId,
                        existingDepartmentId,
                        existingOriginalCv,
                        existingSavedCv,
                        existingFileHash,
                        existingCandidateName,
                        existingMailId,
                        existingPhoneNumber,
                        existingAtsHeadRatingId,
                        existingGeneratedCandidateId,
                        existingStatus,
                        existingIsShortlisted,
                        existingScoreJson,
                        existingCandidateJson,
                        existingIsDuplicate,
                        existingDuplicateOfLogId,
                        existingImageLocation,
                        existingImageName,
                        candidateId,
                        existingLocationId,
                        existingRegistrationNo);

                    return Ok(new
                    {
                        Success = true,
                        CandidateID = updatedId ?? candidateId
                    });
                }

                // =========================================================================
                // WORKFLOW 1: Insert new candidate (CandidateId == 0 from LMS with CV & Image)
                // =========================================================================
                if (postId <= 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "PostId is required."
                    });
                }

                int atsHeadRatingId = request.AtsHeadRatingId;
                if (atsHeadRatingId <= 0 && Request.HasFormContentType)
                {
                    int.TryParse(Request.Form["AtsHeadRatingId"], out atsHeadRatingId);
                }

                ATSJobDescription? jobDescription = null;
                List<ATSJobDescription> jobs = await _bulkResumeService.GetJobDescriptionsByPostIdAsync(postId);
                if (jobs.Count > 0)
                {
                    jobDescription = jobs.First();
                }

                // Auto-fetch company, department, and atsHeadRatingId from Job Post if not supplied
                if (jobDescription != null)
                {
                    if (companyId <= 0)
                        companyId = jobDescription.CompanyID;

                    if (departmentId <= 0)
                        departmentId = jobDescription.DepartmentID > 0 ? jobDescription.DepartmentID : jobDescription.DEPARTMENT_ID;

                    if (atsHeadRatingId <= 0)
                        atsHeadRatingId = jobDescription.ATS_HEAD_RATING_ID;

                    if (locationId <= 0)
                        locationId = ResolveLocationId(jobDescription);
                }

                // 1. Process and save Image if provided
                string imageName = FirstNonEmpty(request.ImageName, Request.HasFormContentType ? Request.Form["ImageName"].ToString() : null, Request.HasFormContentType ? Request.Form["Photo"].ToString() : null);
                string imageFileLocation = string.Empty;

                if (photoFile != null && photoFile.Length > 0)
                {
                    string savedLocation = await _bulkResumeService.SaveBulkProfilePicAsync(photoFile);
                    if (!string.IsNullOrWhiteSpace(savedLocation))
                    {
                        imageName = Path.GetFileName(savedLocation);
                        imageFileLocation = _bulkResumeService.BuildBulkProfilePicLocation(imageName);
                    }
                }
                else if (!string.IsNullOrWhiteSpace(imageName))
                {
                    imageName = Path.GetFileName(imageName);
                    imageFileLocation = _bulkResumeService.BuildBulkProfilePicLocation(imageName);
                }

                // 2. Process and save CV file to disk if provided
                string originalCvName = CleanString(request.OriginalCvName);
                string savedCvName = CleanString(request.SavedCvName);
                string savedFilePath = string.Empty;
                string fileHash = CleanString(request.FileHash);
                string requestedStatus = CleanString(request.Status);

                if (cvFile != null && cvFile.Length > 0)
                {
                    string uploadFolder = _bulkResumeService.GetUploadFolder();
                    (string savedName, string savedPath) = await _bulkResumeService.SaveResumeTempFileAsync(cvFile, uploadFolder);
                    originalCvName = cvFile.FileName;
                    savedCvName = savedName;
                    savedFilePath = savedPath;
                    fileHash = await _bulkResumeService.ComputeFileHashAsync(savedPath);
                }
                else if (!string.IsNullOrWhiteSpace(savedCvName))
                {
                    string uploadFolder = _bulkResumeService.GetUploadFolder();
                    string candidatePath = Path.Combine(uploadFolder, savedCvName);
                    if (System.IO.File.Exists(candidatePath))
                    {
                        savedFilePath = candidatePath;
                        if (string.IsNullOrWhiteSpace(fileHash))
                        {
                            fileHash = await _bulkResumeService.ComputeFileHashAsync(candidatePath);
                        }
                    }
                }

                // Fallback / default candidate details if not explicitly passed
                if (string.IsNullOrWhiteSpace(candidateName) &&
                    string.IsNullOrWhiteSpace(mailId) &&
                    string.IsNullOrWhiteSpace(phoneNumber))
                {
                    candidateName = !string.IsNullOrWhiteSpace(originalCvName)
                        ? Path.GetFileNameWithoutExtension(originalCvName)
                        : "LMS Candidate";
                }

                if (string.IsNullOrWhiteSpace(registrationNo) && !string.IsNullOrWhiteSpace(mailId))
                {
                    JObject existingRegCheck = await _bulkResumeService.GetExistingCandidateByUsernameOrMailAsync(null, mailId, postId);
                    if (existingRegCheck != null)
                    {
                        long? existingRegId = existingRegCheck["CandidateID"]?.Value<long?>();
                        string foundRegNo = FirstNonEmpty(
                            existingRegCheck["RegistrationNo"]?.ToString(),
                            existingRegCheck["registrationnumber"]?.ToString());
                        registrationNo = !string.IsNullOrWhiteSpace(foundRegNo) ? foundRegNo : "Not Generated";
                        if (!request.GeneratedCandidateId.HasValue || request.GeneratedCandidateId <= 0)
                        {
                            request.GeneratedCandidateId = existingRegId;
                        }
                    }
                }

                // Initialize candidate profile JSON
                JObject candidateJson = TryParseJsonObject(CleanString(request.CandidateJson));
                if (!candidateJson.HasValues)
                {
                    candidateJson = new JObject
                    {
                        ["CandidateName"] = candidateName,
                        ["Name"] = candidateName,
                        ["Email"] = mailId,
                        ["MailId"] = mailId,
                        ["Mobile"] = phoneNumber,
                        ["PhoneNumber"] = phoneNumber,
                        ["ImageName"] = imageName,
                        ["Photo"] = imageFileLocation
                    };
                }
                else
                {
                    if (!string.IsNullOrWhiteSpace(candidateName)) { candidateJson["CandidateName"] = candidateName; candidateJson["Name"] = candidateName; }
                    if (!string.IsNullOrWhiteSpace(mailId)) { candidateJson["Email"] = mailId; candidateJson["MailId"] = mailId; }
                    if (!string.IsNullOrWhiteSpace(phoneNumber)) { candidateJson["Mobile"] = phoneNumber; candidateJson["PhoneNumber"] = phoneNumber; }
                    if (!string.IsNullOrWhiteSpace(imageName)) candidateJson["ImageName"] = imageName;
                    if (!string.IsNullOrWhiteSpace(imageFileLocation)) candidateJson["Photo"] = imageFileLocation;
                }

                // Initialize initial ATS score JSON and status
                bool hasCvFileToProcess = !string.IsNullOrWhiteSpace(savedFilePath) && System.IO.File.Exists(savedFilePath);
                bool initialIsShortlisted = string.Equals(requestedStatus, "Shortlisted", StringComparison.OrdinalIgnoreCase);
                string initialStatus = BulkResumeService.NormalizeAtsStatus(requestedStatus, initialIsShortlisted);

                // When duplicate file detected
                bool isDuplicate = false;

                // DUPLICATE_OF_LOG_ID = NULL
                long? duplicateOfLogId = null;

                JObject initialScoreJson = TryParseJsonObject(CleanString(request.ScoreJson));
                if (!initialScoreJson.HasValues)
                {
                    initialScoreJson = new JObject
                    {
                        ["Source"] = "LMS",
                        ["Status"] = initialStatus
                    };
                }

                // 3. Save candidate record immediately to database to generate CandidateID
                long? bulkResumeAtsScoreLogId = await _bulkResumeService.SaveBulkResumeAtsScoreAsync(
                    postId,
                    companyId,
                    departmentId,
                    originalCvName,
                    savedCvName,
                    fileHash,
                    candidateName,
                    mailId,
                    phoneNumber,
                    atsHeadRatingId,
                    request.GeneratedCandidateId,
                    initialStatus,
                    initialIsShortlisted,
                    initialScoreJson,
                    candidateJson,
                    isDuplicate,
                    duplicateOfLogId,
                    imageFileLocation,
                    imageName,
                    0,
                    locationId,
                    registrationNo);

                long generatedCandidateId = bulkResumeAtsScoreLogId ?? 0;

                // 4. If CV file was uploaded, dispatch CV text extraction and ATS scoring to background queue
                if (hasCvFileToProcess && generatedCandidateId > 0)
                {
                    await _backgroundTaskQueue.QueueBackgroundWorkItem(async token =>
                    {
                        using var scope = _serviceScopeFactory.CreateScope();
                        var bulkResumeService = scope.ServiceProvider.GetRequiredService<BulkResumeService>();
                        await ProcessSingleCandidateAtsScoreInBackgroundAsync(
                            bulkResumeService,
                            generatedCandidateId,
                            postId,
                            companyId,
                            departmentId,
                            locationId,
                            atsHeadRatingId,
                            jobDescription,
                            originalCvName,
                            savedCvName,
                            savedFilePath,
                            fileHash,
                            candidateName,
                            mailId,
                            phoneNumber,
                            imageName,
                            imageFileLocation,
                            registrationNo,
                            token);
                    });
                }

                // 5. Immediately return CandidateID to caller without waiting for AI processing
                return Ok(new
                {
                    Success = true,
                    CandidateID = generatedCandidateId
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

        /// <summary>
        /// Asynchronously extracts CV text and generates ATS score in the background for a newly saved candidate.
        /// Updates the candidate row in BulkResumeAtsScoreLog once AI scoring is completed.
        /// </summary>
        private async Task ProcessSingleCandidateAtsScoreInBackgroundAsync(
            BulkResumeService bulkResumeService,
            long candidateLogId,
            int postId,
            int companyId,
            int departmentId,
            int locationId,
            int atsHeadRatingId,
            ATSJobDescription? jobDescription,
            string originalCvName,
            string savedCvName,
            string savedFilePath,
            string fileHash,
            string candidateName,
            string mailId,
            string phoneNumber,
            string imageName,
            string imageFileLocation,
            string registrationNo,
            CancellationToken token)
        {
            try
            {
                if (candidateLogId <= 0 || !System.IO.File.Exists(savedFilePath))
                    return;

                // 1. Security scan
                ResumeSecurityScanResult scanResult = await bulkResumeService.ScanResumeFileAsync(savedFilePath, originalCvName);
                if (!scanResult.IsSafe)
                {
                    var scanFailedJson = new JObject
                    {
                        ["message"] = "Resume file failed security scan.",
                        ["reason"] = scanResult.Message
                    };

                    await bulkResumeService.SaveBulkResumeAtsScoreAsync(
                        postId, companyId, departmentId, originalCvName, savedCvName, fileHash,
                        candidateName, mailId, phoneNumber, atsHeadRatingId, null,
                        "SecurityScanFailed", false, scanFailedJson, null, false, null,
                        imageFileLocation, imageName, candidateLogId, locationId, registrationNo);
                    return;
                }

                // 2. Extract text content from the uploaded resume file
                string resumeText = await bulkResumeService.ExtractResumeTextAsync(savedFilePath);
                if (string.IsNullOrWhiteSpace(resumeText) || resumeText.StartsWith("[Unsupported", StringComparison.OrdinalIgnoreCase))
                {
                    var extractionFailedJson = new JObject
                    {
                        ["message"] = "Resume text could not be extracted.",
                        ["reason"] = resumeText
                    };

                    await bulkResumeService.SaveBulkResumeAtsScoreAsync(
                        postId, companyId, departmentId, originalCvName, savedCvName, fileHash,
                        candidateName, mailId, phoneNumber, atsHeadRatingId, null,
                        "ExtractionFailed", false, extractionFailedJson, null, false, null,
                        imageFileLocation, imageName, candidateLogId, locationId, registrationNo);
                    return;
                }

                // 3. Parse structured candidate contact details and experience from resume text (matching Line 343)
                JObject candidateJson;
                try
                {
                    candidateJson = await bulkResumeService.ParseCandidateResumeJsonAsync(resumeText);
                }
                catch
                {
                    candidateJson = new JObject();
                }

                // Fallback / merge contact info if not provided in original request
                if (string.IsNullOrWhiteSpace(candidateName))
                {
                    candidateName = bulkResumeService.GetCandidateName(candidateJson);
                }
                if (string.IsNullOrWhiteSpace(mailId))
                {
                    mailId = bulkResumeService.GetJsonString(candidateJson, "Email");
                }
                if (string.IsNullOrWhiteSpace(phoneNumber))
                {
                    phoneNumber = bulkResumeService.GetJsonString(candidateJson, "Mobile");
                    if (string.IsNullOrWhiteSpace(phoneNumber))
                    {
                        phoneNumber = bulkResumeService.GetJsonString(candidateJson, "Phone");
                    }
                }

                if (string.IsNullOrWhiteSpace(registrationNo) && !string.IsNullOrWhiteSpace(mailId))
                {
                    JObject existingCandidate = await bulkResumeService.GetExistingCandidateByUsernameOrMailAsync(null, mailId, postId);
                    if (existingCandidate != null)
                    {
                        long? existingRegCandidateId = existingCandidate["CandidateID"]?.Value<long?>();
                        string foundRegNo = FirstNonEmpty(
                            existingCandidate["RegistrationNo"]?.ToString(),
                            existingCandidate["registrationnumber"]?.ToString());
                        registrationNo = !string.IsNullOrWhiteSpace(foundRegNo) ? foundRegNo : "Not Generated";
                    }
                }

                // Merge caller-provided values into extracted candidateJson
                if (!string.IsNullOrWhiteSpace(candidateName))
                {
                    candidateJson["CandidateName"] = candidateName;
                    candidateJson["Name"] = candidateName;
                }
                if (!string.IsNullOrWhiteSpace(mailId))
                {
                    candidateJson["Email"] = mailId;
                    candidateJson["MailId"] = mailId;
                }
                if (!string.IsNullOrWhiteSpace(phoneNumber))
                {
                    candidateJson["Mobile"] = phoneNumber;
                    candidateJson["PhoneNumber"] = phoneNumber;
                }
                if (!string.IsNullOrWhiteSpace(imageName))
                {
                    candidateJson["ImageName"] = imageName;
                }
                if (!string.IsNullOrWhiteSpace(imageFileLocation))
                {
                    candidateJson["Photo"] = imageFileLocation;
                }

                // 5. Check ATS rating criteria and Job Description
                if (jobDescription == null)
                {
                    List<ATSJobDescription> jobs = await bulkResumeService.GetJobDescriptionsByPostIdAsync(postId);
                    jobDescription = jobs.FirstOrDefault();
                }

                if (atsHeadRatingId <= 0 && jobDescription != null)
                {
                    atsHeadRatingId = jobDescription.ATS_HEAD_RATING_ID;
                }

                JObject scoreJson;
                string status = "LmsApplication";
                bool isShortlisted = false;

                if (atsHeadRatingId > 0 && jobDescription != null)
                {
                    try
                    {
                        AtsPromptResult promptResult = await bulkResumeService.GenerateBulkPromptFromAtsHeadRatingAsync(atsHeadRatingId, jobDescription, resumeText, candidateJson);
                        string scoreResponse = await bulkResumeService.SendGptMessageAsync(promptResult.Prompt);

                        try
                        {
                            scoreJson = bulkResumeService.CleanAndParseJson(scoreResponse);
                        }
                        catch
                        {
                            scoreJson = bulkResumeService.BuildAtsScoreParseFailedJson(scoreResponse, promptResult);
                        }

                        scoreJson = bulkResumeService.SanitizeAndValidateAtsScoreJson(scoreJson, promptResult);
                        isShortlisted = bulkResumeService.IsAtsShortlisted(scoreJson);
                        status = isShortlisted ? "Shortlisted" : "Rejected";
                    }
                    catch (Exception gptEx)
                    {
                        scoreJson = new JObject
                        {
                            ["Source"] = "LMS",
                            ["Status"] = "Rejected",
                            ["Error"] = gptEx.Message
                        };
                        status = "Rejected";
                        isShortlisted = false;
                    }
                }
                else
                {
                    scoreJson = new JObject
                    {
                        ["Source"] = "LMS",
                        ["Status"] = "Rejected",
                        ["Note"] = "ATS rating configuration is not mapped for this job post."
                    };
                    status = "Rejected";
                    isShortlisted = false;
                }

                status = BulkResumeService.NormalizeAtsStatus(status, isShortlisted);

                // 6. Update candidate row in BulkResumeAtsScoreLog with calculated score, candidate JSON, status, and shortlist flag
                bool isDuplicate = false;
                long? duplicateOfLogId = null;

                await bulkResumeService.SaveBulkResumeAtsScoreAsync(
                    postId,
                    companyId,
                    departmentId,
                    originalCvName,
                    savedCvName,
                    fileHash,
                    candidateName,
                    mailId,
                    phoneNumber,
                    atsHeadRatingId,
                    null,
                    status,
                    isShortlisted,
                    scoreJson,
                    candidateJson,
                    isDuplicate,
                    duplicateOfLogId,
                    imageFileLocation,
                    imageName,
                    candidateLogId,
                    locationId,
                    registrationNo);
            }
            catch (Exception ex)
            {
                try
                {
                    var errorJson = new JObject
                    {
                        ["message"] = "Background candidate ATS evaluation failed.",
                        ["error"] = ex.Message
                    };

                    await bulkResumeService.SaveBulkResumeAtsScoreAsync(
                        postId, companyId, departmentId, originalCvName, savedCvName, fileHash,
                        candidateName, mailId, phoneNumber, atsHeadRatingId, null,
                        "EvaluationError", false, errorJson, null, false, null,
                        imageFileLocation, imageName, candidateLogId, locationId, registrationNo);
                }
                catch
                {
                    // Ignore secondary logging failures
                }
            }
        }

        /// <summary>
        /// Retrieves the bulk resume pipeline report with filters and aggregation metrics (Total, Shortlisted, Rejected, Exam Pending, Created).
        /// </summary>
        /// <param name="companyId">Optional filter for Company ID.</param>
        /// <param name="departmentId">Optional filter for Department ID.</param>
        /// <param name="postId">Optional filter for Job Post ID.</param>
        /// <param name="keyword">Optional text search keyword for candidate name, email, or post.</param>
        /// <param name="fromDate">Optional start date filter.</param>
        /// <param name="toDate">Optional end date filter.</param>
        /// <param name="take">Maximum number of records to return (defaults to 500).</param>
        /// <returns>HTTP 200 OK containing filter parameters, summary metrics, and detailed row data.</returns>
        [HttpGet("bulk-resume-pipeline-report")]
        public async Task<IActionResult> GetBulkResumePipelineReport(
            [FromQuery] int? companyId,
            [FromQuery] int? departmentId,
            [FromQuery] int? postId,
            [FromQuery] int? locationId,
            [FromQuery] string? keyword,
            [FromQuery] DateTime? fromDate,
            [FromQuery] DateTime? toDate,
            [FromQuery] int take = 500)
        {
            try
            {
                List<Dictionary<string, object?>> rows = await _bulkResumeService.GetBulkResumeAtsReportAsync(
                    companyId,
                    departmentId,
                    postId,
                    locationId,
                    keyword,
                    fromDate,
                    toDate,
                    take);

                // Calculate summary aggregation statistics
                int total = rows.Count;
                int atsShortlisted = rows.Count(x => string.Equals(GetReportValue(x, "ATS_STATUS")?.ToString(), "Shortlisted", StringComparison.OrdinalIgnoreCase) || GetReportBool(x, "IS_SHORTLISTED"));
                int atsRejected = rows.Count(x => string.Equals(GetReportValue(x, "ATS_STATUS")?.ToString(), "Rejected", StringComparison.OrdinalIgnoreCase));
                int examPending = rows.Count(x => string.Equals(GetReportValue(x, "EXAM_STATUS_DISPLAY")?.ToString(), "Pending", StringComparison.OrdinalIgnoreCase));
                int finalCreated = rows.Count(x => GetReportValue(x, "GENERATED_CANDIDATE_ID") != null);

                return Ok(new
                {
                    Success = true,
                    Filters = new
                    {
                        companyId,
                        departmentId,
                        postId,
                        locationId,
                        keyword,
                        fromDate,
                        toDate,
                        take
                    },
                    Summary = new
                    {
                        Total = total,
                        AtsShortlisted = atsShortlisted,
                        AtsRejected = atsRejected,
                        ExamPending = examPending,
                        FinalCreated = finalCreated
                    },
                    Data = rows
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

        /// <summary>
        /// Safely extracts a nullable value from a dictionary row, mapping DBNull to null.
        /// </summary>
        private static object? GetReportValue(Dictionary<string, object?> row, string key)
        {
            return row.TryGetValue(key, out object? value) && value != DBNull.Value ? value : null;
        }

        /// <summary>
        /// Safely evaluates a boolean flag from a dictionary row.
        /// </summary>
        private static bool GetReportBool(Dictionary<string, object?> row, string key)
        {
            object? value = GetReportValue(row, key);

            if (value == null)
                return false;

            if (value is bool boolValue)
                return boolValue;

            return bool.TryParse(value.ToString(), out bool parsed) && parsed;
        }

        private static int GetJsonInt(JObject json, string key)
        {
            if (json == null)
                return 0;

            JToken? token = json[key];
            if (token == null || token.Type == JTokenType.Null)
                return 0;

            if (token.Type == JTokenType.Integer)
                return token.Value<int>();

            return int.TryParse(token.ToString(), out int value) ? value : 0;
        }

        private static int ResolveLocationId(ATSJobDescription? jobDescription)
        {
            if (jobDescription == null)
                return 0;

            if (jobDescription.LocationID > 0)
                return jobDescription.LocationID;

            if (jobDescription.LOCATION_ID > 0)
                return jobDescription.LOCATION_ID;

            return 0;
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

        /// <summary>
        /// Retrieves the list of active companies for bulk resume dropdown filters.
        /// </summary>
        /// <returns>HTTP 200 OK with company master data list.</returns>
        [HttpGet("bulk-resume-company-list")]
        public async Task<IActionResult> GetBulkResumeCompanyList()
        {
            try
            {
                return Ok(new
                {
                    Success = true,
                    Data = await _bulkResumeService.GetBulkResumeCompanyListAsync()
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Success = false, Message = ex.Message });
            }
        }

        /// <summary>
        /// Retrieves the list of departments for bulk resume dropdown filters.
        /// </summary>
        /// <returns>HTTP 200 OK with department master data list.</returns>
        [HttpGet("bulk-resume-department-list")]
        public async Task<IActionResult> GetBulkResumeDepartmentList()
        {
            try
            {
                return Ok(new
                {
                    Success = true,
                    Data = await _bulkResumeService.GetBulkResumeDepartmentListAsync()
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Success = false, Message = ex.Message });
            }
        }

        /// <summary>
        /// Retrieves the list of job posts filtered optionally by company and department.
        /// </summary>
        /// <param name="companyId">Optional company identifier filter.</param>
        /// <param name="departmentId">Optional department identifier filter.</param>
        /// <returns>HTTP 200 OK with job post list.</returns>
        [HttpGet("bulk-resume-post-list")]
        public async Task<IActionResult> GetBulkResumePostList([FromQuery] int? companyId, [FromQuery] int? departmentId)
        {
            try
            {
                return Ok(new
                {
                    Success = true,
                    Data = await _bulkResumeService.GetBulkResumePostListAsync(companyId, departmentId)
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Success = false, Message = ex.Message });
            }
        }

        /// <summary>
        /// Returns a lightweight, display-safe candidate snapshot for LMS / Exam portal interfaces.
        /// </summary>
        /// <remarks>
        /// Exam portal candidate snapshot:
        /// LMS or exam UI calls this API using the TempCandidateId (BulkResumeAtsScoreLogID)
        /// prior to rendering the exam page. It returns only display-safe candidate details, omitting full ATS JSON.
        /// </remarks>
        /// <param name="CandidateId">The temporary candidate ID (BulkResumeAtsScoreLogID).</param>
        /// <returns>HTTP 200 OK with candidate snapshot details, or HTTP 404 NotFound if not found.</returns>
        [HttpGet("resume-candidate")]
        public async Task<IActionResult> GetBulkResumeCandidateSnapshot([FromQuery] long CandidateId)
        {
            try
            {
                if (CandidateId <= 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Candidate id is required."
                    });
                }

                JObject tempCandidate = await _bulkResumeService.GetBulkResumeAtsScoreLogByIdAsync(CandidateId);

                if (tempCandidate == null)
                {
                    return NotFound(new
                    {
                        Success = false,
                        CandidateId = CandidateId,
                        Message = "Candidate not found."
                    });
                }

                int postId = tempCandidate["POST_ID"]?.Value<int>() ?? 0;
                string candidateJsonText = tempCandidate["CANDIDATE_JSON"]?.ToString();
                JObject candidateJson = TryParseJsonObject(candidateJsonText);
                List<ATSJobDescription> jobs = postId > 0
                    ? await _bulkResumeService.GetJobDescriptionsByPostIdAsync(postId)
                    : new List<ATSJobDescription>();

                ATSJobDescription? jobDescription = jobs.FirstOrDefault();
                string candidateName = FirstNonEmpty(
                    tempCandidate["CANDIDATE_NAME"]?.ToString(),
                    _bulkResumeService.GetCandidateName(candidateJson));
                string email = FirstNonEmpty(
                    tempCandidate["MAIL_ID"]?.ToString(),
                    _bulkResumeService.GetJsonString(candidateJson, "Email"));
                string phone = FirstNonEmpty(
                    tempCandidate["PHONE_NUMBER"]?.ToString(),
                    _bulkResumeService.GetJsonString(candidateJson, "Mobile"));
                string professionalExperience = FirstNonEmpty(
                    GetJsonStringAny(candidateJson, "ProfessionalExperience", "ProfessionalExp", "TotalExperience", "Experience", "WorkExperience"),
                    "-");
                string generatedCandidateId = tempCandidate["GENERATED_CANDIDATE_ID"]?.ToString();
                string registrationNo = FirstNonEmpty(
                    tempCandidate["REGISTRATION_NO"]?.ToString(),
                    generatedCandidateId);
                string profilePicLocation = tempCandidate["IMAGE_FILE_LOCATION"]?.ToString()?.Trim() ?? string.Empty;
                string imageNameFromLog = FirstNonEmpty(
                    tempCandidate["ImageName"]?.ToString()?.Trim(),
                    tempCandidate["IMAGE_NAME"]?.ToString()?.Trim(),
                    !string.IsNullOrWhiteSpace(profilePicLocation) ? Path.GetFileName(profilePicLocation) : string.Empty);
                bool profilePicAvailable = !string.IsNullOrWhiteSpace(profilePicLocation);

                return Ok(new
                {
                    Success = true,
                    CandidateSnapshot = new
                    {
                        Candidate = DisplayOrDash(candidateName),
                        CandidateID = CandidateId,
                        RegistrationNo = DisplayOrDash(registrationNo),
                        Email = DisplayOrDash(email),
                        Phone = DisplayOrDash(phone),
                        ProfessionalExp = DisplayOrDash(professionalExperience),
                        AppliedPost = DisplayOrDash(jobDescription?.POST),
                        ProfilePicAvailable = profilePicAvailable,
                        ProfilePicLocation = DisplayOrDash(profilePicLocation),
                        ImageName = DisplayOrDash(imageNameFromLog)
                    }
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

        /// <summary>
        /// Manually initiates candidate registration (EAF generation) in the core recruitment system.
        /// </summary>
        /// <remarks>
        /// Manual HR Send EAF / Candidate registration flow:
        /// When HR clicks "Send EAF" or "Generate ID" for a candidate, this endpoint calls 
        /// <see cref="BulkResumeService.RegisterBulkResumeCandidateManuallyAsync"/>.
        /// It registers the candidate in the recruitment database, generates a Candidate ID,
        /// sends login credentials via email, and updates the BulkResumeAtsScoreLog.
        /// </remarks>
        /// <param name="request">Payload containing the TempCandidateId (BulkResumeAtsScoreLogID) and an optional HR manual reason.</param>
        /// <returns>HTTP 200 OK on success, or HTTP 400 Bad Request on failure.</returns>
        [HttpPost("bulk-resume-send-eaf")]
        [HttpPost("bulk-resume-create-candidate")]
        public async Task<IActionResult> SendBulkResumeEafManually([FromBody] BulkResumeManualExamLinkRequest request)
        {
            try
            {
                if (request == null || request.TempCandidateId <= 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Temp candidate id is required."
                    });
                }

                JObject result = await _bulkResumeService.RegisterBulkResumeCandidateManuallyAsync(
                    request.TempCandidateId,
                    request.ManualReason ?? string.Empty,
                    request.LocationId);

                bool success = result["Success"]?.Value<bool>() ?? false;
                var response = new
                {
                    Success = success,
                    Message = result["Message"]?.ToString() ?? string.Empty,
                    TempCandidateId = result["TempCandidateId"]?.Value<long?>() ?? request.TempCandidateId,
                    CandidateId = result["CandidateId"]?.Value<long?>()
                };

                if (success)
                {
                    return Ok(response);
                }

                return BadRequest(response);
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

        /// <summary>
        /// Manually triggers dispatch of an LMS exam link email to a bulk resume candidate.
        /// </summary>
        /// <remarks>
        /// Allows HR to send an exam link for both ATS-shortlisted and ATS-failed candidates.
        /// Supports situations where JD exam tagging was performed after the initial upload.
        /// Requires a valid ExamTaggingID on the associated Job Description.
        /// </remarks>
        /// <param name="request">Payload specifying the candidate identifier and manual reason.</param>
        /// <returns>HTTP 200 OK indicating the email was queued, or HTTP 400 Bad Request if prerequisites fail.</returns>
        [HttpPost("bulk-resume-send-exam-link")]
        public async Task<IActionResult> SendBulkResumeExamLinkManually([FromBody] BulkResumeManualExamLinkRequest request)
        {
            try
            {
                if (request == null || request.TempCandidateId <= 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Temp candidate id is required."
                    });
                }

                JObject tempCandidate = await _bulkResumeService.GetBulkResumeAtsScoreLogByIdAsync(request.TempCandidateId);

                if (tempCandidate == null)
                {
                    return NotFound(new
                    {
                        Success = false,
                        TempCandidateId = request.TempCandidateId,
                        Message = $"Candidate with TempCandidateId {request.TempCandidateId} was not found."
                    });
                }

                int postId = GetJsonInt(tempCandidate, "POST_ID");
                int locationId = request.LocationId > 0
                    ? request.LocationId
                    : GetJsonInt(tempCandidate, "LOCATION_ID");
                string mailId = FirstNonEmpty(
                    tempCandidate["MAIL_ID"]?.ToString(),
                    tempCandidate["MailId"]?.ToString(),
                    tempCandidate["Email"]?.ToString());
                string candidateName = FirstNonEmpty(
                    tempCandidate["CANDIDATE_NAME"]?.ToString(),
                    tempCandidate["CandidateName"]?.ToString(),
                    "Candidate");

                if (postId <= 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        TempCandidateId = request.TempCandidateId,
                        Message = "PostId is missing for this temp candidate. Exam link cannot be sent."
                    });
                }

                if (locationId <= 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        TempCandidateId = request.TempCandidateId,
                        Message = "LocationId is required. Exam link cannot be sent."
                    });
                }

                if (string.IsNullOrWhiteSpace(mailId))
                {
                    return BadRequest(new
                    {
                        Success = false,
                        TempCandidateId = request.TempCandidateId,
                        Message = "Candidate email is not available. Exam link cannot be sent."
                    });
                }

                List<ATSJobDescription> jobs = await _bulkResumeService.GetJobDescriptionsByPostIdAsync(postId);

                if (jobs.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        TempCandidateId = request.TempCandidateId,
                        Message = "Job description not found."
                    });
                }

                ATSJobDescription jobDescription = SelectJobDescriptionForLocation(jobs, locationId);

                if (jobDescription.ExamTaggingID == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        TempCandidateId = request.TempCandidateId,
                        Message = "Exam is not tagged for this job post. Manual exam link cannot be sent."
                    });
                }

                int companyId = jobDescription.CompanyID > 0
                    ? jobDescription.CompanyID
                    : GetJsonInt(tempCandidate, "COMPANY_ID");

                int departmentId = jobDescription.DepartmentID > 0
                    ? jobDescription.DepartmentID
                    : (jobDescription.DEPARTMENT_ID > 0 ? jobDescription.DEPARTMENT_ID : GetJsonInt(tempCandidate, "DEPARTMENT_ID"));

                var mailRequest = new LmsExamLinkMailRequest
                {
                    CandidateId = request.TempCandidateId,
                    CandidateMailId = mailId,
                    CandidateName = candidateName,
                    CompanyName = jobDescription.COMPANY_NAME,
                    AppliedPost = jobDescription.POST,
                    DepartmentName = jobDescription.DEPARTMENT_NAME,
                    locationName = jobDescription.LOCATION_NAME,
                    ExamTaggingId = jobDescription.ExamTaggingID,
                    CompanyId = companyId,
                    DepartmentId = departmentId,
                    PostId = postId,
                    LocationId = locationId
                };

                // Queue exam link email dispatch via background queue
                await QueueBulkResumeExamLinkAsync(mailRequest);

                return Ok(new
                {
                    Success = true,
                    TempCandidateId = request.TempCandidateId,
                    CandidateName = candidateName,
                    MailId = mailId,
                    AtsStatus = tempCandidate["ATS_STATUS"]?.ToString() ?? string.Empty,
                    LocationId = locationId,
                    ManualReason = request.ManualReason ?? string.Empty,
                    Message = $"Exam link email queued successfully for {candidateName}."
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

        /// <summary>
        /// Generates an LMS assessment exam link for a given Job Post, Company, and Department with CandidateId = 0.
        /// Used by recruitment UI when selecting Company, Department, and Post to generate a generic exam link prior to candidate identification.
        /// </summary>
        /// <param name="postId">The target Job Post ID.</param>
        /// <param name="companyId">Optional Company ID (auto-fetched from Job Post if not provided).</param>
        /// <param name="departmentId">Optional Department ID (auto-fetched from Job Post if not provided).</param>
        /// <param name="candidateId">Candidate ID (defaults to 0 for generic exam links).</param>
        /// <returns>HTTP 200 OK with the generated ExamLink, ExamTaggingId, and job metadata.</returns>
        [HttpGet("generate-exam-link")]
        [HttpPost("generate-exam-link")]
        public async Task<IActionResult> GenerateExamLink([FromQuery] int postId,[FromQuery] int? companyId = null,[FromQuery] int? departmentId = null,[FromQuery] int? locationId = null,[FromQuery] long candidateId = 0)
        {
            try
            {
                if (postId <= 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "PostId is required."
                    });
                }

                List<ATSJobDescription> jobs = await _bulkResumeService.GetJobDescriptionsByPostIdAsync(postId);

                if (jobs.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        PostId = postId,
                        Message = "Job description not found."
                    });
                }

                ATSJobDescription jobDescription = jobs.First();

                if (jobDescription.ExamTaggingID == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        PostId = postId,
                        Post = jobDescription.POST,
                        Message = "Exam is not tagged for this job post. Exam link cannot be generated."
                    });
                }

                int resolvedCompanyId = (companyId.HasValue && companyId.Value > 0)
                    ? companyId.Value
                    : jobDescription.CompanyID;

                int resolvedDepartmentId = (departmentId.HasValue && departmentId.Value > 0)
                    ? departmentId.Value
                    : (jobDescription.DepartmentID > 0 ? jobDescription.DepartmentID : jobDescription.DEPARTMENT_ID);
                int resolvedLocationId = (locationId.HasValue && locationId.Value > 0)
                    ? locationId.Value
                    : (jobDescription.LocationID > 0 ? jobDescription.LocationID : jobDescription.LOCATION_ID);

                string companyName = jobDescription.COMPANY_NAME ?? string.Empty;
                string postName = jobDescription.POST ?? jobDescription.JobTitle ?? string.Empty;
                string departmentName = jobDescription.DEPARTMENT_NAME ?? string.Empty;
                string locationName = jobDescription.LOCATION_NAME ?? string.Empty;

                string examLink = _lmsExamLinkService.BuildExamLink(
                    jobDescription.ExamTaggingID,
                    resolvedCompanyId,
                    resolvedDepartmentId,
                    postId,
                    resolvedLocationId,
                    candidateId,
                    string.Empty,
                    companyName,
                    postName,
                    departmentName,
                    locationName);

                return Ok(new
                {
                    Success = true,
                    PostId = postId,
                    CompanyId = resolvedCompanyId,
                    DepartmentId = resolvedDepartmentId,
                    LocationId = resolvedLocationId,
                    ExamTaggingId = jobDescription.ExamTaggingID,
                    CandidateId = candidateId,
                    AppliedPost = postName,
                    PostName = postName,
                    CompanyName = companyName,
                    DepartmentName = departmentName,
                    LocationName = locationName,
                    ExamLink = examLink
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

        /// <summary>
        /// Webhook callback endpoint invoked by LMS to submit exam results for single or batch candidate submissions.
        /// </summary>
        /// <param name="request">Dynamic JSON token containing either a single object or an array of <see cref="BulkResumeExamResultRequest"/>.</param>
        /// <returns>HTTP 200 OK with processing results for each candidate.</returns>
        [HttpPost("bulk-resume-exam-result")]
        public async Task<IActionResult> BulkResumeExamResult([FromBody] List<BulkResumeExamResultRequest> requests)
        {
            try
            {
                if (requests == null || requests.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "At least one candidate result is required."
                    });
                }

                var results = new List<object>();

                foreach (var item in requests)
                {
                    results.Add(await ProcessBulkResumeExamResult(item));
                }

                return Ok(results);
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

        /// <summary>
        /// Handles the business logic for recording an LMS exam result against either a permanent recruitment candidate
        /// (<c>HEAD_ATS_SCORE</c>) or a temporary bulk resume candidate log (<c>BulkResumeAtsScoreLog</c>).
        /// </summary>
        /// <param name="request">Exam result payload containing marks, shortlist status, and candidate identifiers.</param>
        /// <returns>Response object indicating updated table or error details.</returns>
        private async Task<object> ProcessBulkResumeExamResult(BulkResumeExamResultRequest request)
        {
            try
            {
                if (request == null)
                {
                    return new
                    {
                        Success = false,
                        Message = "Request body is required."
                    };
                }

                /*
                 * LMS callback flow:
                 * 1. candidateId can be a real recruitment CandidateId.
                 * 2. If that real candidate exists, save the exam result into HEAD_ATS_SCORE.
                 * 3. If no real candidate exists, treat candidateId as TempCandidateId
                 *    (BulkResumeAtsScoreLogID) and update BulkResumeAtsScoreLog.
                 * 4. If neither record exists, return failure payload.
                 */
                long candidateIdFromLms = request.CandidateId.GetValueOrDefault();
                long tempCandidateId = request.TempCandidateId.GetValueOrDefault() > 0 ? request.TempCandidateId.GetValueOrDefault(): candidateIdFromLms;
                decimal examMarksObtainScore = request.ExamMarksObtainScore;
                bool isShortlisted = request.IsShortlisted;

                if (candidateIdFromLms <= 0 && tempCandidateId <= 0)
                {
                    return new
                    {
                        Success = false,
                        Message = "Candidate id is required."
                    };
                }
                // Check if temporary bulk candidate log exists
                JObject tempCandidate = await _bulkResumeService.GetBulkResumeAtsScoreLogByIdAsync(tempCandidateId);

                if (tempCandidate != null)
                {
                    await _bulkResumeService.UpdateBulkResumeExamResultAsync(tempCandidateId, examMarksObtainScore, isShortlisted, null);

                    return new
                    {
                        Success = true,
                        TempCandidateId = tempCandidateId,
                        ExamMarksObtainScore = examMarksObtainScore,
                        IsShortlisted = isShortlisted,
                        CandidateName = FirstNonEmpty(tempCandidate["CANDIDATE_NAME"]?.ToString(), tempCandidate["CandidateName"]?.ToString()),
                        MailId = FirstNonEmpty(tempCandidate["MAIL_ID"]?.ToString(), tempCandidate["MailId"]?.ToString(), tempCandidate["Email"]?.ToString()),
                        PhoneNumber = FirstNonEmpty(tempCandidate["PHONE_NUMBER"]?.ToString(), tempCandidate["PhoneNumber"]?.ToString(), tempCandidate["Mobile"]?.ToString()),
                        UpdatedTable = "BulkResumeAtsScoreLog",
                        Message = "Exam result saved for temporary bulk resume candidate."
                    };
                }
                // Check if candidate exists in primary recruitment table
                if (candidateIdFromLms > 0 && await _bulkResumeService.RecruitmentCandidateExistsAsync(candidateIdFromLms))
                {
                    await _bulkResumeService.SaveLmsExamResultToHeadAtsScoreAsync(candidateIdFromLms, examMarksObtainScore, isShortlisted);

                    return new
                    {
                        Success = true,
                        CandidateId = candidateIdFromLms,
                        ExamMarksObtainScore = examMarksObtainScore,
                        IsShortlisted = isShortlisted,
                        UpdatedTable = "HEAD_ATS_SCORE",
                        Message = "Exam result saved for existing recruitment candidate."
                    };
                }

                

                return new
                {
                    Success = false,
                    CandidateId = candidateIdFromLms > 0 ? (long?)candidateIdFromLms : null,
                    TempCandidateId = tempCandidateId > 0 ? (long?)tempCandidateId : null,
                    Message = "Candidate id was not found in recruitment candidates or BulkResumeAtsScoreLog."
                };
            }
            catch (Exception ex)
            {
                return new
                {
                    Success = false,
                    Message = ex.Message
                };
            }
        }

        /// <summary>
        /// Attempts to parse a JSON string into a <see cref="JObject"/>, returning an empty object if parsing fails.
        /// </summary>
        /// <param name="jsonText">Raw JSON text.</param>
        /// <returns>Parsed <see cref="JObject"/> or an empty <see cref="JObject"/>.</returns>
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

        /// <summary>
        /// Cleans a string input by stripping whitespace and treating Swagger default dummy placeholder values ("string") as empty.
        /// </summary>
        private static string CleanString(string? value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return string.Empty;

            string trimmed = value.Trim();
            if (trimmed.Equals("string", StringComparison.OrdinalIgnoreCase) || trimmed.Equals("\"string\"", StringComparison.OrdinalIgnoreCase))
                return string.Empty;

            return trimmed;
        }

        /// <summary>
        /// Returns the first non-null, non-whitespace string from a collection of candidate strings.
        /// </summary>
        /// <param name="values">Array of candidate strings in priority order.</param>
        /// <returns>First trimmed non-empty string or <see cref="string.Empty"/>.</returns>
        private static string FirstNonEmpty(params string?[] values)
        {
            foreach (string? value in values)
            {
                string cleaned = CleanString(value);
                if (!string.IsNullOrWhiteSpace(cleaned))
                    return cleaned;
            }

            return string.Empty;
        }

        /// <summary>
        /// Returns a trimmed string or a dash ("-") placeholder if null or empty.
        /// </summary>
        /// <param name="value">Input string value.</param>
        /// <returns>Trimmed string or "-".</returns>
        private static string DisplayOrDash(string? value)
        {
            return string.IsNullOrWhiteSpace(value) ? "-" : value.Trim();
        }

        /// <summary>
        /// Validates that the provided <see cref="ATSJobDescription"/> contains meaningful text content.
        /// </summary>
        /// <param name="jobDescription">Job description model to inspect.</param>
        /// <returns><c>true</c> if valid words are found; otherwise <c>false</c>.</returns>
        private static bool HasProperJobDescription(ATSJobDescription jobDescription)
        {
            if (jobDescription == null)
                return false;

            string jdText = string.Join(" ", new[]
            {
                jobDescription.JobTitle,
                jobDescription.Objectives,
                jobDescription.JobDescription,
                jobDescription.Age,
                jobDescription.Qualifications,
                jobDescription.JobResponsibility,
                jobDescription.RequiredSkill,
                jobDescription.TechnicalScope,
                jobDescription.Experience,
                jobDescription.Others,
                jobDescription.Compensate,
                jobDescription.AdministrativeScope
            });

            return jdText
                .Split(' ', StringSplitOptions.RemoveEmptyEntries)
                .Any(word => word.Trim().Length >= 3);
        }

        /// <summary>
        /// Searches a <see cref="JObject"/> for the first property matching any of the specified names and returns its non-empty string value.
        /// </summary>
        /// <param name="json">Source JSON object.</param>
        /// <param name="propertyNames">Candidate property names in priority order.</param>
        /// <returns>Found property value string, or <see cref="string.Empty"/>.</returns>
        private static string GetJsonStringAny(JObject json, params string[] propertyNames)
        {
            foreach (string propertyName in propertyNames)
            {
                string value = json[propertyName]?.ToString()?.Trim() ?? string.Empty;

                if (!string.IsNullOrWhiteSpace(value))
                    return value;
            }

            return string.Empty;
        }

        /// <summary>
        /// Extracts the most informative error or success message from a signup response JSON.
        /// </summary>
        /// <param name="signupResult">Signup response JSON.</param>
        /// <param name="fallbackMessage">Default message if none found in JSON.</param>
        /// <returns>Descriptive message string.</returns>
        private static string GetSignupResultMessage(JObject signupResult, string fallbackMessage)
        {
            if (signupResult == null)
                return fallbackMessage;

            string message = FirstNonEmpty(
                signupResult["Message"]?.ToString(),
                signupResult["RegisterCandidateResult"]?.ToString(),
                signupResult["RawResponse"]?.ToString());

            return string.IsNullOrWhiteSpace(message) ? fallbackMessage : message;
        }

        /// <summary>
        /// Queues an LMS exam link email dispatch to the background worker.
        /// </summary>
        /// <param name="mailRequest">Email request details.</param>
        private async Task QueueBulkResumeExamLinkAsync(LmsExamLinkMailRequest mailRequest)
        {
            /*
             * Shared LMS mail queue helper:
             * Exam links are queued only after a manual HR action.
             */
            await _backgroundTaskQueue.QueueBackgroundWorkItem(async token =>
            {
                using var scope = _serviceScopeFactory.CreateScope();
                var lmsExamLinkService = scope.ServiceProvider.GetRequiredService<LmsExamLinkService>();

                await lmsExamLinkService.SendBulkResumeExamLinkAsync(mailRequest);
            });
        }


        /// <summary>
        /// Uploads up to 50 resumes scored against a directly uploaded/pasted Job Description and selected ATS configuration.
        /// </summary>
        [HttpPost("bulk-resume-custom-jd-upload")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> BulkResumeCustomJdUpload([FromForm] BulkResumeCustomJdUploadRequest request)
        {
            int atsConfigId = request.AtsConfigId;
            string? roleTitle = request.RoleTitle;
            string? jdText = request.JdText;
            IFormFile? jdFile = request.JdFile;
            List<IFormFile> resumes = request.Resumes;
            int locationId = request.LocationId;
            int companyId = request.CompanyId;
            int departmentId = request.DepartmentId;
            try
            {
                if (atsConfigId <= 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Please select an ATS Configuration."
                    });
                }

                if ((jdFile == null || jdFile.Length == 0) && string.IsNullOrWhiteSpace(jdText))
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Please upload a Job Description file or provide Job Description text."
                    });
                }

                if (resumes == null || resumes.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Please upload at least one resume."
                    });
                }

                if (resumes.Count > 50)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        MaxAllowed = 50,
                        UploadedCount = resumes.Count,
                        Message = "Maximum 50 resumes are allowed in one bulk upload."
                    });
                }

                // 1. Extract and structure the Job Description using the JD extraction prompt
                ATSJobDescription jobDescription = await _bulkResumeService.ParseJobDescriptionFromTextOrFileAsync(jdText, jdFile, atsConfigId, roleTitle);
                jobDescription.CompanyID = companyId;
                jobDescription.DepartmentID = departmentId;
                jobDescription.LocationID = locationId;

                string uploadFolder = _bulkResumeService.GetUploadFolder();
                var queuedFiles = new List<BulkResumeQueuedFile>();
                var rejectedFiles = new List<object>();
                var batchHashes = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

                foreach (IFormFile resume in resumes.Where(x => x != null))
                {
                    if (resume.Length == 0)
                    {
                        rejectedFiles.Add(new
                        {
                            FileName = resume.FileName,
                            Reason = "Empty resume file skipped."
                        });
                        continue;
                    }

                    string fileHash = await _bulkResumeService.ComputeFileHashAsync(resume);

                    if (!string.IsNullOrWhiteSpace(fileHash) && batchHashes.Contains(fileHash))
                    {
                        rejectedFiles.Add(new
                        {
                            FileName = resume.FileName,
                            Reason = "Duplicate CV upload skipped. Identical file found in the same bulk upload request."
                        });
                        continue;
                    }

                    batchHashes.Add(fileHash);

                    (string savedFileName, string savedFilePath) = await _bulkResumeService.SaveResumeTempFileAsync(resume, uploadFolder);

                    queuedFiles.Add(new BulkResumeQueuedFile
                    {
                        OriginalFileName = resume.FileName,
                        SavedFileName = savedFileName,
                        SavedFilePath = savedFilePath,
                        FileHash = fileHash
                    });
                }

                if (queuedFiles.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        TotalUploaded = resumes.Count,
                        RejectedBeforeQueue = rejectedFiles,
                        Message = "No valid resume files found for background processing."
                    });
                }

                string batchId = Guid.NewGuid().ToString("N");

                // 2. Queue background batch processing with custom JD and selected ATS rating model
                await _backgroundTaskQueue.QueueBackgroundWorkItem(async token =>
                {
                    using var scope = _serviceScopeFactory.CreateScope();
                    var bulkResumeService = scope.ServiceProvider.GetRequiredService<BulkResumeService>();
                    await ProcessBulkResumeBatchAsync(batchId, bulkResumeService, 0, locationId, jobDescription, queuedFiles, token);
                });

                return Accepted(new
                {
                    Success = true,
                    BatchId = batchId,
                    PostId = 0,
                    ATSHeadRatingID = atsConfigId,
                    TotalUploaded = resumes.Count,
                    AcceptedForBackgroundProcessing = queuedFiles.Count,
                    RejectedBeforeQueue = rejectedFiles,
                    message = "Bulk resume files accepted for custom JD. ATS processing is running in background."
                });
            }
            catch (Exception ex)
            {
                string detailedMessage = ex.InnerException != null
                    ? $"{ex.Message} Inner: {ex.InnerException.Message}"
                    : ex.Message;

                return StatusCode(500, new
                {
                    Success = false,
                    Message = detailedMessage
                });
            }
        }

    }
}
