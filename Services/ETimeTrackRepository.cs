using ATS.API.Models;
using ATS.API.Repository;
using CommonUtility.Interface;
using Microsoft.Data.SqlClient;
using System.Data;

namespace ATS.API.Services
{
    public class ETimeTrackRepository : IETimeTrackRepository
    {
        private readonly IDataService _dataService;
        private readonly IConfiguration _config;
        private readonly string _saasConnection;
        private readonly ILogger<ETimeTrackRepository> _logger;

        public ETimeTrackRepository(IDataService dataService, IConfiguration config, ILogger<ETimeTrackRepository> logger)
        {
            _dataService = dataService;
            _config = config;
            _logger = logger;
            _saasConnection = _config.GetConnectionString("DBConnSaaSEssP") ?? string.Empty;
        }

        // Helper to construct TVP DataTable matching dbo.RawPunchTVP
        public static DataTable CreateRawPunchTable()
        {
            var table = new DataTable();

            table.Columns.Add("SN", typeof(string));
            table.Columns.Add("EmployeeId", typeof(string));
            table.Columns.Add("PunchTime", typeof(DateTime));
            table.Columns.Add("RawPayload", typeof(string));
            table.Columns.Add("PunchState", typeof(string));
            table.Columns.Add("DeviceType", typeof(string));

            table.Columns.Add("Latitude", typeof(decimal));
            table.Columns.Add("Longitude", typeof(decimal));
            table.Columns.Add("LocationAddress", typeof(string));

            return table;
        }

        public static void AddRawPunchRow(
            DataTable table,
            string SN,
            string employeeId,
            DateTime punchTime,
            string? rawPayload,
            string? punchState,
            string? deviceType,
            decimal? latitude = null,
            decimal? longitude = null,
            string? locationAddress = null)
        {
            var row = table.NewRow();

            row["SN"] = SN;
            row["EmployeeId"] = employeeId;
            row["PunchTime"] = punchTime;
            row["RawPayload"] = rawPayload ?? (object)DBNull.Value;
            row["PunchState"] = string.IsNullOrWhiteSpace(punchState)
                ? DBNull.Value
                : punchState;
            row["DeviceType"] = deviceType ?? "BIOMETRIC";
            row["Latitude"] = latitude.HasValue
                ? latitude.Value
                : DBNull.Value;
            row["Longitude"] = longitude.HasValue
                ? longitude.Value
                : DBNull.Value;
            row["LocationAddress"] = string.IsNullOrWhiteSpace(locationAddress)
                ? DBNull.Value
                : locationAddress;

            table.Rows.Add(row);
        }

        // Fetches tenant list for eTimeTrack sync
        public async Task<DataTable> GetETimeTrackTenantsAsync()
        {
            var parameters = new Dictionary<string, object>();
            return await _dataService.GetDataAsync("PRC_Get_ETimeTrackTenants", parameters, _saasConnection);
        }

        // Fetches device logs from eTimeTrackLite database for a tenant in batches (supports Month & Year)
        public async Task<DataTable> GetDeviceLogsAsync(Guid tenantId, int offset, int batchSize, int? month = null, int? year = null)
        {
            var param = new Dictionary<string, object>
            {
                { "@TenantId", tenantId },
                { "@Offset", offset },
                { "@BatchSize", batchSize }
            };

            if (month.HasValue && month.Value > 0)
                param.Add("@Month", month.Value);

            if (year.HasValue && year.Value > 0)
                param.Add("@Year", year.Value);

            return await _dataService.GetDataAsync("PRC_Get_SaaS_Attandance_ETimeTrackTenants_DeviceLogs", param, _saasConnection);
        }

        // Single punch insertion via unified PRC_Bulk_Insert_RawPunch
        public async Task<long> InsertRawPunchAsync(string SN, string employeeId, DateTime punchTime, string rawPayload, string punchState, string DeviceType)
        {
            var table = CreateRawPunchTable();
            AddRawPunchRow(table, SN, employeeId, punchTime, rawPayload, punchState, DeviceType);

            var dt = await BulkInsertRawPunchAsync(table);
            if (dt != null && dt.Rows.Count > 0 && dt.Columns.Contains("RawPunchId"))
            {
                return Convert.ToInt64(dt.Rows[0]["RawPunchId"]);
            }

            return 0;
        }

        // Unified Raw Punch Insertion: Single SP (PRC_Bulk_Insert_RawPunch) with TVP dbo.RawPunchTVP
        public async Task<DataTable> BulkInsertRawPunchAsync(DataTable table)
        {
            if (table == null || table.Rows.Count == 0)
                return new DataTable();

            using var conn = new SqlConnection(_saasConnection);
            using var cmd = new SqlCommand("PRC_Bulk_Insert_RawPunch", conn);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandTimeout = 180; // 3-minute timeout for bulk operations

            var param = cmd.Parameters.AddWithValue("@Punches", table);
            param.SqlDbType = SqlDbType.Structured;
            param.TypeName = "dbo.RawPunchTVP";

            var dt = new DataTable();

            using var adapter = new SqlDataAdapter(cmd);

            await conn.OpenAsync();
            adapter.Fill(dt);

            return dt; // contains inserted RawPunchIds
        }

