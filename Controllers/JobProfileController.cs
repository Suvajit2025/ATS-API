using ATS.API.Interface; 
using CommonUtility.Interface; 
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace ATS.API.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class JobProfileController : ControllerBase
    {
        private readonly IBackgroundTaskQueue _backgroundTaskQueue;
        private readonly ICommonService _commonService;
        private readonly IDataService _dataService;
        private readonly string _ConnectionString;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IATSHelper _helper;
        public string _GptAPI;
        public string _JobDescriptionPrompt;
        public string _CandidateResumePrompt;
        public string _JobDescriptionResponseTemplate;
        public string _CandidateResumeResponseTemplate;
        public string _OpenAIJobdescriptionPrompt;
        public string _OpenAI_CandidateResumePrompt;
        public string _OpenAIJobdescriptiontemp;
        private readonly HttpClient _httpClient;

        private readonly string _tempDirectory = Path.Combine(Directory.GetCurrentDirectory(), "TempFiles");
        public JobProfileController(ICommonService commonService, IDataService dataService, IHttpContextAccessor httpContextAccessor, IConfiguration configuration, IATSHelper aTSHelper, IBackgroundTaskQueue backgroundTaskQueue, HttpClient httpClient)
        {
            _commonService = commonService;
            _dataService = dataService;
            _ConnectionString = configuration.GetConnectionString("DBConnRecruitment");
            _httpContextAccessor = httpContextAccessor;
            _helper = aTSHelper;
            _backgroundTaskQueue = backgroundTaskQueue;
            _GptAPI = configuration["GptAPI"];
            _JobDescriptionPrompt=configuration["JobDescriptionPrompt"];
            _CandidateResumePrompt = configuration["CandidateResumePrompt"];
            _JobDescriptionResponseTemplate = configuration["JobDescriptionResponseTemplate"];
            _CandidateResumeResponseTemplate = configuration["CandidateResumeResponseTemplate"];
            _httpClient = httpClient;
            // Ensure the TempFiles directory exists
            if (!Directory.Exists(_tempDirectory))
            {
                Directory.CreateDirectory(_tempDirectory);
            }
            _OpenAIJobdescriptionPrompt = configuration["OpenAIJobdescriptionConfig:JobDescriptionPrompt"];
            _OpenAI_CandidateResumePrompt= configuration["OpenAIJobdescriptionConfig:CandidateResumePrompt"];

            _OpenAIJobdescriptiontemp = configuration["OpenAIJobdescriptionConfig:temperature"];
        }

        [HttpPost("ProcessJobProfile")]
        public async Task<IActionResult> ProcessJobProfile(IFormFile file)
        {
            string filePath = null;
            if (file == null || file.Length == 0)
            {
                return BadRequest("No file uploaded.");
            }

            try
            {
                // Save the file locally
                filePath = Path.Combine(_tempDirectory, file.FileName);
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }

                 
                // Extract text from the file
                string extractedText = await _helper.ExtractTextAsync(filePath);

                
                string prompt = _JobDescriptionPrompt.Replace("{JobDescription}", extractedText);

                // Concatenate the JobDescriptionResponseTemplate to the prompt
                prompt = prompt + _JobDescriptionResponseTemplate;

                var gptResponse = await _helper.SendMessageAsync(prompt, _GptAPI); 

                if (!string.IsNullOrWhiteSpace(gptResponse))
                {
                    
                    Console.WriteLine("ATS Score calculated successfully.");
                }
                // Return the response
                return Ok(new { gptResponse });
               
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error processing job profile: {ex.Message}");
            }
            finally
            {
                // Ensure the file is deleted after processing
                if (!string.IsNullOrEmpty(filePath) && System.IO.File.Exists(filePath))
                {
                    try
                    {
                        System.IO.File.Delete(filePath);
                        
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error deleting file: {ex.Message}");
                    }
                }
            }
        }

        [HttpPost("CandidateResumeFile")]
        public async Task<IActionResult> CandidateResumeFile(IFormFile file)
        {
            string filePath = null;
            if (file == null || file.Length == 0)
            {
                return BadRequest("No file uploaded.");
            }

            try
            {
                // Save the file locally
                filePath = Path.Combine(_tempDirectory, file.FileName);
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }
                // Extract text from file
                string extractedText = await _helper.ExtractTextAsync(filePath);
                string prompt = _OpenAI_CandidateResumePrompt.Replace("{ResumeDescription}", extractedText);
                prompt = prompt + _CandidateResumeResponseTemplate;
                var gptResponse = await _helper.SendMessageAsync(prompt, _GptAPI);

                // Parse GPT JSON string
                JObject resume = JObject.Parse(gptResponse);
                //JObject resume = JObject.Parse(jsonWrapper);
                // Step: Check for valid pincode and enrich data
                string pinCode = resume["PinCode"]?.ToString();
                if (!string.IsNullOrWhiteSpace(pinCode) )
                {
                    using var client = new HttpClient();
                    var apiResponse = await client.GetStringAsync($"https://api.postalpincode.in/pincode/{pinCode}");
                    var result = JArray.Parse(apiResponse);

                    if (result[0]["Status"]?.ToString() == "Success")
                    {
                        var postOffice = result[0]["PostOffice"]?[0];
                        if (postOffice != null)
                        {
                            resume["District"] = postOffice["District"]?.ToString();
                            resume["State"] = postOffice["State"]?.ToString();
                            resume["Country"] = postOffice["Country"]?.ToString();
                        }
                    }
                }

                // Return the enriched JSON response
                return Ok(new { gptResponse = resume.ToString(Formatting.Indented) });
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error processing job profile: {ex.Message}");
            }
            finally
            {
                if (!string.IsNullOrEmpty(filePath) && System.IO.File.Exists(filePath))
                {
                    try { System.IO.File.Delete(filePath); }
                    catch (Exception ex) { Console.WriteLine($"Error deleting file: {ex.Message}"); }
                }
            }
        }



        [HttpPost("ProcessJobPrompt")]
        public async Task<IActionResult> ProcessJobPrompt(string promptInput)
        {
            if (string.IsNullOrWhiteSpace(promptInput))
                return BadRequest("Prompt input is empty.");

            try
            {
               
                string prompt = _OpenAIJobdescriptionPrompt.Replace("{JobDescription}", promptInput);

                // Concatenate the JobDescriptionResponseTemplate to the prompt
                prompt = prompt + _OpenAIJobdescriptiontemp;

                var gptResponse = await _helper.SendMessageAsync(prompt, _GptAPI);

                if (!string.IsNullOrWhiteSpace(gptResponse))
                {

                    Console.WriteLine("ATS Score calculated successfully.");
                }
                // Return the response
                return Ok(new { gptResponse });

            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error processing job profile: {ex.Message}");
            }
             
        }
    }
}
