using System.Net;

namespace ATS.API.Services
{
    public class FtpStorageService
    {
        private readonly string _host;
        private readonly int _port;
        private readonly string _username;
        private readonly string _password;
        private readonly bool _useSsl;
        private readonly bool _enabled;
        private readonly ILogger<FtpStorageService> _logger;

        public bool IsFtpEnabled => _enabled;
        public bool IsConfigured =>
            !_enabled ||
            !string.IsNullOrWhiteSpace(_host) &&
            !string.IsNullOrWhiteSpace(_username) &&
            !string.IsNullOrWhiteSpace(_password) &&
            !_username.Equals("your_ftp_username", StringComparison.OrdinalIgnoreCase) &&
            !_password.Equals("your_ftp_password", StringComparison.OrdinalIgnoreCase);

        public FtpStorageService(IConfiguration configuration, ILogger<FtpStorageService> logger)
        {
            _logger = logger;
            _enabled = configuration.GetValue<bool>("FtpSettings:Enabled", false);
            _host = configuration["FtpSettings:Host"] ?? "recruitment.mendine.co.in";
            _port = configuration.GetValue<int>("FtpSettings:Port", 21);
            _username = configuration["FtpSettings:Username"] ?? string.Empty;
            _password = configuration["FtpSettings:Password"] ?? string.Empty;
            _useSsl = configuration.GetValue<bool>("FtpSettings:UseSsl", false);
        }

        /// <summary>
        /// Uploads a byte array directly to the FTP server folder
        /// </summary>
        public async Task<bool> UploadFileBytesAsync(string remoteFolderPath, string fileName, byte[] fileBytes, CancellationToken cancellationToken = default)
        {
            if (!_enabled)
            {
                throw new InvalidOperationException("FTP storage is not enabled.");
            }

            if (!IsConfigured)
            {
                throw new InvalidOperationException("FTP storage is enabled, but FtpSettings Host/Username/Password are not configured.");
            }

            if (fileBytes == null || fileBytes.Length == 0)
            {
                throw new ArgumentException("File content cannot be empty", nameof(fileBytes));
            }

            // Ensure remote directory exists on FTP
            await EnsureFtpDirectoryExistsAsync(remoteFolderPath);

            // Clean remote path format
            string cleanFolder = remoteFolderPath.Trim('/');
            string ftpUrl = $"ftp://{_host}:{_port}/{cleanFolder}/{fileName}";

            _logger.LogInformation("Uploading file to FTP: {FtpUrl} ({Size} bytes)", ftpUrl, fileBytes.Length);

            try
            {
#pragma warning disable SYSLIB0014 // Type or member is obsolete in .NET 8 (standard built-in FtpWebRequest)
                var request = (FtpWebRequest)WebRequest.Create(new Uri(ftpUrl));
                request.Method = WebRequestMethods.Ftp.UploadFile;
                request.Credentials = new NetworkCredential(_username, _password);
                request.UseBinary = true;
                request.UsePassive = true;
                request.KeepAlive = false;
                request.EnableSsl = _useSsl;

                using (var requestStream = await request.GetRequestStreamAsync())
                {
                    await requestStream.WriteAsync(fileBytes, 0, fileBytes.Length, cancellationToken);
                }

                using (var response = (FtpWebResponse)await request.GetResponseAsync())
                {
                    _logger.LogInformation("FTP Upload Complete: {StatusDescription}", response.StatusDescription);
                    await EnsureRemoteFileExistsAsync(remoteFolderPath, fileName, cancellationToken);
                    return true;
                }
#pragma warning restore SYSLIB0014
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "FTP Upload failed for {FtpUrl}", ftpUrl);
                throw;
            }
        }

        /// <summary>
        /// Recursively verifies or creates directories on the FTP server
        /// </summary>
        private async Task EnsureFtpDirectoryExistsAsync(string remoteFolderPath)
        {
            if (string.IsNullOrWhiteSpace(remoteFolderPath)) return;

            string[] folders = remoteFolderPath.Split('/', StringSplitOptions.RemoveEmptyEntries);
            string currentPath = "";

            foreach (var folder in folders)
            {
                currentPath += "/" + folder;
                string ftpDirectoryUrl = $"ftp://{_host}:{_port}{currentPath}";

                try
                {
#pragma warning disable SYSLIB0014
                    var request = (FtpWebRequest)WebRequest.Create(new Uri(ftpDirectoryUrl));
                    request.Method = WebRequestMethods.Ftp.MakeDirectory;
                    request.Credentials = new NetworkCredential(_username, _password);
                    request.UseBinary = true;
                    request.UsePassive = true;
                    request.KeepAlive = false;
                    request.EnableSsl = _useSsl;

                    using var response = (FtpWebResponse)await request.GetResponseAsync();
#pragma warning restore SYSLIB0014
                }
                catch (WebException ex)
                {
                    // 550 means directory already exists, which is completely expected
                    if (ex.Response is FtpWebResponse ftpResponse && ftpResponse.StatusCode == FtpStatusCode.ActionNotTakenFileUnavailable)
                    {
                        continue;
                    }

                    throw;
                }
            }
        }

        private async Task EnsureRemoteFileExistsAsync(string remoteFolderPath, string fileName, CancellationToken cancellationToken)
        {
            string cleanFolder = remoteFolderPath.Trim('/');
            string ftpUrl = $"ftp://{_host}:{_port}/{cleanFolder}/{fileName}";

#pragma warning disable SYSLIB0014
            var request = (FtpWebRequest)WebRequest.Create(new Uri(ftpUrl));
            request.Method = WebRequestMethods.Ftp.GetFileSize;
            request.Credentials = new NetworkCredential(_username, _password);
            request.UseBinary = true;
            request.UsePassive = true;
            request.KeepAlive = false;
            request.EnableSsl = _useSsl;

            using var registration = cancellationToken.Register(() => request.Abort());
            using var response = (FtpWebResponse)await request.GetResponseAsync();
#pragma warning restore SYSLIB0014

            if (response.ContentLength <= 0)
            {
                throw new IOException($"FTP upload completed but remote file was not found or has zero size: {ftpUrl}");
            }
        }

        public object GetStorageInfo(string imageRemotePath, string resumeRemotePath)
        {
            return new
            {
                Mode = _enabled ? "FTP" : "LocalDisk",
                FtpEnabled = _enabled,
                FtpConfigured = IsConfigured,
                Host = _enabled ? _host : null,
                Port = _enabled ? _port : (int?)null,
                UseSsl = _enabled ? _useSsl : (bool?)null,
                ImageRemotePath = _enabled ? imageRemotePath : null,
                ResumeRemotePath = _enabled ? resumeRemotePath : null
            };
        }
    }
}
