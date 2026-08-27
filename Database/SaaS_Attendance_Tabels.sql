USE [essp]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Configaration_Header]    Script Date: 26-08-2026 14:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Configaration_Header](
	[ShiftId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[ShiftName] [nvarchar](150) NOT NULL,
	[ShiftCode] [varchar](50) NOT NULL,
	[EffectiveFrom] [date] NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreateBy] [varchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK__SaaS_Att__C0A83881C679F265] PRIMARY KEY CLUSTERED 
(
	[ShiftId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Daily]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Daily](
	[AttendanceId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [varchar](50) NOT NULL,
	[EmployeeCode] [nvarchar](50) NULL,
	[EmployeeNo] [bigint] NULL,
	[AttendanceDate] [date] NOT NULL,
	[WageType] [varchar](20) NULL,
	[ShiftId] [int] NOT NULL,
	[ScheduledStatusId] [int] NOT NULL,
	[ActualStatusId] [int] NOT NULL,
	[SystemInTime] [datetime] NULL,
	[SystemOutTime] [datetime] NULL,
	[IsRegularized] [bit] NULL,
	[RegularizedInTime] [datetime] NULL,
	[RegularizedOutTime] [datetime] NULL,
	[RegularizationReason] [nvarchar](200) NULL,
	[RegularizedBy] [bigint] NULL,
	[RegularizedDate] [datetime] NULL,
	[FinalInTime] [datetime] NULL,
	[FinalOutTime] [datetime] NULL,
	[FinalStatusId] [int] NULL,
	[TotalDurationMinutes] [int] NULL,
	[ActualWorkMinutes] [int] NULL,
	[BreakMinutes] [int] NULL,
	[OvertimeMinutes] [int] NULL,
	[IsLate] [bit] NULL,
	[LateMinutes] [int] NULL,
	[IsEarlyOut] [bit] NULL,
	[EarlyMinutes] [int] NULL,
	[LeaveApplicationId] [bigint] NULL,
	[IsFinalized] [bit] NULL,
	[PayrollBatchId] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[LastUpdated] [datetime] NULL,
 CONSTRAINT [PK__SaaS_Att__8B69261CDB36E022] PRIMARY KEY CLUSTERED 
(
	[AttendanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Daily_Emp_Date] UNIQUE NONCLUSTERED 
(
	[EmployeeId] ASC,
	[AttendanceDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Device_Master]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Device_Master](
	[DeviceId] [int] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[DeviceSerialNumber] [varchar](50) NOT NULL,
	[DeviceName] [varchar](100) NULL,
	[DeviceModel] [varchar](50) NULL,
	[DeviceType] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[LastHeartbeatTime] [datetime] NULL,
	[IpAddress] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[LastStamp] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeviceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DeviceSerialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_EmployeeShift]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_EmployeeShift](
	[EmployeeShiftId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[EmployeeNo] [bigint] NOT NULL,
	[ShiftId] [bigint] NOT NULL,
	[EffectiveFrom] [date] NOT NULL,
	[EffectiveTo] [date] NULL,
	[IsActive] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeShiftId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride](
	[EmployeeShiftConfigOverrideId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[EmployeeNo] [varchar](50) NOT NULL,
	[ShiftId] [bigint] NOT NULL,
	[ConfigId] [bigint] NULL,
	[OverrideMode] [int] NULL,
	[RosterDate] [date] NULL,
	[EffectiveFrom] [date] NULL,
	[EffectiveTo] [date] NULL,
	[DayType] [tinyint] NULL,
	[IsDayTypeOverride] [bit] NULL,
	[IsShiftOverride] [bit] NULL,
	[IsTimeOverride] [bit] NULL,
	[AttendanceMode] [nvarchar](100) NULL,
	[InTime] [time](7) NULL,
	[InGraceMin] [int] NULL,
	[MaxInTime] [time](7) NULL,
	[OutTime] [time](7) NULL,
	[OutGraceMin] [int] NULL,
	[FullDayHours] [time](7) NULL,
	[HalfDayHours] [time](7) NULL,
	[RequiredFullMinutes] [int] NULL,
	[RequiredHalfMinutes] [int] NULL,
	[FirstHalfIn] [time](7) NULL,
	[FirstHalfOut] [time](7) NULL,
	[SecondHalfIn] [time](7) NULL,
	[SecondHalfOut] [time](7) NULL,
	[LateGraceDays] [int] NULL,
	[LateConsequesnce] [varchar](20) NULL,
	[LateAction] [varchar](50) NULL,
	[IsAutoLateDeduct] [bit] NULL,
	[EarlyGraceDays] [int] NULL,
	[EarlyConsequesnce] [varchar](20) NULL,
	[EarlyAction] [varchar](50) NULL,
	[IsAutoEarlyDeduct] [bit] NULL,
	[Reason] [nvarchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK__SaaS_Att__BB48B217AB91D9FB] PRIMARY KEY CLUSTERED 
(
	[EmployeeShiftConfigOverrideId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride](
	[EmployeeShiftDayRuleOverrideId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[EmployeeNo] [varchar](50) NOT NULL,
	[ShiftId] [bigint] NOT NULL,
	[EmployeeShiftConfigOverrideId] [bigint] NULL,
	[ShiftDayRuleId] [bigint] NULL,
	[DayOfWeek] [nvarchar](100) NULL,
	[WeekMask] [nvarchar](100) NULL,
	[DayType] [nvarchar](100) NULL,
	[EffectiveFrom] [date] NULL,
	[EffectiveTo] [date] NULL,
	[Reason] [nvarchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK__SaaS_Att__2C0208F1ED99A6F9] PRIMARY KEY CLUSTERED 
(
	[EmployeeShiftDayRuleOverrideId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_EmpDayRule] UNIQUE NONCLUSTERED 
(
	[TenantId] ASC,
	[EmployeeNo] ASC,
	[ShiftId] ASC,
	[DayOfWeek] ASC,
	[WeekMask] ASC,
	[EffectiveFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_EmployeeShiftMap]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_EmployeeShiftMap](
	[ShiftMapID] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [nvarchar](max) NULL,
	[ShiftId] [bigint] NULL,
	[DepartmentID] [bigint] NULL,
	[DesignationID] [bigint] NULL,
	[CompanyID] [bigint] NULL,
	[LocationID] [bigint] NULL,
	[EffectiveFrom] [date] NULL,
	[EffectiveTo] [date] NULL,
	[IsActive] [int] NULL,
	[CreatedOn] [date] NULL,
	[CreatedBy] [bigint] NULL,
	[UpdatedOn] [date] NULL,
	[UpdatedBy] [bigint] NULL,
 CONSTRAINT [PK_SaaS_Attendance_EmployeeShiftMap] PRIMARY KEY CLUSTERED 
(
	[ShiftMapID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_ETL_Log]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_ETL_Log](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[RunId] [uniqueidentifier] NULL,
	[TenantId] [uniqueidentifier] NULL,
	[Stage] [varchar](50) NULL,
	[Message] [nvarchar](max) NULL,
	[RowsAffected] [int] NULL,
	[CreatedDate] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Override]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Override](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ShiftId] [bigint] NULL,
	[OverrideYear] [int] NULL,
	[OverrideMonth] [int] NULL,
	[RuleType] [tinyint] NOT NULL,
	[DayOfWeek] [tinyint] NULL,
	[WeekDayName] [varchar](50) NULL,
	[WeekMask] [tinyint] NULL,
	[OverrideDate] [date] NULL,
	[DayType] [tinyint] NULL,
	[Reason] [nvarchar](250) NULL,
	[IsActive] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[TenantID] [nvarchar](max) NULL,
 CONSTRAINT [PK__SaaS_Att__3214EC079869E8A9] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_RawPunch]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_RawPunch](
	[RawPunchId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [varchar](50) NOT NULL,
	[PunchTime] [datetime] NOT NULL,
	[PunchDate]  AS (CONVERT([date],[PunchTime])) PERSISTED,
	[Direction] [varchar](10) NULL,
	[PunchSource] [varchar](20) NULL,
	[DeviceId] [varchar](50) NULL,
	[DeviceName] [varchar](100) NULL,
	[RawPayload] [nvarchar](max) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[LocationAddress] [nvarchar](max) NULL,
	[IsProcessed] [int] NULL,
	[ProcessedDate] [datetime] NULL,
	[ProcessingError] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[Stamp] [int] NULL,
 CONSTRAINT [PK__SaaS_Att__CA685E6B4161AFDB] PRIMARY KEY CLUSTERED 
(
	[RawPunchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Regularization]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Regularization](
	[RegularizationId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[AttendanceId] [bigint] NOT NULL,
	[EmployeeId] [varchar](50) NOT NULL,
	[AttendanceDate] [date] NOT NULL,
	[RegularizationTypeId] [int] NULL,
	[RequestedInTime] [datetime] NULL,
	[RequestedOutTime] [datetime] NULL,
	[Reason] [nvarchar](250) NOT NULL,
	[Status] [varchar](20) NULL,
	[RequestedBy] [bigint] NOT NULL,
	[RequestedDate] [datetime] NULL,
	[ApprovedBy] [bigint] NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovalRemarks] [nvarchar](250) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[FilePath] [nvarchar](max) NULL,
 CONSTRAINT [PK__SaaS_Att__F8EC1AB8DA6CD6D8] PRIMARY KEY CLUSTERED 
(
	[RegularizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Sessions]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Sessions](
	[SessionId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NULL,
	[EmployeeNo] [varchar](50) NULL,
	[AttendanceDate] [date] NULL,
	[SessionIn] [datetime] NULL,
	[SessionOut] [datetime] NULL,
	[InLatitude] [decimal](10, 7) NULL,
	[InLongitude] [decimal](10, 7) NULL,
	[InAddress] [nvarchar](500) NULL,
	[OutLatitude] [decimal](10, 7) NULL,
	[OutLongitude] [decimal](10, 7) NULL,
	[OutAddress] [nvarchar](500) NULL,
	[DurationMinutes] [int] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[SessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_ShiftConfig]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_ShiftConfig](
	[ConfigId] [bigint] IDENTITY(1,1) NOT NULL,
	[ShiftId] [bigint] NOT NULL,
	[AttendanceMode] [varchar](20) NULL,
	[InTime] [time](7) NULL,
	[InGraceMin] [int] NULL,
	[MaxInTime] [time](7) NULL,
	[OutTime] [time](7) NULL,
	[OutGraceMin] [int] NULL,
	[FullDayHours] [time](7) NOT NULL,
	[HalfDayHours] [time](7) NOT NULL,
	[RequiredFullMinutes] [bit] NULL,
	[RequiredHalfMinutes] [bit] NULL,
	[FirstHalfIn] [time](7) NULL,
	[FirstHalfOut] [time](7) NULL,
	[SecondHalfIn] [time](7) NULL,
	[SecondHalfOut] [time](7) NULL,
	[LateGraceDays] [int] NULL,
	[LateConsequesnce] [bit] NULL,
	[LateAction] [varchar](20) NULL,
	[IsAutoLateDeduct] [bit] NULL,
	[EarlyGraceDays] [int] NULL,
	[EarlyConsequesnce] [bit] NULL,
	[EarlyAction] [varchar](20) NULL,
	[IsAutoEarlyDeduct] [bit] NULL,
	[EffectiveFrom] [date] NOT NULL,
	[EffectiveTo] [date] NULL,
	[IsActive] [bit] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK__SaaS_Att__C3BC335CBF5A8682] PRIMARY KEY CLUSTERED 
(
	[ConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_ShiftDayRule]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_ShiftDayRule](
	[ShiftDayRuleId] [bigint] IDENTITY(1,1) NOT NULL,
	[ShiftId] [bigint] NOT NULL,
	[ConfigId] [bigint] NOT NULL,
	[DayOfWeek] [tinyint] NOT NULL,
	[WeekDayName] [varchar](50) NULL,
	[WeekMask] [tinyint] NOT NULL,
	[DayType] [tinyint] NOT NULL,
	[EffectiveFrom] [date] NOT NULL,
	[EffectiveTo] [date] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__SaaS_Att__FFCB5C2893BBD97B] PRIMARY KEY CLUSTERED 
(
	[ShiftDayRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Stamp_Log]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Stamp_Log](
	[StampLogId] [int] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[DeviceId] [int] NOT NULL,
	[DeviceSerialNumber] [nvarchar](100) NOT NULL,
	[OldStamp] [int] NOT NULL,
	[NewStamp] [int] NOT NULL,
	[SyncDirection] [nvarchar](10) NOT NULL,
	[RecordCount] [int] NOT NULL,
	[SyncTime] [datetime] NOT NULL,
	[IpAddress] [nvarchar](50) NULL,
	[Status] [nvarchar](20) NOT NULL,
	[ErrorMessage] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[StampLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Status_Config]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Status_Config](
	[ConfigId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[StatusId] [int] NOT NULL,
	[CustomLabel] [varchar](50) NOT NULL,
	[CustomColor] [varchar](10) NOT NULL,
	[PayableFactor] [decimal](4, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Tenant_Status] UNIQUE NONCLUSTERED 
(
	[TenantId] ASC,
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Status_Master]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Status_Master](
	[StatusId] [int] NOT NULL,
	[StatusCode] [varchar](20) NOT NULL,
	[StatusShortCode] [varchar](50) NULL,
	[DefaultLabel] [varchar](50) NOT NULL,
	[DefaultColor] [varchar](10) NULL,
	[PayableFactor] [decimal](4, 2) NOT NULL,
	[IsSystem] [bit] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK__SaaS_Att__C8EE206369AE730D] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__SaaS_Att__6A7B44FC08E4419C] UNIQUE NONCLUSTERED 
(
	[StatusCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_Attendance_Tenant_ExternalSource]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_Attendance_Tenant_ExternalSource](
	[SourceId] [int] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NOT NULL,
	[SourceType] [varchar](50) NOT NULL,
	[ConnectionString] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NULL,
	[LastSyncTime] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[SourceDatabase] [nvarchar](200) NULL,
	[DeviceUserIdField] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[SourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SaaS_AttendanceInsert_ErrorLog]    Script Date: 26-08-2026 14:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaaS_AttendanceInsert_ErrorLog](
	[ErrorLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantId] [uniqueidentifier] NULL,
	[RawPunchId] [bigint] NULL,
	[EmployeeId] [varchar](50) NULL,
	[PunchTime] [datetime] NULL,
	[ProcessName] [varchar](150) NULL,
	[PunchSource] [varchar](50) NULL,
	[IsProcessed] [int] NULL,
	[StatusName] [varchar](100) NULL,
	[IsError] [bit] NOT NULL,
	[Message] [nvarchar](1000) NULL,
	[ProcessingError] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[EmployeeNo] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ErrorLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Configaration_Header] ADD  CONSTRAINT [DF__SaaS_Atte__IsAct__331B2AEA]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Configaration_Header] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__340F4F23]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__WageT__11AF4A27]  DEFAULT ('MONTHLY') FOR [WageType]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__IsReg__12A36E60]  DEFAULT ((0)) FOR [IsRegularized]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__Total__13979299]  DEFAULT ((0)) FOR [TotalDurationMinutes]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__Actua__148BB6D2]  DEFAULT ((0)) FOR [ActualWorkMinutes]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__Break__157FDB0B]  DEFAULT ((0)) FOR [BreakMinutes]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__Overt__1673FF44]  DEFAULT ((0)) FOR [OvertimeMinutes]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__IsLat__1768237D]  DEFAULT ((0)) FOR [IsLate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__LateM__185C47B6]  DEFAULT ((0)) FOR [LateMinutes]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__IsEar__19506BEF]  DEFAULT ((0)) FOR [IsEarlyOut]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__Early__1A449028]  DEFAULT ((0)) FOR [EarlyMinutes]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__IsFin__1B38B461]  DEFAULT ((0)) FOR [IsFinalized]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__1C2CD89A]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Daily] ADD  CONSTRAINT [DF__SaaS_Atte__LastU__1D20FCD3]  DEFAULT (getutcdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Device_Master] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Device_Master] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Device_Master] ADD  DEFAULT ((0)) FOR [LastStamp]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShift] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShift] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride] ADD  CONSTRAINT [DF__SaaS_Atte__IsDay__0AD82F66]  DEFAULT ((0)) FOR [IsDayTypeOverride]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride] ADD  CONSTRAINT [DF__SaaS_Atte__IsShi__0BCC539F]  DEFAULT ((0)) FOR [IsShiftOverride]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride] ADD  CONSTRAINT [DF__SaaS_Atte__IsTim__0CC077D8]  DEFAULT ((0)) FOR [IsTimeOverride]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride] ADD  CONSTRAINT [DF__SaaS_Atte__IsAct__0EA8C04A]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__0F9CE483]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride] ADD  CONSTRAINT [DF__SaaS_Atte__IsAct__146199A0]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__1555BDD9]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SaaS_Attendance_ETL_Log] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Override] ADD  CONSTRAINT [DF__SaaS_Atte__IsAct__425D6E7A]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Override] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__435192B3]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SaaS_Attendance_RawPunch] ADD  CONSTRAINT [DF__SaaS_Atte__Punch__25B642D4]  DEFAULT ('DEVICE') FOR [PunchSource]
