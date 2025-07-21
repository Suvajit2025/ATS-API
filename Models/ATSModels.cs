using Newtonsoft.Json;

namespace ATS.API.Models
{
    public class ATSModels
    {
    }
    public class ResumeScore
    {

        public int MatchScore { get; set; }
        public string Remarks { get; set; }
        public int SkillMatch { get; set; }
        public int ExperienceMatch { get; set; }
        public int QualificationMatch { get; set; }
        public int AgeMatch { get; set; }
        public int JobResponsibilityMatch { get; set; }
        public string SkillNote { get; set; }
        public string ExperienceNote { get; set; }
        public string QualificationNote { get; set; }
        public string AgeNote { get; set; }
        public string JobResponsibilityNote { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class RatingItem
    {
        public int Id { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        public List<string> Keywords { get; set; } = new List<string>();
    }

    public class ResultStatusItem
    {
        public int Id { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
    }

    public class AtsJsonInput
    {
        [JsonProperty("Total Score")]
        public decimal TotalScore { get; set; }

        public List<RatingItem> BreakDownScore { get; set; }

        [JsonProperty("Result Status")]
        public List<ResultStatusItem> ResultStatus { get; set; }
    }
    public class AtsPromptResult
    {
        public string Prompt { get; set; }
        public decimal TotalScore { get; set; }
        public List<RatingItem> BreakDownArray { get; set; }
        public List<ResultStatusItem> ResultStatusArray { get; set; }
    }
}
