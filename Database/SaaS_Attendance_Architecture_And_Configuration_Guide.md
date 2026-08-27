# SaaS Attendance Engine — Architecture & Configuration Guide

---

## 1. 🏛️ Hybrid Attendance Sources Architecture

```
                       HYBRID ATTENDANCE SOURCES
                                   │
                  ┌────────────────┼────────────────┐
                  │                │                │
                  ▼                ▼                ▼
          ETimeTrack Device   Mobile Punch    Biometric ADMS Push
           Database Pull       API / App      (iclock/cdata)
                  │                │                │
                  └────────┬───────┴────────────────┘
                           ▼
                 ┌────────────────────────────────┐
                 │    dbo.PRC_Bulk_Insert_RawPunch│
                 │      (via dbo.RawPunchTVP)     │
                 └────────────────┬───────────────┘
                                  ▼
                    dbo.SaaS_Attendance_RawPunch
                          (IsProcessed = 2)
                                  │
                                  ▼
                 ┌────────────────────────────────┐
                 │ dbo.SP_SaaS_Attendance_Process │
                 │              _V5               │
                 └────────────────┬───────────────┘
                                  │
                  ┌───────────────┴───────────────┐
                  ▼                               ▼
     dbo.SaaS_Attendance_Sessions    dbo.SaaS_Attendance_Daily
       (In/Out Punch Pairing)       (Calculated Attendance Status)
```

---

## 2. 🚦 Raw Punch State Machine (`IsProcessed`)

| Code | Status Name | Description |
| :---: | :--- | :--- |
| **`1`** | **`SUCCESS`** | Punch successfully processed, sessions paired, and `SaaS_Attendance_Daily` updated. |
| **`2`** | **`READY`** | Punch ingested and waiting in queue for `SP_SaaS_Attendance_Process_V5`. |
| **`3`** | **`EMPLOYEE_NOT_FOUND`** | `EmployeeId` / `EmployeeNo` not found in `dbo.Empbasic`. |
| **`4`** | **`SHIFT_NOT_FOUND`** | No shift assigned in `SaaS_Attendance_Daily` or `SaaS_Attendance_EmployeeShift`. |
| **`5`** | **`SHIFT_CONFIG_NOT_FOUND`** | Missing shift timing/grace rules in `SaaS_Attendance_ShiftConfig`. |
| **`9`** | **`EXCEPTION`** | SQL runtime error occurred (rolled back and logged to error table). |
| **`0`** | **`NOT_READY`** | Initial default state (must be set to `2` for processing). |

---

## 3. ⚙️ Configuration Resolution Hierarchy (5 Tiers)

When evaluating punches for an employee on `@PunchDate`, the engine resolves rules in this strict order:

```
1. Specific Date Override (RuleType = 2)
   └─► dbo.SaaS_Attendance_Override (OverrideDate = @PunchDate)

2. Monthly/Yearly Weekmask Override (RuleType = 1)
   └─► dbo.SaaS_Attendance_Override (DayOfWeek, Year, Month, WeekMask)

3. Employee-Specific Day Rule Override
   └─► dbo.SaaS_Attendance_EmployeeShiftDayRuleOverride (EmployeeNo, ShiftId, DayOfWeek)

4. General Shift Day Rule
   └─► dbo.SaaS_Attendance_ShiftDayRule (ShiftId, DayOfWeek, WeekMask)

5. Holiday & Approved Leave Verification
   ├─► dbo.tleaveholidaymst (State, Location, Dept matching Empbasic)
   └─► dbo.tbl_Saas_Trn_LeaveApplication (ApplicationStatusId IN (2, 5))
```

---

## 4. 🗄️ Attendance Tables & Ready-to-Run Queries

### A. Core Shift & Policy Configuration
```sql
-- 1. Shift Definitions
SELECT * FROM [dbo].[SaaS_Attendance_Configaration_Header];

-- 2. Shift Timings, Grace Periods & Work Hour Rules
SELECT * FROM [dbo].[SaaS_Attendance_ShiftConfig];

-- 3. Shift Weekly Day Rules & WeekMasks
SELECT * FROM [dbo].[SaaS_Attendance_ShiftDayRule];

-- 4. Global / Shift Date & WeekMask Overrides
SELECT * FROM [dbo].[SaaS_Attendance_Override];
```

### B. Employee Shift Mapping & Overrides
```sql
-- 5. Direct Employee Shift Assignment
SELECT * FROM [dbo].[SaaS_Attendance_EmployeeShift];

-- 6. Org-Level Shift Mapping (Company / Dept / Desig / Location)
SELECT * FROM [dbo].[SaaS_Attendance_EmployeeShiftMap];

-- 7. Individual Employee Shift Timing Overrides
SELECT * FROM [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride];

-- 8. Individual Employee Day Rule Overrides
SELECT * FROM [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride];
```

### C. Status Masters & Display Settings
```sql
-- 9. System Attendance Status Master
SELECT * FROM [dbo].[SaaS_Attendance_Status_Master];

-- 10. Tenant Custom Status Config (Colors & Payable Factors)
SELECT * FROM [dbo].[SaaS_Attendance_Status_Config];
```

### D. Device Master & External Sync Sources
```sql
-- 11. Biometric & ADMS Device Master
SELECT * FROM [dbo].[SaaS_Attendance_Device_Master];

-- 12. External eTimeTrackLite Database Connection Sources
SELECT * FROM [dbo].[SaaS_Attendance_Tenant_ExternalSource];
```

### E. Transactional & Calculated Attendance Tables
```sql
-- 13. Central Raw Punch Ingestion Layer
SELECT TOP 100 * FROM [dbo].[SaaS_Attendance_RawPunch] ORDER BY RawPunchId DESC;

-- 14. Paired Daily In/Out Sessions
SELECT TOP 100 * FROM [dbo].[SaaS_Attendance_Sessions] ORDER BY SessionId DESC;

-- 15. Calculated Daily Attendance
SELECT TOP 100 * FROM [dbo].[SaaS_Attendance_Daily] ORDER BY AttendanceId DESC;

-- 16. Processing Audit & Error Log
SELECT TOP 100 * FROM [dbo].[SaaS_AttendanceInsert_ErrorLog] ORDER BY ErrorLogId DESC;
```

---

## 5. 🔄 Fresh Daily Attendance Re-Generation Script

To completely refresh and recalculate all daily attendance from existing raw punches:

```sql
-- Step 1: Clear calculated records
DELETE FROM dbo.SaaS_Attendance_Sessions;
DELETE FROM dbo.SaaS_Attendance_Daily;
DELETE FROM dbo.SaaS_AttendanceInsert_ErrorLog;

-- Step 2: Reset raw punches to READY (IsProcessed = 2)
UPDATE dbo.SaaS_Attendance_RawPunch
SET IsProcessed = 2,
    ProcessedDate = NULL,
    ProcessingError = NULL;

-- Step 3: Run batch cursor in chronological order
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
```
