using Microsoft.AspNetCore.Identity;

namespace ATS.API.Models
{
    public class SignUp
    {
        public string? username { get; set; }
        public string? password { get; set; }
        public Guid? TenantKey { get; set; }
        public int TenantId { get; set; }
        public long? CandidateId { get; set; }
        public Guid?  CandidateCode { get; set; }
        public int? id {  get; set; }
    }
    public class ApplicationUser : IdentityUser
    {
        public int TenantId { get; set; }
        public long? CandidateId { get; set; }
        public string TenantCode { get; set; }
        public Guid CandidateCode { get; set; }
        public DateTime CreatedOn { get; set; } = DateTime.UtcNow;
    }
}
