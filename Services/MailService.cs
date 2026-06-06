 

namespace ATS.API.Services
{
    using System.Net;
    using System.Net.Mail;
    using System.Text;
    using System.Text.RegularExpressions;

    namespace MailService
    {
        public class MailService
        {
            private readonly IConfiguration _configuration;

            public MailService(IConfiguration configuration)
            {
                _configuration = configuration;
            }

            public async Task<bool> SendMailAsync(string? toEmail,string? fromEmail,string? bodyHtml,string? subject,byte[]? attachmentBytes = null,string? fileNameWithoutExt = null)
            {
                try
                {
                    string smtpUser = _configuration["MailSettings:MailUserName"] ?? "";
                    string smtpPass = _configuration["MailSettings:MailPassword"] ?? "";
                    string smtpHost = _configuration["MailSettings:Host"] ?? "";
                    int smtpPort = Convert.ToInt32(_configuration["MailSettings:Port"] ?? "25");
                    bool enableSsl = (_configuration["MailSettings:EnableSsl"] ?? "false")
                                        .ToLower() == "true";

                    string defaultFrom = _configuration["MailSettings:MailFrom"] ?? "";
                    string adminEmail = _configuration["MailSettings:AdminEmail"] ?? "";

                    using var mail = new MailMessage();

                    // FROM
                    mail.From = new MailAddress(
                        !string.IsNullOrWhiteSpace(fromEmail)
                            ? fromEmail
                            : defaultFrom);

                    // TO
                    mail.To.Add(
                        !string.IsNullOrWhiteSpace(toEmail)
                            ? toEmail
                            : adminEmail);

                    mail.Subject = subject ?? string.Empty;
                    mail.IsBodyHtml = true;
                    mail.BodyEncoding = Encoding.UTF8;

                    string plainText = Regex.Replace(
                        bodyHtml ?? string.Empty,
                        "<.*?>",
                        string.Empty);

                    mail.AlternateViews.Add(
                        AlternateView.CreateAlternateViewFromString(
                            plainText,
                            Encoding.UTF8,
                            "text/plain"));

                    mail.AlternateViews.Add(
                        AlternateView.CreateAlternateViewFromString(
                            bodyHtml ?? string.Empty,
                            Encoding.UTF8,
                            "text/html"));

                    // Attachment (Optional)
                    if (attachmentBytes != null && attachmentBytes.Length > 0)
                    {
                        var stream = new MemoryStream(attachmentBytes);

                        mail.Attachments.Add(
                            new Attachment(
                                stream,
                                $"{fileNameWithoutExt ?? "Document"}.pdf",
                                "application/pdf"));
                    }

                    using var smtp = new SmtpClient(smtpHost, smtpPort);

                    smtp.EnableSsl = enableSsl;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new NetworkCredential(smtpUser, smtpPass);
                    smtp.DeliveryMethod = SmtpDeliveryMethod.Network;

                    await smtp.SendMailAsync(mail);

                    return true;
                }
                catch (Exception ex)
                {
                    // Your logging method
                    Console.WriteLine(ex.ToString());

                    return false;
                }
            }
        }
    }
}
