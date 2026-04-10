using Microsoft.AspNetCore.Mvc;
using Mammoth;
using DinkToPdf;
using DinkToPdf.Contracts;
using System.IO;

namespace ATS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FeedbackpdfController : ControllerBase
    {
        private readonly IConverter _pdfConverter;

        public FeedbackpdfController(IConverter pdfConverter)
        {
            _pdfConverter = pdfConverter;
        }

        [HttpPost("convert-direct-Doc")]
        public async Task<IActionResult> ConvertDirectDoc(IFormFile file)
        {
            if (file == null || file.Length == 0) return BadRequest();

            string tempFolder = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
            Directory.CreateDirectory(tempFolder);
            string inputPath = Path.Combine(tempFolder, file.FileName);

            using (var stream = new FileStream(inputPath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            try
            {
                using (var process = new System.Diagnostics.Process())
                {
                    process.StartInfo.FileName = @"C:\Program Files\LibreOffice\program\soffice.exe";
                    process.StartInfo.Arguments = $"--headless --convert-to pdf \"{inputPath}\" --outdir \"{tempFolder}\"";
                    process.StartInfo.CreateNoWindow = true;
                    process.Start();
                    process.WaitForExit();
                }

                string pdfPath = Path.Combine(tempFolder, Path.GetFileNameWithoutExtension(file.FileName) + ".pdf");
                byte[] pdfBytes = System.IO.File.ReadAllBytes(pdfPath);

                Directory.Delete(tempFolder, true); // Cleanup API server temp files

                // Return the bytes directly to the calling domain
                return this.File(pdfBytes, "application/pdf", "converted.pdf");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
        [HttpPost("convert-direct")]
        public async Task<IActionResult> ConvertDirect(IFormFile file)
        {
            if (file == null || file.Length == 0) return BadRequest("No file uploaded.");

            try
            {
                string htmlContent;

                // 1. Read the uploaded .docx directly from the stream
                using (var ms = new MemoryStream())
                {
                    await file.CopyToAsync(ms);
                    ms.Position = 0; // Reset position for Mammoth

                    var docxConverter = new Mammoth.DocumentConverter();
                    var result = docxConverter.ConvertToHtml(ms);
                    htmlContent = result.Value; // Get HTML content
                }

                // 2. Prepare the PDF Document
                var doc = new HtmlToPdfDocument()
                {
                    GlobalSettings = {
                ColorMode = ColorMode.Color,
                Orientation = Orientation.Portrait,
                PaperSize = PaperKind.A4,
                Margins = new MarginSettings { Top = 10, Bottom = 10, Left = 10, Right = 10 }
            },
                    // Using a basic HTML wrapper for the conversion
                    Objects = {
                new ObjectSettings() {
                    HtmlContent = $@"<html><head><style>body {{ font-family: Arial, sans-serif; }}</style></head><body>{htmlContent}</body></html>",
                    WebSettings = { DefaultEncoding = "utf-8" }
                }
            }
                };

                // 3. Generate PDF bytes
                // Note: Ensure _pdfConverter is registered as a Singleton in Program.cs
                byte[] pdfBytes = _pdfConverter.Convert(doc);

                string pdfFileName = Path.GetFileNameWithoutExtension(file.FileName) + ".pdf";

                // 4. Return PDF bytes to your Legacy Application
                return this.File(pdfBytes, "application/pdf", pdfFileName);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "API Conversion Error: " + ex.Message);
            }
        }
    }
}