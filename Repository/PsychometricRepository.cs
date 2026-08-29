using ATS.API.Interface;
using ATS.API.Models;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;

namespace ATS.API.Repository
{
    public class PsychometricRepository : IPsychometricRepository
    {
        private readonly string _connectionString;

        public PsychometricRepository(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DBConnSaaSEssP") ?? string.Empty;
        }

        public async Task<PsychometricRepositoryResult> GetAssessmentAsync(string assessmentCode, PsychometricAssessmentQuery query)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            var resultSets = await ExecuteProcedureDataSetsAsync(connection, "PRC_SaaS_psychometry_GetAssessment", new Dictionary<string, object?>
            {
                ["@TenantId"] = query.TenantId,
                ["@CompanyId"] = NullIfZero(query.CompanyId),
                ["@AssessmentCode"] = assessmentCode,
                ["@LanguageCode"] = query.LanguageCode
            });

            var failure = GetFailureMessage(FirstResultSet(resultSets));
            if (failure != null)
                return PsychometricRepositoryResult.Fail(failure);

            return PsychometricRepositoryResult.Ok(new
            {
                Assessment = FirstResultSet(resultSets).FirstOrDefault(),
                Questions = resultSets.Count > 1 ? resultSets[1] : new List<Dictionary<string, object?>>(),
                Options = resultSets.Count > 2 ? resultSets[2] : new List<Dictionary<string, object?>>()
            });
        }

        public async Task<PsychometricRepositoryResult> StartAttemptAsync(string assessmentCode, PsychometricStartAttemptRequest request)
        {
            var rows = await ExecuteSingleResultProcedureAsync("PRC_SaaS_psychometry_StartAttempt", new Dictionary<string, object?>
            {
                ["@TenantId"] = request.TenantId,
                ["@CompanyId"] = NullIfZero(request.CompanyId),
                ["@AssessmentCode"] = assessmentCode,
                ["@ParticipantId"] = NullIfZero(request.ParticipantId),
                ["@ExternalParticipantId"] = NullIfSwaggerPlaceholder(request.ExternalParticipantId),
                ["@EmployeeId"] = NullIfZero(request.EmployeeId),
                ["@CandidateId"] = NullIfZero(request.CandidateId),
                ["@DisplayName"] = NullIfSwaggerPlaceholder(request.DisplayName),
                ["@Email"] = NullIfSwaggerPlaceholder(request.Email),
                ["@MobileNo"] = NullIfSwaggerPlaceholder(request.MobileNo),
                ["@AssessmentAssignmentId"] = NullIfZero(request.AssessmentAssignmentId),
                ["@AnonymousGroupId"] = NullIfZero(request.AnonymousGroupId),
                ["@ProtectedParticipantReference"] = NullIfSwaggerPlaceholder(request.ProtectedParticipantReference),
                ["@LanguageCode"] = request.LanguageCode,
                ["@ClientMetadataJson"] = NullIfSwaggerPlaceholder(request.ClientMetadataJson)
            });

            return ToRepositoryResult(rows);
        }

        public async Task<PsychometricRepositoryResult> GetAttemptAsync(long attemptId, string tenantId)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            var resultSets = await ExecuteProcedureDataSetsAsync(connection, "PRC_SaaS_psychometry_GetAttempt", new Dictionary<string, object?>
            {
                ["@TenantId"] = tenantId,
                ["@AssessmentAttemptId"] = attemptId
            });

            var failure = GetFailureMessage(FirstResultSet(resultSets));
            if (failure != null)
                return PsychometricRepositoryResult.Fail(failure);

