/* =========================================================================  
   SaaS Attendance Engine — Configuration & Transactional Queries
   Location: Database/SaaS_Attendance_Configuration_Queries.sql
   ========================================================================= */  
USE [ESSP];
GO

-- =========================================================================
-- 1. CORE SHIFT & POLICY CONFIGURATION TABLES
-- =========================================================================

-- 1.1 Shift Definition Header (ShiftId, ShiftName, ShiftCode, EffectiveFrom, IsActive)
SELECT * FROM [dbo].[SaaS_Attendance_Configaration_Header] ORDER BY ShiftId ASC;

-- 1.2 Shift Timings, Grace Periods & Duration Requirements
SELECT * FROM [dbo].[SaaS_Attendance_ShiftConfig] ORDER BY ConfigId ASC;

-- 1.3 Shift Weekly Day Rules & WeekMasks (Monday-Sunday, WeekOff, HalfDay, FullDay)
SELECT * FROM [dbo].[SaaS_Attendance_ShiftDayRule] ORDER BY ShiftDayRuleId ASC;

-- 1.4 Global / Shift Date & WeekMask Overrides
SELECT * FROM [dbo].[SaaS_Attendance_Override] ORDER BY Id DESC;


-- =========================================================================
-- 2. EMPLOYEE SHIFT MAPPING & EMPLOYEE-LEVEL OVERRIDES
-- =========================================================================

-- 2.1 Direct Employee Shift Assignment (EmployeeId, EmployeeNo, ShiftId)
SELECT * FROM [dbo].[SaaS_Attendance_EmployeeShift] ORDER BY EmployeeShiftId DESC;

-- 2.2 Org-Level Shift Mapping (Company / Department / Designation / Location)
SELECT * FROM [dbo].[SaaS_Attendance_EmployeeShiftMap] ORDER BY ShiftMapID DESC;

-- 2.3 Individual Employee Shift Timing & Grace Overrides
SELECT * FROM [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride] ORDER BY EmployeeShiftConfigOverrideId DESC;

-- 2.4 Individual Employee Day Rule Overrides
SELECT * FROM [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride] ORDER BY EmployeeShiftDayRuleOverrideId DESC;


-- =========================================================================
-- 3. STATUS MASTERS & DISPLAY CONFIGURATIONS
-- =========================================================================

-- 3.1 System Status Master (PRESENT, ABSENT, LATE, HALFDAY, EARLYOUT, WEEKOFF, HOLIDAY, WOP, MISSEDPUNCH, LEAVE)
SELECT * FROM [dbo].[SaaS_Attendance_Status_Master] ORDER BY StatusId ASC;

-- 3.2 Tenant Custom Status Config (Custom Labels, Colors, Payable Factors)
SELECT * FROM [dbo].[SaaS_Attendance_Status_Config] ORDER BY ConfigId ASC;


-- =========================================================================
-- 4. DEVICE MASTER & EXTERNAL SOURCES
-- =========================================================================

-- 4.1 Biometric & ADMS Device Master (DeviceSerialNumber, DeviceName, DeviceType, IsActive)
SELECT * FROM [dbo].[SaaS_Attendance_Device_Master] ORDER BY DeviceId ASC;

-- 4.2 External eTimeTrack Database Sources & Tenant Connection Strings
SELECT * FROM [dbo].[SaaS_Attendance_Tenant_ExternalSource] ORDER BY SourceId ASC;


-- =========================================================================
-- 5. TRANSACTIONAL & CALCULATED ATTENDANCE TABLES
-- =========================================================================

-- 5.1 Central Raw Punch Ingestion Layer (IsProcessed: 1=Success, 2=Ready, 3/4/5/9=Errors)
SELECT TOP 100 * FROM [dbo].[SaaS_Attendance_RawPunch] ORDER BY RawPunchId DESC;

-- 5.2 Paired Daily In/Out Sessions
SELECT TOP 100 * FROM [dbo].[SaaS_Attendance_Sessions] ORDER BY SessionId DESC;

-- 5.3 Final Calculated Daily Attendance Records
SELECT TOP 100 * FROM [dbo].[SaaS_Attendance_Daily] ORDER BY AttendanceId DESC;

-- 5.4 Processing Audit & Error Log
SELECT TOP 100 * FROM [dbo].[SaaS_AttendanceInsert_ErrorLog] ORDER BY ErrorLogId DESC;


-- =========================================================================
-- 6. FULL RE-PROCESSING SCRIPT (REFRESH DAILY ATTENDANCE)
-- =========================================================================
/*
-- CAUTION: RUN THIS TO RE-GENERATE DAILY ATTENDANCE FROM SCRATCH:

-- Step A: Clear calculated tables
DELETE FROM dbo.SaaS_Attendance_Sessions;
DELETE FROM dbo.SaaS_Attendance_Daily;
DELETE FROM dbo.SaaS_AttendanceInsert_ErrorLog;

-- Step B: Reset raw punches to READY (IsProcessed = 2)
UPDATE dbo.SaaS_Attendance_RawPunch
SET IsProcessed = 2,
    ProcessedDate = NULL,
    ProcessingError = NULL;

-- Step C: Batch execute in chronological order
DECLARE @RawPunchId BIGINT;

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT RawPunchId
    FROM dbo.SaaS_Attendance_RawPunch
    WHERE IsProcessed = 2
    ORDER BY PunchTime ASC, RawPunchId ASC;

OPEN cur;
FETCH NEXT FROM cur INTO @RawPunchId;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC dbo.SP_SaaS_Attendance_Process_V5 @RawPunchId = @RawPunchId;
    FETCH NEXT FROM cur INTO @RawPunchId;
END;

CLOSE cur;
DEALLOCATE cur;
*/
