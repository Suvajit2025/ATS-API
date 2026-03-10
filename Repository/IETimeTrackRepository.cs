using System.Data;

namespace ATS.API.Repository
{
    public interface IETimeTrackRepository
    {
        Task<DataTable> GetETimeTrackTenantsAsync();
        Task<DataTable> GetDeviceLogsAsync(Guid tenantId, int offset, int batchSize);
        Task<long> InsertRawPunchAsync(string SN,string employeeId,DateTime punchTime,string rawPayload,string punchState,String DeviceType); 
        Task UpdateLastSyncAsync(Guid tenantId, DateTime lastSyncTime);
        Task<DataTable> BulkInsertRawPunchAsync(DataTable table);
        Task<long> ProcessDailyAttendance(long rawPunchId);
        Task<DataTable> GetUnprocessedPunchesAsync();
        Task CreateDailyAttendanceForAllTenants(int employeeBatchSize,int tenantParallelWorkers,CancellationToken cancellationToken = default);
        Task<long> InsertRawPunchMobileAsync(string TenantId, string EmployeeId, DateTime PunchTime,string Direction,string PunchSource,string DeviceName, string rawPayload,decimal Latitude,decimal Longitude,string LocationAddress);
    }
}
