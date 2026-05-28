using ATS.API.Models;
using ATS.API.Repository;
using CommonUtility.Interface;
using Microsoft.Data.SqlClient;
using System.Data;

namespace ATS.API.Services
{
    public class ETimeTrackRepository: IETimeTrackRepository
    {
        private readonly IDataService _dataService;
        private readonly IConfiguration _config;

        private readonly string _saasConnection;
        public ETimeTrackRepository(IDataService dataService,IConfiguration config)
        {
            _dataService = dataService;
            _config = config;
            _saasConnection =_config.GetConnectionString("DBConnSaaSEssP");
        }

        //This is for All Tenant Details who are using ETimeTrack, not the tenant details of our application.
        public async Task<DataTable> GetETimeTrackTenantsAsync()
        {
            var parameters = new Dictionary<string, object> {};
            return await _dataService.GetDataAsync("PRC_Get_ETimeTrackTenants", parameters, _saasConnection);
             
        }

        //This is for fetching device logs from Etimetreaklite for a tenant in batches for processing raw punches and creating daily attendance.
        public async Task<DataTable> GetDeviceLogsAsync(Guid tenantId, int offset, int batchSize)
        {
            var param = new Dictionary<string, object>
            {
                { "@TenantId", tenantId },
                { "@Offset", offset },
                { "@BatchSize", batchSize }
            };

            return await _dataService.GetDataAsync("PRC_Get_SaaS_Attandance_ETimeTrackTenants_DeviceLogs",param,_saasConnection);
        }

        // This is for inserting raw punch when we receive a punch from Attendance Listener device ,which will be later processed to create daily attendance.
        public async Task<long> InsertRawPunchAsync(string SN,string employeeId,DateTime punchTime,string rawPayload,string punchState, String DeviceType)
        {
            var param = new Dictionary<string, object>
            {
                { "@SN", SN },
                { "@EmployeeId", employeeId },
                { "@PunchTime", punchTime },
                { "@RawPayload", rawPayload },
                { "@PunchState", punchState },
                { "@DeviceType", DeviceType}
            };
            DataTable dt = await _dataService.GetDataAsync("PRC_API_Insert_RawPunch", param, _saasConnection);

            // Safety check: Convert the object to int (handles cases where result is null or long)
            if (dt.Rows.Count > 0)
            {
                return Convert.ToInt64(dt.Rows[0]["RawPunchId"]);
            }

            return 0;
        }

        // This is for bulk inserting raw punches fetched from ETimeTrackLite device logs, which will be later processed to create daily attendance.
        public async Task<DataTable> BulkInsertRawPunchAsync(DataTable table)
        {
            using var conn = new SqlConnection(_saasConnection);
            using var cmd = new SqlCommand("PRC_Bulk_Insert_RawPunch", conn);

            cmd.CommandType = CommandType.StoredProcedure;

            var param = cmd.Parameters.AddWithValue("@Punches", table);
            param.SqlDbType = SqlDbType.Structured;
            param.TypeName = "dbo.RawPunchTVP";

            var dt = new DataTable();

            using var adapter = new SqlDataAdapter(cmd);

            await conn.OpenAsync();
            adapter.Fill(dt);

            return dt; // contains RawPunchIds
        }
        public async Task UpdateLastSyncAsync(Guid tenantId,DateTime lastSyncTime)
        {
            var param = new Dictionary<string, object>
            {
                { "@TenantId", tenantId },
                { "@LastSyncTime", lastSyncTime }
            };

            await _dataService.AddAsync("PRC_Update_ETimeTrackLastSync",param,_saasConnection);
        }

        public Task<long> ProcessDailyAttendance(long rawPunchId)
        {
            long dt = 0;
            return Task.FromResult(dt);
        }
        // This is for fetching unprocessed punches which are inserted through InsertRawPunchAsync or BulkInsertRawPunchAsync or InsertRawPunchMobileAsync,
        // which are yet to be processed to create daily attendance.and IsProcessed = 0 in RawPunch table.
        public async Task<DataTable> GetUnprocessedPunchesAsync()
        {
            var param = new Dictionary<string, object>{};
            // return await _dataService.GetDataAsync("PRC_Get_Unprocessed_RawPunch",param,_saasConnection);
            DataTable dt = new DataTable();
            return dt;
        }
        // This is for creating daily attendance for all tenants in batches.
        // It will be called from a scheduled background service at midnight everyday.
        // For each tenant, it will fetch employees in batches and create daily attendance  rows for them for the day.
        // This will help in later processing punches to fill those daily attendance rows with actual punch in and punch out times.
        public async Task CreateDailyAttendanceForAllTenants(int employeeBatchSize,int tenantParallelWorkers,CancellationToken cancellationToken = default)
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

        // Helper method to fetch tenant details.
        // This is used in CreateDailyAttendanceForAllTenants to get the list of tenants for which we need to create daily attendance.
        //Add a DeviceUserIdField in the MST_Admin_Company table for Facting Which columns in EMpbasic is Used as USERID in ETimeTrack .
        private async Task<List<TenantInfo>> GetTenantsAsync()
        {
            var tenants = new List<TenantInfo>();

            var parameters = new Dictionary<string, object>();

            DataTable dt = await _dataService.GetDataAsync("PRC_GetActiveTenants",parameters,_saasConnection);

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

        // Helper method to create daily attendance for a tenant in batches.
        private async Task CreateDailyAttendanceForTenant(Guid tenantId,int batchSize,CancellationToken cancellationToken)
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

                DataTable result = await _dataService.GetDataAsync("PRC_GetTenantEmployeesBatch",parameters,_saasConnection);

                if (result.Rows.Count == 0)
                    break;

                foreach (DataRow row in result.Rows)
                {
                    if (cancellationToken.IsCancellationRequested)
                        return;

                    string employeeId = row["EmployeeId"]?.ToString();

                    var insertParams = new Dictionary<string, object>
                    {
                        { "@TenantId", tenantId },
                        { "@EmployeeId", employeeId }
                    };

                    await _dataService.AddAsync("PRC_CreateDailyAttendanceRow",insertParams,_saasConnection);
                }

                offset += batchSize;
            }
        }
        // This is for inserting raw punch when we receive a punch from Mobile device through API WebHook,
        // which will be later processed to create daily attendance.
        public async Task<long> InsertRawPunchMobileAsync(string TenantId, string EmployeeId, DateTime PunchTime, string Direction, string PunchSource, string DeviceName, string rawPayload, decimal Latitude, decimal Longitude, string LocationAddress)
        {
            var param = new Dictionary<string, object>
            {
                { "@TenantId", TenantId },
                { "@EmployeeId", EmployeeId },
                { "@PunchTime", PunchTime },
                { "@Direction",Direction },
                { "@PunchSource",PunchSource },
                { "@DeviceName",DeviceName }, 
                { "@RawPayload", rawPayload },
                { "@Latitude",Latitude },
                { "@Longitude",Longitude },
                { "@LocationAddress",LocationAddress }
            };

            DataTable dt = await _dataService.GetDataAsync("PRC_API_Insert_Mobile_RawPunch", param, _saasConnection);
            // Safety check: Convert the object to int (handles cases where result is null or long)
            if (dt.Rows.Count > 0)
            {
                return Convert.ToInt64(dt.Rows[0]["RawPunchId"]);
            }

            return 0;
        }
 
    }
}