        // Updates LastSyncTime timestamp for tenant
        public async Task UpdateLastSyncAsync(Guid tenantId, DateTime lastSyncTime)
        {
            var param = new Dictionary<string, object>
            {
                { "@TenantId", tenantId },
                { "@LastSyncTime", lastSyncTime }
            };

            await _dataService.AddAsync("PRC_Update_ETimeTrackLastSync", param, _saasConnection);
        }

        // Executes SP_SaaS_Attendance_Process_V5 for single raw punch
        public async Task<long> ProcessDailyAttendance(long rawPunchId)
        {
            try
            {
                var param = new Dictionary<string, object>
                {
                    { "@RawPunchId", rawPunchId }
                };

                DataTable dt = await _dataService.GetDataAsync("SP_SaaS_Attendance_Process_V5", param, _saasConnection);
                if (dt != null && dt.Rows.Count > 0 && dt.Columns.Contains("IsProcessed"))
                {
                    long result = Convert.ToInt64(dt.Rows[0]["IsProcessed"]);
                    _logger.LogDebug("ProcessDailyAttendance: RawPunchId={RawPunchId} → IsProcessed={Result}", rawPunchId, result);
                    return result;
                }

                _logger.LogWarning("ProcessDailyAttendance: SP_SaaS_Attendance_Process_V5 returned no result for RawPunchId={RawPunchId}", rawPunchId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ProcessDailyAttendance FAILED for RawPunchId={RawPunchId}. SP_SaaS_Attendance_Process_V5 error.", rawPunchId);
            }

            return 0;
        }

        // Fetches unprocessed punches (IsProcessed = 2) for fallback processing
        public async Task<DataTable> GetUnprocessedPunchesAsync()
        {
            try
            {
                var param = new Dictionary<string, object>();
                return await _dataService.GetDataAsync("PRC_Get_Unprocessed_RawPunch", param, _saasConnection);
            }
            catch
            {
                return new DataTable();
            }
        }

        // Creates daily attendance rows for all active tenants in parallel batches
        public async Task CreateDailyAttendanceForAllTenants(int employeeBatchSize, int tenantParallelWorkers, CancellationToken cancellationToken = default)
        {
            var tenants = await GetTenantsAsync();

            var options = new ParallelOptions
            {
                MaxDegreeOfParallelism = tenantParallelWorkers,
                CancellationToken = cancellationToken
            };

            await Parallel.ForEachAsync(tenants, options, async (tenant, token) =>
            {
                await CreateDailyAttendanceForTenant(tenant.TenantId, employeeBatchSize, token);
            });
        }

        // Helper method to fetch active tenant list
        private async Task<List<TenantInfo>> GetTenantsAsync()
        {
            var tenants = new List<TenantInfo>();
            var parameters = new Dictionary<string, object>();

            DataTable dt = await _dataService.GetDataAsync("PRC_GetActiveTenants", parameters, _saasConnection);

            foreach (DataRow row in dt.Rows)
            {
                if (Guid.TryParse(row["TenantId"]?.ToString(), out Guid tenantId))
                {
                    tenants.Add(new TenantInfo
                    {
                        TenantId = tenantId
                    });
                }
            }

            return tenants;
        }

        // Helper method to initialize daily attendance rows for a tenant
        private async Task CreateDailyAttendanceForTenant(Guid tenantId, int batchSize, CancellationToken cancellationToken)
        {
            int offset = 0;

            while (!cancellationToken.IsCancellationRequested)
            {
                var parameters = new Dictionary<string, object>
                {
                    { "@TenantId", tenantId },
                    { "@Offset", offset },
                    { "@BatchSize", batchSize }
                };

                DataTable result = await _dataService.GetDataAsync("PRC_GetTenantEmployeesBatch", parameters, _saasConnection);

                if (result == null || result.Rows.Count == 0)
                    break;

                foreach (DataRow row in result.Rows)
                {
                    if (cancellationToken.IsCancellationRequested)
                        return;

                    string employeeId = row["EmployeeId"]?.ToString() ?? string.Empty;

                    var insertParams = new Dictionary<string, object>
                    {
                        { "@TenantId", tenantId },
                        { "@EmployeeId", employeeId }
                    };

                    await _dataService.AddAsync("PRC_CreateDailyAttendanceRow", insertParams, _saasConnection);
                }

                offset += batchSize;
            }
        }

        // Mobile punch insertion using unified PRC_Bulk_Insert_RawPunch
        public async Task<long> InsertRawPunchMobileAsync(string TenantId, string EmployeeId, DateTime PunchTime, string Direction, string PunchSource, string DeviceName, string rawPayload, decimal Latitude, decimal Longitude, string LocationAddress)
        {
            var table = CreateRawPunchTable();
            string punchState = Direction?.Trim() switch
            {
                "0" => "0", // IN
                "1" => "1", // OUT
                "2" => "2", // VISIT-IN
                "3" => "3", // VISIT-OUT
                _ => throw new ArgumentException($"Invalid PunchState: {Direction}")
            };
            AddRawPunchRow(table, DeviceName, EmployeeId, PunchTime, rawPayload, punchState, "MOBILE", Latitude, Longitude, LocationAddress);

            var dt = await BulkInsertRawPunchAsync(table);
            if (dt != null && dt.Rows.Count > 0 && dt.Columns.Contains("RawPunchId"))
            {
                return Convert.ToInt64(dt.Rows[0]["RawPunchId"]);
            }

            return 0;
        }
    }
}
