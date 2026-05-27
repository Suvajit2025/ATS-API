namespace ATS.API.Interface
{
    public interface IATSHelper
    {
        string GetFileExtensionFromName(string fileName);
        string GetExtensionFromContentType(string contentType);
        Task<string> ExtractTextAsync(string filePath);
        Task<string> SendMessageAsync(string content, string _GtpAPI);
        Task SendAtsScoreRequest(string username,string ATSUrl); 
    }
}
