using CommonUtility.Interface;
using System.Data;

namespace ATS.API.Services
{
    public class FileMigrationService
    {
        private readonly IDataService _dataService;
        private readonly string _connectionString;
        private readonly string _imageSavePath;
        private readonly string _imageUrlBase;
        private readonly string _resumeSavePath;
        private readonly string _resumeUrlBase;
        private readonly string _ftpImageFolder;
        private readonly string _ftpResumeFolder;
        private readonly FtpStorageService _ftpStorage;
        private readonly ILogger<FileMigrationService> _logger;

        public FileMigrationService(
            IConfiguration configuration,
            IDataService dataService,
            FtpStorageService ftpStorage,
            ILogger<FileMigrationService> logger)
        {
            _dataService = dataService;
            _ftpStorage = ftpStorage;
            _logger = logger;

            _connectionString = configuration.GetConnectionString("DBConnRecruitment")
                             ?? configuration.GetConnectionString("DBConnRecruitmentDemo")
                             ?? configuration.GetConnectionString("DefaultConnection")
                             ?? string.Empty;

            // Physical storage folder paths (for local saving)
            _imageSavePath = configuration["ResumeSettings:BulkProfilePicSavePath"]
                          ?? @"C:\Inetpub\vhosts\mendine.co.in\recruitment\Documents\Profilepic";

            _resumeSavePath = configuration["ResumeSettings:BulkResumeSavePath"]
                           ?? configuration["ResumeSettings:SavePath"]
                           ?? @"C:\Inetpub\vhosts\mendine.co.in\recruitment\Documents\Resume";

            // Remote FTP folder paths
            _ftpImageFolder = configuration["FtpSettings:ProfilePicRemotePath"] ?? "/Documents/Profilepic";
            _ftpResumeFolder = configuration["FtpSettings:ResumeRemotePath"] ?? "/Documents/Resume";

            // Public Web URL bases (ensured trailing slash)
            _imageUrlBase = (configuration["ResumeSettings:BulkProfilePicUrl"] 
                          ?? "https://recruitment.mendine.co.in/Documents/Profilepic/").TrimEnd('/') + "/";

            _resumeUrlBase = (configuration["ResumeSettings:BulkResumeFileUrl"] 
                           ?? configuration["ResumeSettings:fileUrl"] 
                           ?? "https://recruitment.mendine.co.in/Documents/Resume/").TrimEnd('/') + "/";
        }

        /// <summary>
        /// Calls PRC_GET_MIGRATION_STATUS to get total, migrated, and pending record counts
        /// </summary>
        public async Task<object> GetStatusAsync()
        {
            DataTable dt = await _dataService.GetDataAsync("PRC_GET_MIGRATION_STATUS", new Dictionary<string, object>(), _connectionString);
            var results = new List<object>();

            foreach (DataRow row in dt.Rows)
            {
                results.Add(new
                {
                    Category = row["Category"].ToString(),
                    Total = Convert.ToInt32(row["TotalRecords"]),
                    Migrated = Convert.ToInt32(row["MigratedRecords"] == DBNull.Value ? 0 : row["MigratedRecords"]),
                    Pending = Convert.ToInt32(row["PendingRecords"] == DBNull.Value ? 0 : row["PendingRecords"])
                });
            }

            return new
            {
                Storage = GetStorageInfo(),
                Items = results
            };
        }

