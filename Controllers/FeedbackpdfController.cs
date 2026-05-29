using Microsoft.AspNetCore.Mvc;
using MiniSoftware;
using Syncfusion.Pdf;

namespace ATS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FeedbackpdfController : ControllerBase
    { 
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
            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded.");

            string extension = Path.GetExtension(file.FileName).ToLower();

            if (extension != ".docx")
                return BadRequest("Only .docx files are supported by MiniPdf. Please upload a .docx file.");

            string tempFolder = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
            Directory.CreateDirectory(tempFolder);

            string safeFileName = Path.GetFileName(file.FileName);
            string inputPath = Path.Combine(tempFolder, safeFileName);
            string outputPath = Path.Combine(tempFolder, Path.GetFileNameWithoutExtension(safeFileName) + ".pdf");

            try
            {
                using (var stream = new FileStream(inputPath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }

                MiniPdf.ConvertToPdf(inputPath, outputPath);

                if (!System.IO.File.Exists(outputPath))
                    return StatusCode(500, "PDF file was not generated.");

                byte[] pdfBytes = await System.IO.File.ReadAllBytesAsync(outputPath);

                return File(
                    pdfBytes,
                    "application/pdf",
                    Path.GetFileNameWithoutExtension(safeFileName) + ".pdf"
                );
            }
            catch (Exception ex)
            {
                return StatusCode(500, "DOCX to PDF conversion error: " + ex.Message);
            }
            finally
            {
                if (Directory.Exists(tempFolder))
                    Directory.Delete(tempFolder, true);
            }
        }
    }
}