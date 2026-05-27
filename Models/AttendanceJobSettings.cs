namespace ATS.API.Models
{
    public class AttendanceJobSettings
    {
        public string MidnightInitTime { get; set; } = "00:30";
        public int EmployeeBatchSize { get; set; } = 1000;
        public int TenantParallelWorkers { get; set; } = 5;
        public int RawPunchParallelWorkers { get; set; } = 3;
    }

    public class TenantInfo
    {
        public Guid TenantId { get; set; }
    }

    public class MobilePunchRequest
    {
        public string TenantId { get; set; }
        public int EmployeeId { get; set; }
        public DateTime PunchTime { get; set; }
        public string PunchState { get; set; }
        public string DeviceName { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string Location { get; set; }
    }
}
