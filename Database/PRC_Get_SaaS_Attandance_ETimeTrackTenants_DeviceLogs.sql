/* =========================================================================  
   Procedure: dbo.PRC_Get_SaaS_Attandance_ETimeTrackTenants_DeviceLogs
   Purpose  : Pulls raw device punches from external eTimeTrackLite database 
              for a specific tenant and month/year with deduplication.
   Params   : @TenantId  - UniqueIdentifier of Tenant (Required)
              @Offset    - Pagination offset (Default 0)
              @BatchSize - Rows to fetch per batch (Default 1000)
              @Month     - Target Month 1-12 (Optional, Defaults to Current Month)
              @Year      - Target Year e.g. 2026 (Optional, Defaults to Current Year)
   ========================================================================= */  
USE [ESSP];
GO

CREATE OR ALTER PROCEDURE dbo.PRC_Get_SaaS_Attandance_ETimeTrackTenants_DeviceLogs    
(    
    @TenantId   UNIQUEIDENTIFIER,    
    @Offset     INT = 0,    
    @BatchSize  INT = 1000,
    @Month      INT = NULL,
    @Year       INT = NULL
)    
AS    
BEGIN    
    SET NOCOUNT ON;    
  
    DECLARE @SQL NVARCHAR(MAX) = '';  
    DECLARE @SourceDB NVARCHAR(200);  
  
    -- 1. Default to Current Month & Year if not passed or invalid
    IF @Month IS NULL OR @Month < 1 OR @Month > 12  
        SET @Month = MONTH(GETDATE());  
  
    IF @Year IS NULL OR @Year < 2000  
        SET @Year = YEAR(GETDATE());  
  
    -- Construct target table name e.g. DeviceLogs_7_2026 or DeviceLogs_8_2026
    DECLARE @TableName NVARCHAR(100) = 'DeviceLogs_' + CAST(@Month AS VARCHAR(2)) + '_' + CAST(@Year AS VARCHAR(4));  
  
    -- 2. Fetch external database name for tenant
    SELECT @SourceDB = SourceDatabase    
    FROM dbo.SaaS_Attendance_Tenant_ExternalSource    
    WHERE TenantId = @TenantId    
      AND SourceType = 'ETIMETRACK'    
      AND IsActive = 1;    
  
    IF @SourceDB IS NULL    
    BEGIN    
        RAISERROR('Source Database not configured for this Tenant in SaaS_Attendance_Tenant_ExternalSource.', 16, 1);  
        RETURN;  
    END;    
  
    -- 3. Check if target table exists in external database to prevent runtime errors
    DECLARE @TableCheckSQL NVARCHAR(MAX);
    DECLARE @TableExists INT = 0;

    SET @TableCheckSQL = N'
        SELECT @Exists = CASE WHEN OBJECT_ID(' + QUOTENAME(@SourceDB, '''') + ' + ''.dbo.'' + ' + QUOTENAME(@TableName, '''') + ') IS NOT NULL THEN 1 ELSE 0 END;';

    EXEC sp_executesql @TableCheckSQL, N'@Exists INT OUTPUT', @Exists = @TableExists OUTPUT;

    IF @TableExists = 0
    BEGIN
        -- Return empty result set matching expected schema if table doesn't exist
        SELECT TOP 0
            CAST(@TenantId AS UNIQUEIDENTIFIER) AS TenantId,
            CAST('' AS VARCHAR(50)) AS EmployeeId,
            CAST(GETDATE() AS DATETIME) AS PunchTime,
            CAST('' AS VARCHAR(10)) AS Direction,
            CAST('' AS VARCHAR(20)) AS PunchSource,
            CAST('' AS VARCHAR(50)) AS DeviceId,
            CAST('' AS VARCHAR(100)) AS SerialNumber,
            CAST('' AS NVARCHAR(MAX)) AS RawPayload,
            CAST(0 AS DECIMAL(9,6)) AS Latitude,
            CAST(0 AS DECIMAL(9,6)) AS Longitude,
            CAST('' AS NVARCHAR(MAX)) AS LocationAddress;
        RETURN;
    END;

    -- 4. Dynamic query from target month table with deduplication against SaaS_Attendance_RawPunch
    SET @SQL = N'  
    SELECT * FROM (  
        SELECT    
            ''' + CAST(@TenantId AS VARCHAR(50)) + ''' AS TenantId,    
            i.UserId AS EmployeeId,    
            i.LogDate AS PunchTime,    
            ISNULL(i.AttDirection, ISNULL(i.Direction, ''0'')) AS Direction,    
            ''ETIMETRACK'' AS PunchSource,    
            CONVERT(VARCHAR(MAX), DMST.DeviceId) AS DeviceId,    
            D.SerialNumber,    
            CONCAT(i.UserId, '' '', CONVERT(VARCHAR(19), i.LogDate, 120), '' '', ISNULL(i.Direction, ''0'')) AS RawPayload,    
            CAST(0 AS DECIMAL(9,6)) AS Latitude,    
            CAST(0 AS DECIMAL(9,6)) AS Longitude,    
            i.LocationAddress    
  
        FROM ' + QUOTENAME(@SourceDB) + '.dbo.' + QUOTENAME(@TableName) + ' i    
  
        LEFT JOIN ' + QUOTENAME(@SourceDB) + '.dbo.Devices D    
            ON i.DeviceId = D.DeviceId    
  
        LEFT JOIN dbo.SaaS_Attendance_Device_Master DMST    
            ON D.SerialNumber = DMST.DeviceSerialNumber    
           AND DMST.TenantId = ''' + CAST(@TenantId AS VARCHAR(50)) + '''  
    ) X  
  
    WHERE NOT EXISTS    
    (    
        SELECT 1    
        FROM dbo.SaaS_Attendance_RawPunch rp    
        WHERE rp.TenantId = ''' + CAST(@TenantId AS VARCHAR(50)) + '''    
          AND rp.EmployeeId = X.EmployeeId    
          AND rp.PunchTime = X.PunchTime    
    )  
  
    ORDER BY PunchTime ASC    
    OFFSET ' + CAST(@Offset AS VARCHAR(10)) + ' ROWS    
    FETCH NEXT ' + CAST(@BatchSize AS VARCHAR(10)) + ' ROWS ONLY;  
    ';  
  
    EXEC sp_executesql @SQL;    
END;
GO