            return PsychometricRepositoryResult.Ok(new
            {
                Attempt = FirstResultSet(resultSets).FirstOrDefault(),
                Responses = resultSets.Count > 1 ? resultSets[1] : new List<Dictionary<string, object?>>()
            });
        }

        public async Task<PsychometricRepositoryResult> SaveResponsesAsync(long attemptId, PsychometricSaveResponsesRequest request)
        {
            var saved = new List<Dictionary<string, object?>>();

            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            foreach (var response in request.Responses)
            {
                string optionsJson = JsonConvert.SerializeObject(response.Options ?? new List<PsychometricResponseOptionRequest>());
                var rows = await ExecuteProcedureRowsAsync(connection, "PRC_SaaS_psychometry_SaveResponse", new Dictionary<string, object?>
                {
                    ["@TenantId"] = request.TenantId,
                    ["@AssessmentAttemptId"] = attemptId,
                    ["@AssessmentQuestionId"] = response.AssessmentQuestionId,
                    ["@ResponseType"] = response.ResponseType,
                    ["@TextValue"] = response.TextValue,
                    ["@NumericValue"] = response.NumericValue,
                    ["@BooleanValue"] = response.BooleanValue,
                    ["@JsonValue"] = response.JsonValue,
                    ["@OptionsJson"] = optionsJson
                });

                var failure = GetFailureMessage(rows);
                if (failure != null)
                    return PsychometricRepositoryResult.Fail(failure, new { response.AssessmentQuestionId });

                saved.AddRange(rows);
            }

            return PsychometricRepositoryResult.Ok(new
            {
                Message = "Responses saved successfully.",
                Results = saved
            });
        }

        public async Task<PsychometricRepositoryResult> CompleteAttemptAsync(long attemptId, PsychometricCompleteAttemptRequest request)
        {
            var rows = await ExecuteSingleResultProcedureAsync("PRC_SaaS_psychometry_CompleteAttempt", new Dictionary<string, object?>
            {
                ["@TenantId"] = request.TenantId,
                ["@AssessmentAttemptId"] = attemptId
            });

            return ToRepositoryResult(rows);
        }

        public async Task<PsychometricRepositoryResult> GetResultAsync(long attemptId, string tenantId)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            var resultSets = await ExecuteProcedureDataSetsAsync(connection, "PRC_SaaS_psychometry_GetResult", new Dictionary<string, object?>
            {
                ["@TenantId"] = tenantId,
                ["@AssessmentAttemptId"] = attemptId
            });

            var failure = GetFailureMessage(FirstResultSet(resultSets));
            if (failure != null)
                return PsychometricRepositoryResult.Fail(failure);

            return PsychometricRepositoryResult.Ok(new
            {
                Result = FirstResultSet(resultSets).FirstOrDefault(),
                Dimensions = resultSets.Count > 1 ? resultSets[1] : new List<Dictionary<string, object?>>()
            });
        }

        public async Task<PsychometricRepositoryResult> GetParticipantReportsAsync(long participantId, string tenantId)
        {
            var rows = await ExecuteSingleResultProcedureAsync("PRC_SaaS_psychometry_GetParticipantReports", new Dictionary<string, object?>
            {
                ["@TenantId"] = tenantId,
                ["@ParticipantId"] = participantId
            });

            return PsychometricRepositoryResult.Ok(rows);
        }

        private async Task<List<Dictionary<string, object?>>> ExecuteSingleResultProcedureAsync(string procedureName, Dictionary<string, object?> parameters)
        {
            await using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();
            return await ExecuteProcedureRowsAsync(connection, procedureName, parameters);
        }

        private static async Task<List<Dictionary<string, object?>>> ExecuteProcedureRowsAsync(SqlConnection connection, string procedureName, Dictionary<string, object?> parameters)
        {
            var resultSets = await ExecuteProcedureDataSetsAsync(connection, procedureName, parameters);
            return FirstResultSet(resultSets);
        }

        private static async Task<List<List<Dictionary<string, object?>>>> ExecuteProcedureDataSetsAsync(SqlConnection connection, string procedureName, Dictionary<string, object?> parameters)
        {
            await using var command = new SqlCommand(procedureName, connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            foreach (var parameter in parameters)
                command.Parameters.AddWithValue(parameter.Key, parameter.Value ?? DBNull.Value);

            await using var reader = await command.ExecuteReaderAsync();
            var resultSets = new List<List<Dictionary<string, object?>>>();

            do
            {
                var rows = new List<Dictionary<string, object?>>();
                while (await reader.ReadAsync())
                {
                    var row = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase);
                    for (int i = 0; i < reader.FieldCount; i++)
                        row[reader.GetName(i)] = reader.IsDBNull(i) ? null : reader.GetValue(i);

                    rows.Add(row);
                }

                resultSets.Add(rows);
            }
            while (await reader.NextResultAsync());

            return resultSets;
        }

        private static List<Dictionary<string, object?>> FirstResultSet(List<List<Dictionary<string, object?>>> resultSets)
        {
            return resultSets.Count == 0 ? new List<Dictionary<string, object?>>() : resultSets[0];
        }

        private static PsychometricRepositoryResult ToRepositoryResult(List<Dictionary<string, object?>> rows)
        {
            var failure = GetFailureMessage(rows);
            return failure == null
                ? PsychometricRepositoryResult.Ok(rows)
                : PsychometricRepositoryResult.Fail(failure);
        }

        private static string? GetFailureMessage(List<Dictionary<string, object?>> rows)
        {
            if (rows.Count == 0 || !rows[0].TryGetValue("Success", out object? successValue))
                return null;

            bool success = successValue is bool value ? value : Convert.ToBoolean(successValue);
            if (success)
                return null;

            return rows[0].TryGetValue("Message", out object? messageValue)
                ? Convert.ToString(messageValue) ?? "Request failed."
                : "Request failed.";
        }

        private static long? NullIfZero(long? value)
        {
            return value.HasValue && value.Value > 0 ? value : null;
        }

        private static string? NullIfSwaggerPlaceholder(string? value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return null;

            return string.Equals(value.Trim(), "string", StringComparison.OrdinalIgnoreCase)
                ? null
                : value;
        }
    }
}