GO
ALTER TABLE [dbo].[SaaS_Attendance_RawPunch] ADD  CONSTRAINT [DF__SaaS_Atte__IsPro__26AA670D]  DEFAULT ((0)) FOR [IsProcessed]
GO
ALTER TABLE [dbo].[SaaS_Attendance_RawPunch] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__279E8B46]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Regularization] ADD  CONSTRAINT [DF__SaaS_Atte__Statu__4EC3455F]  DEFAULT ('PENDING') FOR [Status]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Regularization] ADD  CONSTRAINT [DF__SaaS_Atte__Reque__4FB76998]  DEFAULT (getutcdate()) FOR [RequestedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Regularization] ADD  CONSTRAINT [DF__SaaS_Atte__IsAct__50AB8DD1]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Regularization] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__519FB20A]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Sessions] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_ShiftConfig] ADD  CONSTRAINT [DF__SaaS_Atte__IsAct__39C82879]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_ShiftConfig] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__3ABC4CB2]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[SaaS_Attendance_ShiftDayRule] ADD  CONSTRAINT [DF__SaaS_Atte__IsAct__3E8CDD96]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Stamp_Log] ADD  DEFAULT (getdate()) FOR [SyncTime]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Status_Master] ADD  CONSTRAINT [DF__SaaS_Atte__Defau__7DA8517A]  DEFAULT ('#000000') FOR [DefaultColor]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Status_Master] ADD  CONSTRAINT [DF__SaaS_Atte__Payab__7E9C75B3]  DEFAULT ((1.00)) FOR [PayableFactor]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Status_Master] ADD  CONSTRAINT [DF__SaaS_Atte__IsSys__7F9099EC]  DEFAULT ((1)) FOR [IsSystem]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Status_Master] ADD  CONSTRAINT [DF__SaaS_Atte__Creat__0084BE25]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Tenant_ExternalSource] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Tenant_ExternalSource] ADD  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_AttendanceInsert_ErrorLog] ADD  DEFAULT ((1)) FOR [IsError]
GO
ALTER TABLE [dbo].[SaaS_AttendanceInsert_ErrorLog] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShift]  WITH CHECK ADD  CONSTRAINT [FK__SaaS_Atte__Shift__49FE9042] FOREIGN KEY([ShiftId])
REFERENCES [dbo].[SaaS_Attendance_Configaration_Header] ([ShiftId])
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShift] CHECK CONSTRAINT [FK__SaaS_Atte__Shift__49FE9042]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Override]  WITH CHECK ADD  CONSTRAINT [FK__SaaS_Atte__Shift__4445B6EC] FOREIGN KEY([ShiftId])
REFERENCES [dbo].[SaaS_Attendance_Configaration_Header] ([ShiftId])
GO
ALTER TABLE [dbo].[SaaS_Attendance_Override] CHECK CONSTRAINT [FK__SaaS_Atte__Shift__4445B6EC]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Regularization]  WITH CHECK ADD  CONSTRAINT [FK_Reg_Attendance] FOREIGN KEY([AttendanceId])
REFERENCES [dbo].[SaaS_Attendance_Daily] ([AttendanceId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SaaS_Attendance_Regularization] CHECK CONSTRAINT [FK_Reg_Attendance]
GO
ALTER TABLE [dbo].[SaaS_Attendance_ShiftDayRule]  WITH CHECK ADD  CONSTRAINT [FK__SaaS_Atte__Shift__3F8101CF] FOREIGN KEY([ShiftId])
REFERENCES [dbo].[SaaS_Attendance_Configaration_Header] ([ShiftId])
GO
ALTER TABLE [dbo].[SaaS_Attendance_ShiftDayRule] CHECK CONSTRAINT [FK__SaaS_Atte__Shift__3F8101CF]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Stamp_Log]  WITH CHECK ADD  CONSTRAINT [FK_StampLog_Device] FOREIGN KEY([DeviceId])
REFERENCES [dbo].[SaaS_Attendance_Device_Master] ([DeviceId])
GO
ALTER TABLE [dbo].[SaaS_Attendance_Stamp_Log] CHECK CONSTRAINT [FK_StampLog_Device]
GO
ALTER TABLE [dbo].[SaaS_Attendance_Status_Config]  WITH CHECK ADD  CONSTRAINT [FK_Config_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SaaS_Attendance_Status_Master] ([StatusId])
GO
ALTER TABLE [dbo].[SaaS_Attendance_Status_Config] CHECK CONSTRAINT [FK_Config_Status]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride]  WITH CHECK ADD  CONSTRAINT [CK_AttendanceMode] CHECK  (([AttendanceMode]='AUTO' OR [AttendanceMode]='DOUBLE' OR [AttendanceMode]='SINGLE' OR [AttendanceMode]='FLEXIBLE'))
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride] CHECK CONSTRAINT [CK_AttendanceMode]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride]  WITH CHECK ADD  CONSTRAINT [CK_DateMode] CHECK  (([OverrideMode]=(1) AND [RosterDate] IS NOT NULL AND [EffectiveFrom] IS NULL AND [EffectiveTo] IS NULL OR [OverrideMode]=(2) AND [RosterDate] IS NULL AND [EffectiveFrom] IS NOT NULL))
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftConfigOverride] CHECK CONSTRAINT [CK_DateMode]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride]  WITH CHECK ADD  CONSTRAINT [CK_EmpShiftDayRuleOverride_DateRange] CHECK  (([EffectiveTo] IS NULL OR [EffectiveTo]>=[EffectiveFrom]))
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride] CHECK CONSTRAINT [CK_EmpShiftDayRuleOverride_DateRange]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride]  WITH CHECK ADD  CONSTRAINT [CK_EmpShiftDayRuleOverride_DayOfWeek] CHECK  (([DayOfWeek]>=(0) AND [DayOfWeek]<=(6)))
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride] CHECK CONSTRAINT [CK_EmpShiftDayRuleOverride_DayOfWeek]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride]  WITH CHECK ADD  CONSTRAINT [CK_EmpShiftDayRuleOverride_DayType] CHECK  (([DayType]>=(1) AND [DayType]<=(4)))
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride] CHECK CONSTRAINT [CK_EmpShiftDayRuleOverride_DayType]
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride]  WITH CHECK ADD  CONSTRAINT [CK_EmpShiftDayRuleOverride_WeekMask] CHECK  (([WeekMask]>=(1) AND [WeekMask]<=(31)))
GO
ALTER TABLE [dbo].[SaaS_Attendance_EmployeeShiftDayRuleOverride] CHECK CONSTRAINT [CK_EmpShiftDayRuleOverride_WeekMask]
GO
ALTER TABLE [dbo].[SaaS_Attendance_ShiftConfig]  WITH CHECK ADD  CONSTRAINT [CK__SaaS_Atte__Atten__36EBBBCE] CHECK  (([AttendanceMode]='FLEXIBLE' OR [AttendanceMode]='SINGLE' OR [AttendanceMode]='DOUBLE'))
GO
ALTER TABLE [dbo].[SaaS_Attendance_ShiftConfig] CHECK CONSTRAINT [CK__SaaS_Atte__Atten__36EBBBCE]
GO