        /// <summary>
        /// Migrates images: Saves to FTP or local disk and updates database via Stored Procedures
        /// </summary>
        public async Task<object> MigrateImagesAsync(int batchSize = 500, CancellationToken cancellationToken = default, long? imageId = null)
        {
            if (batchSize <= 0) batchSize = 500;

            EnsureStorageReady(_imageSavePath, "image");

            int successCount = 0;
            int failedCount = 0;
            var errors = new List<object>();

            var records = new List<(long ImageId, string CandidateId, string Name, string ContentType, byte[] Data, string Username)>();

            // 1. Fetch pending images using Stored Procedure
            DataTable pendingImages = await _dataService.GetDataAsync(
                "PRC_GET_PENDING_MIGRATION_IMAGES",
                new Dictionary<string, object>
                {
                    { "@BatchSize", batchSize },
                    { "@ImageId", (object?)imageId ?? DBNull.Value }
                },
                _connectionString);

            foreach (DataRow row in pendingImages.Rows)
            {
                records.Add((
                    ImageId: Convert.ToInt64(row["imageid"]),
                    CandidateId: row["candidateid"]?.ToString() ?? "0",
                    Name: row["name"]?.ToString() ?? string.Empty,
                    ContentType: row["ContentType"]?.ToString() ?? string.Empty,
                    Data: row["Data"] == DBNull.Value ? Array.Empty<byte>() : (byte[])row["Data"],
                    Username: row["username"]?.ToString() ?? string.Empty
                ));
            }

            if (records.Count == 0)
            {
                return new { success = true, storage = GetStorageInfo(), message = "No pending images found to migrate.", processed = 0 };
            }

            // 2. Process and update each record via Stored Procedure
            foreach (var item in records)
            {
                if (cancellationToken.IsCancellationRequested) break;

                try
                {
                    if (item.Data == null || item.Data.Length == 0)
                    {
                        throw new Exception("Image BLOB data is empty.");
                    }

                    string ext = GetImageExtension(item.Name, item.ContentType);
                    string safeCandidate = SanitizeFileName(item.CandidateId);
                    if (string.IsNullOrWhiteSpace(safeCandidate)) safeCandidate = "0";

                    string savedFileName = $"Img_{item.ImageId}_Cand_{safeCandidate}{ext}";
                    string fullPath = Path.Combine(_imageSavePath, savedFileName);
                    string fileUrl = $"{_imageUrlBase}{savedFileName}";

                    // Save via FTP or Local Disk
                    if (_ftpStorage.IsFtpEnabled)
                    {
                        await _ftpStorage.UploadFileBytesAsync(_ftpImageFolder, savedFileName, item.Data, cancellationToken);
                        fullPath = $"{_ftpImageFolder.TrimEnd('/')}/{savedFileName}";
                    }
                    else
                    {
                        await File.WriteAllBytesAsync(fullPath, item.Data, cancellationToken);
                    }

                    await UpdateMigratedImageAsync(item.ImageId, savedFileName, fullPath, fileUrl, item.Data.Length, "Success", null);
                    successCount++;
                }
                catch (Exception ex)
                {
                    failedCount++;
                    errors.Add(new { imageid = item.ImageId, error = ex.Message });
                    _logger.LogError(ex, "Failed to migrate imageid {ImageId}", item.ImageId);

                    try
                    {
                        await UpdateMigratedImageAsync(item.ImageId, null, null, null, null, "Failed", ex.Message);
                    }
                    catch { }
                }
            }

            return new
            {
                success = true,
                storage = GetStorageInfo(),
                totalBatch = records.Count,
                succeeded = successCount,
                failed = failedCount,
                errors
            };
        }

        /// <summary>
        /// Migrates resumes: Saves to FTP or local disk and updates database via Stored Procedures
        /// </summary>
        public async Task<object> MigrateResumesAsync(int batchSize = 500, CancellationToken cancellationToken = default, long? resumeId = null)
        {
            if (batchSize <= 0) batchSize = 500;

            EnsureStorageReady(_resumeSavePath, "resume");

            int successCount = 0;
            int failedCount = 0;
            var errors = new List<object>();

            var records = new List<(long Id, string CandidateId, string Name, string ContentType, byte[] ResumeFile, string Username)>();

            // 1. Fetch pending resumes using Stored Procedure
            DataTable pendingResumes = await _dataService.GetDataAsync(
                "PRC_GET_PENDING_MIGRATION_RESUMES",
                new Dictionary<string, object>
                {
                    { "@BatchSize", batchSize },
                    { "@Id", (object?)resumeId ?? DBNull.Value }
                },
                _connectionString);

            foreach (DataRow row in pendingResumes.Rows)
            {
                records.Add((
                    Id: Convert.ToInt64(row["id"]),
                    CandidateId: row["candidateid"]?.ToString() ?? "0",
                    Name: row["Name"]?.ToString() ?? string.Empty,
                    ContentType: row["ContentType"]?.ToString() ?? string.Empty,
                    ResumeFile: row["resumefile"] == DBNull.Value ? Array.Empty<byte>() : (byte[])row["resumefile"],
                    Username: row["username"]?.ToString() ?? string.Empty
                ));
            }

            if (records.Count == 0)
            {
                return new { success = true, storage = GetStorageInfo(), message = "No pending resumes found to migrate.", processed = 0 };
            }

            // 2. Process and update each record via Stored Procedure
            foreach (var item in records)
            {
                if (cancellationToken.IsCancellationRequested) break;

                try
                {
                    if (item.ResumeFile == null || item.ResumeFile.Length == 0)
                    {
                        throw new Exception("Resume BLOB data is empty.");
                    }

                    string ext = GetResumeExtension(item.Name, item.ContentType);
                    string safeCandidate = SanitizeFileName(item.CandidateId);
                    if (string.IsNullOrWhiteSpace(safeCandidate)) safeCandidate = "0";

                    string savedFileName = $"CV_{safeCandidate}_{item.Id}{ext}";
                    string fullPath = Path.Combine(_resumeSavePath, savedFileName);
                    string fileUrl = $"{_resumeUrlBase}{savedFileName}";

                    // Save via FTP or Local Disk
                    if (_ftpStorage.IsFtpEnabled)
                    {
                        await _ftpStorage.UploadFileBytesAsync(_ftpResumeFolder, savedFileName, item.ResumeFile, cancellationToken);
                        fullPath = $"{_ftpResumeFolder.TrimEnd('/')}/{savedFileName}";
                    }
                    else
                    {
                        await File.WriteAllBytesAsync(fullPath, item.ResumeFile, cancellationToken);
                    }

                    await UpdateMigratedResumeAsync(item.Id, savedFileName, fullPath, fileUrl, item.ResumeFile.Length, "Success", null);
                    successCount++;
                }
                catch (Exception ex)
                {
                    failedCount++;
                    errors.Add(new { id = item.Id, error = ex.Message });
                    _logger.LogError(ex, "Failed to migrate resume id {Id}", item.Id);

                    try
                    {
                        await UpdateMigratedResumeAsync(item.Id, null, null, null, null, "Failed", ex.Message);
                    }
                    catch { }
                }
            }

            return new
            {
                success = true,
                storage = GetStorageInfo(),
                totalBatch = records.Count,
                succeeded = successCount,
                failed = failedCount,
                errors
            };
        }

