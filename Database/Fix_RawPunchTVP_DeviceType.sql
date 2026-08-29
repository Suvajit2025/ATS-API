-- =====================================================================
-- Fix: RawPunchTVP DeviceType VARCHAR(10) → VARCHAR(50)
-- Must drop PRC_Bulk_Insert_RawPunch first (it references the TVP)
-- Run on ESSP database
-- =====================================================================
USE [ESSP];
GO

-- Step 1: Drop the SP that references the TVP
IF OBJECT_ID(N'dbo.PRC_Bulk_Insert_RawPunch', 'P') IS NOT NULL
    DROP PROCEDURE dbo.PRC_Bulk_Insert_RawPunch;
GO

-- Step 2: Now drop the TVP safely
IF TYPE_ID(N'dbo.RawPunchTVP') IS NOT NULL
    DROP TYPE dbo.RawPunchTVP;
GO

-- Step 3: Recreate TVP with DeviceType VARCHAR(50)
CREATE TYPE dbo.RawPunchTVP AS TABLE
(
    SN              VARCHAR(100)    NOT NULL,
    EmployeeId      VARCHAR(50)     NOT NULL,
    PunchTime       DATETIME        NOT NULL,
    RawPayload      NVARCHAR(MAX)   NULL,
    PunchState      VARCHAR(10)     NULL,
    DeviceType      VARCHAR(50)     NOT NULL,
    Latitude        DECIMAL(9,6)    NULL,
    Longitude       DECIMAL(9,6)    NULL,
    LocationAddress NVARCHAR(MAX)   NULL
);
GO

-- Step 4: Recreate PRC_Bulk_Insert_RawPunch using new TVP
CREATE OR ALTER PROCEDURE dbo.PRC_Bulk_Insert_RawPunch
(
    @Punches dbo.RawPunchTVP READONLY
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DuplicateWindow INT = 2;

    DECLARE @Inserted TABLE
    (
        RawPunchId  BIGINT,
        EmployeeId  VARCHAR(50),
        PunchTime   DATETIME
    );

    ;WITH DeviceContext AS
    (
        SELECT
            p.SN,
            p.EmployeeId,
            p.PunchTime,
            p.RawPayload,
            p.PunchState,
            p.DeviceType,
            p.Latitude,
            p.Longitude,
            p.LocationAddress,
            COALESCE(dm.TenantId, eb.TenantId) AS TenantId,
            CONVERT(VARCHAR(50), ISNULL(dm.DeviceId, 0)) AS DeviceId,
            COALESCE(dm.DeviceName, p.SN, 'UNKNOWN') AS DeviceName
        FROM @Punches p
        LEFT JOIN dbo.SaaS_Attendance_Device_Master dm
            ON (dm.DeviceSerialNumber = p.SN OR dm.DeviceName = p.SN)
           AND dm.IsActive = 1
        OUTER APPLY
        (
            SELECT TOP 1 eb_sub.TenantId
            FROM dbo.Empbasic eb_sub
            WHERE (eb_sub.EmpNo = p.EmployeeId OR eb_sub.EmpCode = p.EmployeeId)
            ORDER BY eb_sub.Empno DESC
        ) eb
        WHERE dm.TenantId IS NOT NULL OR eb.TenantId IS NOT NULL
    )

    INSERT INTO dbo.SaaS_Attendance_RawPunch
    (
        TenantId,
        EmployeeId,
        PunchTime,
        Direction,
        PunchSource,
        DeviceId,
        DeviceName,
        RawPayload,
        Latitude,
        Longitude,
        LocationAddress,
        IsProcessed,
        CreatedDate,
        ProcessedDate
    )
    OUTPUT
        INSERTED.RawPunchId,
        INSERTED.EmployeeId,
        INSERTED.PunchTime
    INTO @Inserted
    SELECT
        d.TenantId,
        d.EmployeeId,
        d.PunchTime,
        CASE
            WHEN d.PunchState IN ('0','4','IN','I') THEN 'IN'
            WHEN d.PunchState IN ('1','5','OUT','O') THEN 'OUT'
            ELSE 'IN'
        END,
        d.DeviceType,
        d.DeviceId,
        d.DeviceName,
        d.RawPayload,
        d.Latitude,
        d.Longitude,
        d.LocationAddress,
        2,          -- IsProcessed = 2 (READY for SP_SaaS_Attendance_Process_V5)
        GETDATE(),
        NULL
    FROM DeviceContext d
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.SaaS_Attendance_RawPunch rp
        WHERE rp.TenantId   = d.TenantId
          AND rp.EmployeeId = d.EmployeeId
          AND ABS(DATEDIFF(MINUTE, rp.PunchTime, d.PunchTime)) < @DuplicateWindow
    );

    SELECT * FROM @Inserted;
END;
GO

PRINT 'Done: dbo.RawPunchTVP and dbo.PRC_Bulk_Insert_RawPunch recreated successfully.';
GO
