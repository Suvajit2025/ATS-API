using System.Text;
using MailSender = ATS.API.Services.MailService.MailService;

namespace ATS.API.Services
{
    public class LmsExamLinkMailRequest
    {
        public long CandidateId { get; set; }
        public string CandidateMailId { get; set; } = string.Empty;
        public string CandidateName { get; set; } = string.Empty;
        public string CompanyName { get; set; } = string.Empty;
        public string AppliedPost { get; set; } = string.Empty;
        public string PostName { get => AppliedPost; set => AppliedPost = value; }
        public string DepartmentName { get; set; } = string.Empty;
        public string locationName { get; set; } = string.Empty;
        public int ExamTaggingId { get; set; }

        public int CompanyId { get; set; }
        public int Companyid { get => CompanyId; set => CompanyId = value; }
        public int CompanyID { get => CompanyId; set => CompanyId = value; }

        public int DepartmentId { get; set; }
        public int Departmentid { get => DepartmentId; set => DepartmentId = value; }
        public int DepartmentID { get => DepartmentId; set => DepartmentId = value; }

        public int PostId { get; set; }
        public int PostID { get => PostId; set => PostId = value; }
        public int Postid { get => PostId; set => PostId = value; }

        public int LocationId { get; set; }
        public int LocationID { get => LocationId; set => LocationId = value; }
        public int LocId { get => LocationId; set => LocationId = value; }
    }

    public class LmsExamLinkMailResult
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string MailTo { get; set; } = string.Empty;
        public string Subject { get; set; } = string.Empty;
    }

    public class LmsExamLinkService
    {
        private readonly MailSender _mailService;

        public LmsExamLinkService(MailSender mailService)
        {
            _mailService = mailService;
        }

        public async Task<LmsExamLinkMailResult> SendBulkResumeExamLinkAsync(LmsExamLinkMailRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.CandidateMailId))
            {
                return new LmsExamLinkMailResult
                {
                    Success = false,
                    Message = "Candidate email address not found."
                };
            }

            if (request.ExamTaggingId == 0)
            {
                return new LmsExamLinkMailResult
                {
                    Success = false,
                    Message = "Exam tagging id not found."
                };
            }

            string examLink = BuildExamLink(request);
            string subject = "Online Assessment Invitation - " + (request.AppliedPost ?? string.Empty);
            string mailBody = BuildMailBody(request, examLink);

            bool sent = await _mailService.SendMailAsync(
                toEmail: request.CandidateMailId,
                fromEmail: null,
                bodyHtml: mailBody,
                subject: subject,
                attachmentBytes: null,
                fileNameWithoutExt: null
            );

            return new LmsExamLinkMailResult
            {
                Success = sent,
                Message = sent ? "LMS exam link sent successfully." : "Failed to send LMS exam link.",
                MailTo = request.CandidateMailId,
                Subject = subject
            };
        }

        public string BuildExamLink(LmsExamLinkMailRequest request)
        {
            string mailId = request.CandidateMailId ?? string.Empty;

            return BuildExamLink(
                request.ExamTaggingId,
                request.CompanyId,
                request.DepartmentId,
                request.PostId,
                request.LocationId,
                request.CandidateId,
                mailId,
                request.CompanyName,
                request.AppliedPost,
                request.DepartmentName,
                request.locationName);
        }

        public string BuildExamLink(
            int examTaggingId, 
            int companyId, 
            int departmentId, 
            int postId, 
            int locationId = 0,
            long candidateId = 0, 
            string candidateMailId = "",
            string companyName = "",
            string postName = "",
            string departmentName = "",
            string locationName = "")
        {
            string mailId = candidateMailId ?? string.Empty;

            if (candidateId == 0)
            {
                mailId = "pallab.das@iecsl.co.in";
            }

            string rawQuery = "UserName=" + mailId
                + "&UserID=" + candidateId
                + "&UserEmail=" + mailId
                + "&PortalID=2"
                + "&TenantID=B16FABB4-953D-4BFF-9841-C9ECD0A04826"
                + "&tenantUrl=mendinepharmaceuticalspvtltd"
                + "&vSource=ExternalExam"
                + "&IDExam=" + examTaggingId
                + "&CompanyId=" + companyId
                + "&Departmentid=" + departmentId
                + "&PostId=" + postId
                + "&LocationId=" + locationId
                + "&LocationID=" + locationId
                + "&CompanyName=" + (companyName ?? string.Empty)
                + "&PostName=" + (postName ?? string.Empty)
                + "&DepartmentName=" + (departmentName ?? string.Empty)
                + "&LocationName=" + (locationName ?? string.Empty);

            string base64Query = Convert.ToBase64String(Encoding.UTF8.GetBytes(rawQuery));

            return "https://lms.iecsl.in/t/mendinepharmaceuticalspvtltd/Login?Q=" + Uri.EscapeDataString(base64Query);
        }

        private string BuildMailBody(LmsExamLinkMailRequest request, string examLink)
        {
            string candidateName = string.IsNullOrWhiteSpace(request.CandidateName) ? "Candidate" : request.CandidateName;
            string companyName = request.CompanyName ?? string.Empty;
            string appliedPost = request.AppliedPost ?? string.Empty;

            return $@"
                    <html>
                    <body style=""font-family:Calibri;font-size:14px"">

                    Dear <b>{candidateName}</b>,
                    <br/><br/>

                    Greetings from <b>{companyName}</b>.
                    <br/><br/>

                    We are pleased to inform you that your application for the position of
                    <b>{appliedPost}</b>
                    has been shortlisted for the next stage of the recruitment process.

                    <br/><br/>

                    <b>Assessment Details</b>

                    <table border=""1"" cellpadding=""5"" cellspacing=""0"">
                        <tr>
                            <td><b>Candidate Name</b></td>
                            <td>{candidateName}</td>
                        </tr>
                        <tr>
                            <td><b>Company</b></td>
                            <td>{companyName}</td>
                        </tr>
                        <tr>
                            <td><b>Applied Position</b></td>
                            <td>{appliedPost}</td>
                        </tr>
                    </table>

                    <br/>

                    Please click the link below to start your online examination:

                    <br/><br/>

                    <a href=""{examLink}"" target=""_blank"">
                        Start Online Examination
                    </a>

                    <br/><br/>
                    <br/><br/>

                    Kindly complete the assessment within the allotted time.

                    <br/><br/>

                    Best Regards,<br/>
                    Recruitment Team<br/>
                    {companyName}

                    </body>
                    </html>";
        }

    }
}