        private static string SanitizeFileName(string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return string.Empty;
            var invalids = Path.GetInvalidFileNameChars();
            return string.Join("_", input.Split(invalids, StringSplitOptions.RemoveEmptyEntries)).Trim();
        }

        private static string GetImageExtension(string fileName, string contentType)
        {
            if (!string.IsNullOrWhiteSpace(fileName) && Path.HasExtension(fileName))
            {
                string ext = Path.GetExtension(fileName).ToLower();
                if (ext is ".jpg" or ".jpeg" or ".png" or ".gif" or ".webp" or ".bmp")
                    return ext;
            }

            return (contentType?.ToLower().Trim()) switch
            {
                "image/jpeg" or "image/jpg" => ".jpg",
                "image/png" => ".png",
                "image/gif" => ".gif",
                "image/webp" => ".webp",
                "image/bmp" => ".bmp",
                _ => ".jpg"
            };
        }

        private static string GetResumeExtension(string fileName, string contentType)
        {
            if (!string.IsNullOrWhiteSpace(fileName) && Path.HasExtension(fileName))
            {
                string ext = Path.GetExtension(fileName).ToLower();
                if (ext is ".pdf" or ".doc" or ".docx" or ".txt" or ".rtf")
                    return ext;
            }

            return (contentType?.ToLower().Trim()) switch
            {
                "application/pdf" => ".pdf",
                "application/msword" => ".doc",
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document" => ".docx",
                "text/plain" => ".txt",
                "application/rtf" => ".rtf",
                _ => ".pdf"
            };
        }

        private void EnsureStorageReady(string localPath, string fileCategory)
        {
            if (_ftpStorage.IsFtpEnabled)
            {
                if (!_ftpStorage.IsConfigured)
                {
                    throw new InvalidOperationException(
                        $"FTP storage is enabled, but FtpSettings are not configured. Update FtpSettings:Host, Username, and Password before migrating {fileCategory} BLOB files.");
                }

                return;
            }

            if (string.IsNullOrWhiteSpace(localPath))
            {
                throw new InvalidOperationException($"Local {fileCategory} storage path is not configured.");
            }

            if (!Directory.Exists(localPath))
            {
                Directory.CreateDirectory(localPath);
            }
        }

        private object GetStorageInfo()
        {
            return _ftpStorage.IsFtpEnabled
                ? _ftpStorage.GetStorageInfo(_ftpImageFolder, _ftpResumeFolder)
                : new
                {
                    Mode = "LocalDisk",
                    FtpEnabled = false,
                    FtpConfigured = true,
                    ImageSavePath = _imageSavePath,
                    ResumeSavePath = _resumeSavePath
                };
        }

        private async Task UpdateMigratedImageAsync(long imageId, string? fileName, string? filePath, string? fileUrl, long? fileSize, string status, string? errorMessage)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@ImageId", imageId },
                { "@FileName", (object?)fileName ?? DBNull.Value },
                { "@FilePath", (object?)filePath ?? DBNull.Value },
                { "@FileUrl", (object?)fileUrl ?? DBNull.Value },
                { "@FileSize", (object?)fileSize ?? DBNull.Value },
                { "@Status", status },
                { "@ErrorMessage", (object?)errorMessage ?? DBNull.Value }
            };

            await _dataService.AddAsync("PRC_UPDATE_MIGRATED_IMAGE", parameters, _connectionString);
        }

        private async Task UpdateMigratedResumeAsync(long id, string? fileName, string? resumeFilePath, string? fileUrl, long? fileSize, string status, string? errorMessage)
        {
            var parameters = new Dictionary<string, object>
            {
                { "@Id", id },
                { "@FileName", (object?)fileName ?? DBNull.Value },
                { "@ResumeFilePath", (object?)resumeFilePath ?? DBNull.Value },
                { "@FileUrl", (object?)fileUrl ?? DBNull.Value },
                { "@FileSize", (object?)fileSize ?? DBNull.Value },
                { "@Status", status },
                { "@ErrorMessage", (object?)errorMessage ?? DBNull.Value }
            };

            await _dataService.AddAsync("PRC_UPDATE_MIGRATED_RESUME", parameters, _connectionString);
        }
    }
}
