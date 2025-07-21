using ATS.API.Interface;
using DocumentFormat.OpenXml.Packaging;
using iTextSharp.text;
using iTextSharp.text.pdf.parser;
using System.Text;
using iTextSharp.text.pdf;
using Path = System.IO.Path;
using Newtonsoft.Json;
using System.Net.Http.Headers;

namespace ATS.API.Repository
{
    public class ATSHelperRepo : IATSHelper
    {
        private readonly IHttpClientFactory _httpClientFactory;

        public ATSHelperRepo(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        public string GetFileExtensionFromName(string fileName)
        {
            return string.IsNullOrWhiteSpace(fileName) || !fileName.Contains('.') ? ".bin" : Path.GetExtension(fileName).ToLower();
        }
        public string GetExtensionFromContentType(string contentType)
        {
            // Basic mappings – you can expand this based on your needs
            return contentType switch
            {
                "application/pdf" => ".pdf",
                "application/msword" => ".doc",
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document" => ".docx",
                "application/vnd.ms-excel" => ".xls",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" => ".xlsx",
                "text/plain" => ".txt",
                _ => ".bin" // default/fallback
            };
        }

        public async Task<string> ExtractTextAsync(string filePath)
        {
            if (string.IsNullOrWhiteSpace(filePath) || !File.Exists(filePath))
            {
                return "[Invalid or missing file path]";
            }

            string extension = Path.GetExtension(filePath).ToLower();

            try
            {
                if (extension == ".pdf")
                {
                    using var reader = new PdfReader(filePath);
                    StringBuilder text = new();
                    for (int i = 1; i <= reader.NumberOfPages; i++)
                    {
                        try
                        {
                            text.Append(PdfTextExtractor.GetTextFromPage(reader, i));
                        }
                        catch (Exception ex)
                        {
                            text.AppendLine($"[Error reading page {i}: {ex.Message}]");
                        }
                    }
                    return text.ToString();
                }
                else if (extension == ".docx")
                {
                    using var wordDoc = WordprocessingDocument.Open(filePath, false);
                    return wordDoc.MainDocumentPart?.Document?.Body?.InnerText ?? "[Empty or invalid .docx file]";
                }
                else if (extension == ".doc")
                {
                    var document = new Spire.Doc.Document();
                    document.LoadFromFile(filePath);
                    return document.GetText();
                }
                else if (extension == ".txt")
                {
                    return await File.ReadAllTextAsync(filePath);
                }
                else
                {
                    return $"[Unsupported file extension: {extension}]";
                }
            }
            catch (Exception ex)
            {
                return $"[Error extracting text from {extension} file: {ex.Message}]";
            }
        }


        public async Task<string> SendMessageAsync(string content, string gptApiUrl)
        { 
            try
            {
                using var client = new HttpClient();
                var response = await client.PostAsync(gptApiUrl,
                    new StringContent(JsonConvert.SerializeObject(new { Content = content }), Encoding.UTF8, "application/json"));

                if (!response.IsSuccessStatusCode)
                {
                    return $"[HTTP Error: {response.StatusCode}]";
                }

                var result = await response.Content.ReadAsStringAsync();
                dynamic data = JsonConvert.DeserializeObject(result);
                return data?.response?.ToString();
            }
            catch (Exception ex)
            {
                return $"[Error sending message: {ex.Message}]";
            }

        }

        public async Task<string> SendMessageGemini(string content)
        {
            string geminiApiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
            string geminiApiKey = "AIzaSyCG69mgR1cIQCi-C7xdHkg2FnQNkXrLGd0"; // Remember to replace!
            using var client = new HttpClient();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            var requestBody = new
            {
                contents = new[]
                {
            new
            {
                parts = new[]
                {
                    new { text = content }
                }
            }
                }
            };

            string jsonRequestBody = JsonConvert.SerializeObject(requestBody);
            var stringContent = new StringContent(jsonRequestBody, Encoding.UTF8, "application/json");

            var uriBuilder = new UriBuilder(geminiApiUrl);
            uriBuilder.Query = $"key={geminiApiKey}";
            var requestUri = uriBuilder.Uri;

            try
            {
                var response = await client.PostAsync(requestUri, stringContent);

                if (!response.IsSuccessStatusCode)
                {
                    var errorResult = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Gemini API failed: {response.StatusCode}, Body: {errorResult}");
                    return null;
                }

                var result = await response.Content.ReadAsStringAsync();
                dynamic responseData = JsonConvert.DeserializeObject(result);

                // Adjust the parsing based on the actual JSON response structure from Gemini
                if (responseData?.candidates != null && responseData.candidates.Count > 0)
                {
                    var firstCandidate = responseData.candidates[0];
                    if (firstCandidate?.content?.parts != null && firstCandidate.content.parts.Count > 0)
                    {
                        return firstCandidate.content.parts[0]?.text?.ToString();
                    }
                }

                Console.WriteLine("No 'candidates' found in the Gemini API response.");
                return null;
            }
            catch (HttpRequestException e)
            {
                Console.WriteLine($"Error during Gemini API request: {e.Message}");
                return null;
            }
            catch (JsonException e)
            {
                Console.WriteLine($"Error deserializing Gemini API response: {e.Message}");
                return null;
            }
            catch (Exception e)
            {
                Console.WriteLine($"An unexpected error occurred: {e.Message}");
                return null;
            }
        }

        public async Task SendAtsScoreRequest(string username, string atsURL)
        {
            // Build the URL for the POST request, appending the username as a query parameter
            var url = $"{atsURL}{username}";  // Construct the URL with the query parameter

            using (var client = _httpClientFactory.CreateClient())
            {
                // Send the POST request with the username in the query string
                var response = await client.PostAsync(url, null);

                // If the response is successful (2xx status codes)
                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine($"ATS score requested successfully for {username}");
                }
                else
                {
                    // Log the status code and content of the response to diagnose the issue
                    var responseContent = await response.Content.ReadAsStringAsync();
                    Console.WriteLine($"Failed to request ATS score for {username}: {response.StatusCode}, {responseContent}");
                }
            }
        }



    }
}
public class GeminiResponse
{
    public Candidate[] Candidates { get; set; }
}

public class Candidate
{
    public Content Content { get; set; }
}

public class Content
{
    public Part[] Parts { get; set; }
}

public class Part
{
    public string Text { get; set; }
}