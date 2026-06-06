using ATS.API.Interface;
using ATS.API.Models;
using ATS.API.Services;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace ATS.API.Controllers
{
    [Route("ATS")]
    [ApiController]
    public class BulkResumeController : ControllerBase
    {
        private readonly BulkResumeService _bulkResumeService;
        private readonly IBackgroundTaskQueue _backgroundTaskQueue;
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public BulkResumeController(BulkResumeService bulkResumeService, IBackgroundTaskQueue backgroundTaskQueue, IServiceScopeFactory serviceScopeFactory)
        {
            _bulkResumeService = bulkResumeService;
            _backgroundTaskQueue = backgroundTaskQueue;
            _serviceScopeFactory = serviceScopeFactory;
        }

        [HttpPost("bulk-resume-upload")]
        public async Task<IActionResult> BulkResumeUploadScoreATSGenerate([FromForm] int postId, [FromForm] List<IFormFile> resumes)
        {
            try
            {
                // Step 1: Validate uploaded files.
                if (resumes == null || resumes.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Please upload at least one resume."
                    });
                }

                // Step 2: Get job details from DB by post id.
                List<ATSJobDescription> jobs = await _bulkResumeService.GetJobDescriptionsByPostIdAsync(postId);

                if (jobs.Count == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Job description not found."
                    });
                }

                // Step 3: Use first job detail for scoring.
                ATSJobDescription jobDescription = jobs.First();
                int examTaggingId = jobDescription.ExamTaggingID;
                int atsHeadRatingId = jobDescription.ATS_HEAD_RATING_ID;

                // Step 4: Check exam mapping.
                if (examTaggingId == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "Exam is not tagged for this job post."
                    });
                }

                // Step 5: Check ATS rating mapping.
                if (atsHeadRatingId == 0)
                {
                    return BadRequest(new
                    {
                        Success = false,
                        Message = "ATS Rating configuration is not mapped for this job post."
                    });
                }

                // Step 6: Prepare folder and response list.
                string uploadFolder = _bulkResumeService.GetUploadFolder();
                var results = new List<object>();
                int totalUploaded = resumes.Count;
                int successfullyProcessed = 0;
                int failedProcessing = 0;
                var notProcessedResumes = new List<object>();
                var processedButExist = new List<object>();
                var processedButAtsRejected = new List<object>();
                var processedAndShortlisted = new List<object>();

                // Step 7: Process resumes one by one.
                foreach (IFormFile resume in resumes)
                {
                    string savedFileName = string.Empty;
                    string savedFilePath = string.Empty;
                    string fileHash = string.Empty;
                    string candidateName = string.Empty;
                    string mailId = string.Empty;
                    string phoneNumber = string.Empty;
                    JObject candidateJson = null;

                    try
                    {
                        // Step 7.1: Skip empty file.
                        if (resume == null || resume.Length == 0)
                        {
                            results.Add(new
                            {
                                FileName = resume?.FileName,
                                Success = false,
                                Message = "Empty resume file skipped."
                            });

                            notProcessedResumes.Add(new
                            {
                                FileName = resume?.FileName,
                                CandidateName = candidateName,
                                MailId = mailId,
                                PhoneNumber = phoneNumber,
                                Reason = "Empty resume file skipped."
                            });

                            failedProcessing++;
                            continue;
                        }

                        // Step 7.2: Save CV temporarily.
                        (savedFileName, savedFilePath) = await _bulkResumeService.SaveResumeTempFileAsync(resume, uploadFolder);

                        // Step 7.3: Create file hash.
                        fileHash = await _bulkResumeService.ComputeFileHashAsync(savedFilePath);

                        // Step 7.4: Check duplicate CV by file hash.
                        JObject existingResume = await _bulkResumeService.GetExistingBulkResumeByHashAsync(postId, fileHash);

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

                            await _bulkResumeService.SaveBulkResumeAtsScoreAsync(postId, resume.FileName, savedFileName, fileHash, null, null, null, null, "Duplicate", false, duplicateJson, null, true, duplicateOfLogId);

                            processedButExist.Add(new
                            {
                                FileName = resume.FileName,
                                CandidateName = existingResume["CANDIDATE_NAME"]?.ToString(),
                                MailId = existingResume["MAIL_ID"]?.ToString(),
                                PhoneNumber = existingResume["PHONE_NUMBER"]?.ToString(),
                                Status = "Duplicate",
                                Message = "Duplicate CV upload skipped."
                            });

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

                            successfullyProcessed++;
                            continue;
                        }

                        // Step 7.5: Extract text from CV.
                        string resumeText = await _bulkResumeService.ExtractResumeTextAsync(savedFilePath);

                        if (string.IsNullOrWhiteSpace(resumeText) || resumeText.StartsWith("[Unsupported", StringComparison.OrdinalIgnoreCase))
                        {
                            var extractionFailedJson = new JObject
                            {
                                ["message"] = "Resume text could not be extracted.",
                                ["reason"] = resumeText,
                                ["fileHash"] = fileHash
                            };

                            await _bulkResumeService.SaveBulkResumeAtsScoreAsync(postId, resume.FileName, savedFileName, fileHash, null, null, null, null, "ExtractionFailed", false, extractionFailedJson, null, false, null);

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

                            notProcessedResumes.Add(new
                            {
                                FileName = resume.FileName,
                                CandidateName = candidateName,
                                MailId = mailId,
                                PhoneNumber = phoneNumber,
                                Reason = "Resume text could not be extracted."
                            });

                            failedProcessing++;
                            continue;
                        }

                        // Step 7.6: Extract candidate details from CV text.
                        candidateJson = await _bulkResumeService.ParseCandidateResumeJsonAsync(resumeText);
                        candidateName = _bulkResumeService.GetCandidateName(candidateJson);
                        mailId = _bulkResumeService.GetJsonString(candidateJson, "Email");
                        phoneNumber = _bulkResumeService.GetJsonString(candidateJson, "Mobile");

                        // Step 7.7: Check if candidate email already exists.
                        JObject existingCandidate = await _bulkResumeService.GetExistingCandidateByUsernameOrMailAsync(mailId, mailId);

                        if (existingCandidate != null)
                        {
                            var candidateAlreadyExistsJson = new JObject
                            {
                                ["message"] = "Candidate already exists. ATS score generation skipped.",
                                ["existingCandidate"] = existingCandidate,
                                ["fileHash"] = fileHash
                            };

                            await _bulkResumeService.SaveBulkResumeAtsScoreAsync(postId, resume.FileName, savedFileName, fileHash, candidateName, mailId, phoneNumber, null, "CandidateAlreadyExists", false, candidateAlreadyExistsJson, candidateJson, false, null);

                            processedButExist.Add(new
                            {
                                FileName = resume.FileName,
                                CandidateName = candidateName,
                                MailId = mailId,
                                PhoneNumber = phoneNumber,
                                Status = "CandidateAlreadyExists",
                                Message = "Candidate already exists. ATS score generation skipped."
                            });

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

                            successfullyProcessed++;
                            continue;
                        }

                        // Step 7.8: Generate ATS prompt.
                        AtsPromptResult promptResult = await _bulkResumeService.GenerateBulkPromptFromAtsHeadRatingAsync(atsHeadRatingId, jobDescription, resumeText);

                        // Step 7.9: Send ATS prompt to GPT and parse score JSON.
                        string scoreResponse = await _bulkResumeService.SendGptMessageAsync(promptResult.Prompt);
                        JObject scoreJson;

                        try
                        {
                            scoreJson = _bulkResumeService.CleanAndParseJson(scoreResponse);
                        }
                        catch
                        {
                            scoreJson = _bulkResumeService.BuildAtsScoreParseFailedJson(scoreResponse, promptResult);
                        }

                        // Step 7.10: Read ATS status.
                        string atsStatus = scoreJson["Status"]?.ToString();
                        bool isShortlisted = _bulkResumeService.IsAtsShortlisted(scoreJson);

                        // Step 7.11: If shortlisted, register candidate and save ATS score by candidate id.
                        JObject signupResult = null;
                        long? generatedCandidateId = null;
                        // Step 7.12: Save final bulk log.
                        await _bulkResumeService.SaveBulkResumeAtsScoreAsync(postId, resume.FileName, savedFileName, fileHash, candidateName, mailId, phoneNumber, generatedCandidateId, atsStatus, isShortlisted, scoreJson, candidateJson, false, null);

                        if (isShortlisted)
                        {
                            signupResult = await _bulkResumeService.RegisterShortlistedCandidateAsync(candidateJson, jobDescription);
                            bool signupSuccess = signupResult?["Success"]?.Value<bool>() ?? false;
                            if (signupSuccess == true)
                            {
                                long? registeredCandidateId = signupResult["CandidateId"]?.Value<long?>();
                                await _bulkResumeService.UpdateCandidateIdBulkResumeAtsScoreLog(postId, fileHash, candidateName, mailId, phoneNumber, registeredCandidateId);
                                if (registeredCandidateId.HasValue && registeredCandidateId.Value > 0)
                                {
                                    generatedCandidateId = registeredCandidateId.Value;
                                    //signupResult["AtsScoreSavedToDb"] = true;
                                    try
                                    {
                                        await _bulkResumeService.SaveAtsResponseToDb(scoreJson.ToString(Formatting.None), (int)registeredCandidateId.Value, promptResult.TotalScore, promptResult.BreakDownArray);
                                        signupResult["AtsScoreSavedToDb"] = true;

                                    }

                                    catch (Exception ex)
                                    {
                                        signupResult["AtsScoreSavedToDb"] = false;
                                        signupResult["AtsScoreSaveError"] = ex.Message;
                                    }

                                    if (signupResult["AtsScoreSavedToDb"]?.Value<bool>() == true)
                                    {
                                        try
                                        {
                                            LmsExamLinkMailRequest mailRequest = new LmsExamLinkMailRequest
                                            {
                                                CandidateId = registeredCandidateId.Value,
                                                CandidateMailId = mailId,
                                                //CandidateMailId = "suvajit.das@iecsl.co.in",
                                                CandidateName = candidateName,
                                                CompanyName = jobDescription.COMPANY_NAME,
                                                AppliedPost = jobDescription.POST,
                                                ExamTaggingId = examTaggingId
                                            };

                                            await _backgroundTaskQueue.QueueBackgroundWorkItem(async token =>
                                            {
                                                using var scope = _serviceScopeFactory.CreateScope();
                                                var lmsExamLinkService = scope.ServiceProvider.GetRequiredService<LmsExamLinkService>();

                                                await lmsExamLinkService.SendBulkResumeExamLinkAsync(mailRequest);
                                            });

                                            signupResult["LmsExamMailQueued"] = true;
                                            signupResult["LmsExamMailTo"] = mailId;
                                        }
                                        catch (Exception ex)
                                        {
                                            signupResult["LmsExamMailQueued"] = false;
                                            signupResult["LmsExamMailQueueError"] = ex.Message;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                // Signup failed, but do not stop the flow.
                                // Step 7.12 will still save BulkResumeAtsScoreLog with CandidateId = null.
                                signupResult["AtsScoreSavedToDb"] = false;
                            }

                            scoreJson["ShortlistedSignupResult"] = signupResult;
                            candidateJson["ShortlistedSignupResult"] = signupResult;
                            
                        }
                        else
                        {
                            processedButAtsRejected.Add(new
                            {
                                FileName = resume.FileName,
                                CandidateName = candidateName,
                                MailId = mailId,
                                PhoneNumber = phoneNumber,
                                Status = atsStatus,
                                Message = "Processed but ATS rejected."
                            });
                        }

                        if (isShortlisted)
                        {
                            processedAndShortlisted.Add(new
                            {
                                FileName = resume.FileName,
                                CandidateName = candidateName,
                                MailId = mailId,
                                PhoneNumber = phoneNumber,
                                Status = atsStatus,
                                GeneratedCandidateId = generatedCandidateId,
                                Message = "Processed and shortlisted."
                            });
                        }

                         
                        // Step 7.13: Add final response for this CV.
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
                            GeneratedCandidateId = generatedCandidateId,
                            IsShortlisted = isShortlisted,
                            SignupSuccess = signupResult?["Success"]?.Value<bool>(),
                            SignupMessage = signupResult?["Message"]?.ToString(),
                            ShortlistedSignupResult = signupResult
                        });

                        successfullyProcessed++;
                    }
                    catch (Exception ex)
                    {
                        if (ex.Message.Contains("Infinity", StringComparison.OrdinalIgnoreCase) &&
                            (!string.IsNullOrWhiteSpace(candidateName) || !string.IsNullOrWhiteSpace(mailId)))
                        {
                            JObject rejectedScoreJson = _bulkResumeService.BuildAtsScoreParseFailedJson(ex.Message, null);

                            try
                            {
                                await _bulkResumeService.SaveBulkResumeAtsScoreAsync(postId, resume?.FileName, savedFileName, fileHash, candidateName, mailId, phoneNumber, null, "Rejected", false, rejectedScoreJson, candidateJson, false, null);
                            }
                            catch
                            {
                                // Ignore logging failure here so this CV can still be returned as processed rejected.
                            }

                            processedButAtsRejected.Add(new
                            {
                                FileName = resume?.FileName,
                                CandidateName = candidateName,
                                MailId = mailId,
                                PhoneNumber = phoneNumber,
                                Status = "Rejected",
                                Message = "Processed but ATS rejected due to invalid ATS score response."
                            });

                            results.Add(new
                            {
                                FileName = resume?.FileName,
                                Success = true,
                                SavedFile = savedFileName,
                                ATSScore = rejectedScoreJson,
                                CandidateJson = candidateJson,
                                Status = "Rejected",
                                IsDuplicate = false,
                                FileHash = fileHash,
                                CandidateName = candidateName,
                                MailId = mailId,
                                PhoneNumber = phoneNumber,
                                IsShortlisted = false,
                                Message = "Processed but ATS rejected due to invalid ATS score response."
                            });

                            successfullyProcessed++;
                            continue;
                        }

                        failedProcessing++;

                        notProcessedResumes.Add(new
                        {
                            FileName = resume?.FileName,
                            CandidateName = candidateName,
                            MailId = mailId,
                            PhoneNumber = phoneNumber,
                            Reason = ex.Message
                        });

                        results.Add(new
                        {
                            FileName = resume?.FileName,
                            Success = false,
                            SavedFile = savedFileName,
                            Message = ex.Message
                        });
                    }
                    finally
                    {
                        // Step 7.14: Always delete temporary file.
                        _bulkResumeService.DeleteTempFile(savedFilePath);
                    }
                }

                // Step 8: Return all CV processing results.
                return Ok(new
                {
                    Success = true,
                    PostId = postId,
                    ExamTaggingID = examTaggingId,
                    ATSHeadRatingID = atsHeadRatingId,
                    TotalUploaded = totalUploaded,
                    SuccessfullyProcessed = successfullyProcessed,
                    FailedProcessing = failedProcessing,
                    NotProcessedResumes = notProcessedResumes,
                    ProcessedButExist = processedButExist,
                    ProcessedButAtsRejected = processedButAtsRejected,
                    ProcessedAndShortlisted = processedAndShortlisted,
                    Message = "ATS processing completed."
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
    }
}
