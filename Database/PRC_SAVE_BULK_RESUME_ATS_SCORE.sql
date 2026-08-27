USE [Recruitment]
GO

/****** Object:  Table [dbo].[BulkResumeAtsScoreLog]    Script Date: 16-08-2026 11:27:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.BulkResumeAtsScoreLog', 'U') IS NULL
BEGIN
CREATE TABLE [dbo].[BulkResumeAtsScoreLog](
	[BulkResumeAtsScoreLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[POST_ID] [int] NOT NULL,
	[COMPANY_ID] [int] NOT NULL,
	[DEPARTMENT_ID] [int] NOT NULL,
	[LOCATION_ID] [int] NOT NULL,
	[CV_NAME] [nvarchar](500) NULL,
	[SAVED_CV_NAME] [nvarchar](500) NULL,
	[FILE_HASH] [varchar](64) NULL,
	[RESUME_FILE_LOCATION] [nvarchar](1000) NULL,
	[IMAGENAME] [nvarchar](500) NULL,
	[IMAGE_FILE_LOCATION] [nvarchar](1000) NULL,
	[CANDIDATE_NAME] [nvarchar](500) NULL,
	[MAIL_ID] [nvarchar](500) NULL,
	[PHONE_NUMBER] [nvarchar](50) NULL,
	[ATS_HEAD_RATING_ID] [int] NULL,
	[GENERATED_CANDIDATE_ID] [bigint] NULL,
	[REGISTRATION_NO] [nvarchar](50) NULL,
	[EXAM_OBTAINED_SCORE] [decimal](18, 2) NULL,
	[EXAM_IS_SHORTLISTED] [bit] NULL,
	[EXAM_RESULT_DATE] [datetime] NULL,
	[ATS_STATUS] [nvarchar](100) NULL,
	[IS_SHORTLISTED] [bit] NOT NULL,
	[IS_DUPLICATE] [bit] NOT NULL,
	[DUPLICATE_OF_LOG_ID] [bigint] NULL,
	[FULL_JSON] [nvarchar](max) NULL,
	[CANDIDATE_JSON] [nvarchar](max) NULL,
	[CREATED_DATE] [datetime] NOT NULL,
 CONSTRAINT [PK_BulkResumeAtsScoreLog] PRIMARY KEY CLUSTERED 
(
	[BulkResumeAtsScoreLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF COL_LENGTH('dbo.BulkResumeAtsScoreLog', 'REGISTRATION_NO') IS NULL
    ALTER TABLE [dbo].[BulkResumeAtsScoreLog]
    ADD [REGISTRATION_NO] [nvarchar](50) NULL;
GO

IF COL_LENGTH('dbo.BulkResumeAtsScoreLog', 'LOCATION_ID') IS NULL
    ALTER TABLE [dbo].[BulkResumeAtsScoreLog]
    ADD [LOCATION_ID] [int] NOT NULL
        CONSTRAINT [DF_BulkResumeAtsScoreLog_LOCATION_ID] DEFAULT ((0)) WITH VALUES
GO

IF OBJECT_ID('dbo.DF_BulkResumeAtsScoreLog_IS_SHORTLISTED', 'D') IS NULL
    ALTER TABLE [dbo].[BulkResumeAtsScoreLog] ADD  CONSTRAINT [DF_BulkResumeAtsScoreLog_IS_SHORTLISTED]  DEFAULT ((0)) FOR [IS_SHORTLISTED]
GO

IF OBJECT_ID('dbo.DF_BulkResumeAtsScoreLog_IS_DUPLICATE', 'D') IS NULL
    ALTER TABLE [dbo].[BulkResumeAtsScoreLog] ADD  CONSTRAINT [DF_BulkResumeAtsScoreLog_IS_DUPLICATE]  DEFAULT ((0)) FOR [IS_DUPLICATE]
GO

IF OBJECT_ID('dbo.DF_BulkResumeAtsScoreLog_CREATED_DATE', 'D') IS NULL
    ALTER TABLE [dbo].[BulkResumeAtsScoreLog] ADD  CONSTRAINT [DF_BulkResumeAtsScoreLog_CREATED_DATE]  DEFAULT (getdate()) FOR [CREATED_DATE]
GO




CREATE OR ALTER PROCEDURE dbo.PRC_GET_BULK_RESUME_ATS_BY_HASH
    @POST_ID INT,
    @LOCATION_ID INT = NULL,
    @FILE_HASH VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1
        BulkResumeAtsScoreLogID,
        POST_ID,
        CV_NAME,
        SAVED_CV_NAME,
        RESUME_FILE_LOCATION,
        IMAGE_FILE_LOCATION,
        ImageName,
        FILE_HASH,
        CANDIDATE_NAME,
        MAIL_ID,
        PHONE_NUMBER,
        COMPANY_ID,
        DEPARTMENT_ID,
        LOCATION_ID,
        ATS_HEAD_RATING_ID,
        GENERATED_CANDIDATE_ID,
        REGISTRATION_NO,
        EXAM_OBTAINED_SCORE,
        EXAM_IS_SHORTLISTED,
        EXAM_RESULT_DATE,
        ATS_STATUS,
        IS_SHORTLISTED,
        IS_DUPLICATE,
        DUPLICATE_OF_LOG_ID,
        FULL_JSON,
        CANDIDATE_JSON,
        CREATED_DATE
    FROM dbo.BulkResumeAtsScoreLog
    WHERE POST_ID = @POST_ID
      AND (@LOCATION_ID IS NULL OR @LOCATION_ID = 0 OR LOCATION_ID = @LOCATION_ID)
      AND FILE_HASH = @FILE_HASH
      AND IS_DUPLICATE = 0
    ORDER BY BulkResumeAtsScoreLogID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.PRC_SAVE_BULK_RESUME_TEMP_CANDIDATE_DETAILS
    @CandidateID BIGINT,
    @CandidateFirstName NVARCHAR(MAX) = NULL,
    @CandidateMiddleName NVARCHAR(MAX) = NULL,
    @CandidateLastName NVARCHAR(MAX) = NULL,
    @DateOfBirth NVARCHAR(MAX) = NULL,
    @Address NVARCHAR(MAX) = NULL,
    @CityOrVillage NVARCHAR(MAX) = NULL,
    @PostOffice NVARCHAR(MAX) = NULL,
    @PinCode NVARCHAR(MAX) = NULL,
    @Country NVARCHAR(MAX) = NULL,
    @State NVARCHAR(MAX) = NULL,
    @District NVARCHAR(MAX) = NULL,
    @Email NVARCHAR(MAX) = NULL,
    @Mobile NVARCHAR(MAX) = NULL,
    @AnyProject NVARCHAR(MAX) = NULL,
    @NumberOfCompanyChanges NVARCHAR(MAX) = NULL,
    @ResumeContentType NVARCHAR(MAX) = NULL,
    @ResumeFileName NVARCHAR(MAX) = NULL,
    @ResumeFile VARBINARY(MAX) = NULL,
    @QualificationJison NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.TempCandidateDetails WHERE CandidateID = @CandidateID)
    BEGIN
        DELETE FROM dbo.TempCandidateDetails WHERE CandidateID = @CandidateID;
    END

    INSERT INTO dbo.TempCandidateDetails
    (
        CandidateID,
        CandidateFirstName,
        CandidateMiddleName,
        CandidateLastName,
        DateOfBirth,
        Address,
        CityOrVillage,
        PostOffice,
        PinCode,
        Country,
        State,
        District,
        Email,
        Mobile,
        AnyProject,
        NumberOfCompanyChanges,
        ResumeContentType,
        ResumeFileName,
        Resumefile,
        QualificationJison
    )
    VALUES
    (
        @CandidateID,
        @CandidateFirstName,
        @CandidateMiddleName,
        @CandidateLastName,
        @DateOfBirth,
        @Address,
        @CityOrVillage,
        @PostOffice,
        @PinCode,
        @Country,
        @State,
        @District,
        @Email,
        @Mobile,
        @AnyProject,
        @NumberOfCompanyChanges,
        @ResumeContentType,
        @ResumeFileName,
        @ResumeFile,
        @QualificationJison
    );
END
GO

CREATE OR ALTER PROCEDURE dbo.PRC_SAVE_BULK_RESUME_ATS_SCORE
    @BulkResumeAtsScoreLogID BIGINT = NULL,
    @POST_ID INT,
    @CV_NAME NVARCHAR(500) = NULL,
    @SAVED_CV_NAME NVARCHAR(500) = NULL,
    @RESUME_FILE_LOCATION NVARCHAR(1000) = NULL,
    @IMAGE_FILE_LOCATION NVARCHAR(1000) = NULL,
    @IMAGE_NAME NVARCHAR(500) = NULL,
    @FILE_HASH VARCHAR(64) = NULL,
    @CANDIDATE_NAME NVARCHAR(500) = NULL,
    @MAIL_ID NVARCHAR(500) = NULL,
    @PHONE_NUMBER NVARCHAR(50) = NULL,
    @COMPANY_ID INT = NULL,
    @DEPARTMENT_ID INT = NULL,
    @LOCATION_ID INT = NULL,
    @ATS_HEAD_RATING_ID INT = NULL,
    @GENERATED_CANDIDATE_ID BIGINT = NULL,
    @REGISTRATION_NO NVARCHAR(50) = NULL,
    @ATS_STATUS NVARCHAR(100) = NULL,
    @IS_SHORTLISTED BIT = 0,
    @FULL_JSON NVARCHAR(MAX) = NULL,
    @CANDIDATE_JSON NVARCHAR(MAX) = NULL,
    @IS_DUPLICATE BIT = 0,
    @DUPLICATE_OF_LOG_ID BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @GENERATED_CANDIDATE_ID = 0 SET @GENERATED_CANDIDATE_ID = NULL;

    IF (@REGISTRATION_NO IS NULL OR LTRIM(RTRIM(@REGISTRATION_NO)) = '')
        SET @REGISTRATION_NO = 'Not Generated';

    -- Enforce only 3 valid ATS_STATUS values: 'Shortlisted', 'Rejected', 'ExtractionFailed'
    IF (UPPER(LTRIM(RTRIM(ISNULL(@ATS_STATUS, '')))) = 'EXTRACTIONFAILED')
    BEGIN
        SET @ATS_STATUS = 'ExtractionFailed';
        SET @IS_SHORTLISTED = 0;
    END
    ELSE IF (UPPER(LTRIM(RTRIM(ISNULL(@ATS_STATUS, '')))) = 'SHORTLISTED' OR @IS_SHORTLISTED = 1)
    BEGIN
        SET @ATS_STATUS = 'Shortlisted';
        SET @IS_SHORTLISTED = 1;
    END
    ELSE
    BEGIN
        SET @ATS_STATUS = 'Rejected';
        SET @IS_SHORTLISTED = 0;
    END

    -- If BulkResumeAtsScoreLogID is passed and > 0, update existing record
    IF (@BulkResumeAtsScoreLogID IS NOT NULL AND @BulkResumeAtsScoreLogID > 0 AND EXISTS (SELECT 1 FROM dbo.BulkResumeAtsScoreLog WHERE BulkResumeAtsScoreLogID = @BulkResumeAtsScoreLogID))
    BEGIN
        UPDATE dbo.BulkResumeAtsScoreLog
        SET
            POST_ID = COALESCE(@POST_ID, POST_ID),
            CV_NAME = COALESCE(NULLIF(LTRIM(RTRIM(@CV_NAME)), ''), CV_NAME),
            SAVED_CV_NAME = COALESCE(NULLIF(LTRIM(RTRIM(@SAVED_CV_NAME)), ''), SAVED_CV_NAME),
            RESUME_FILE_LOCATION = COALESCE(NULLIF(LTRIM(RTRIM(@RESUME_FILE_LOCATION)), ''), RESUME_FILE_LOCATION),
            IMAGE_FILE_LOCATION = COALESCE(NULLIF(LTRIM(RTRIM(@IMAGE_FILE_LOCATION)), ''), IMAGE_FILE_LOCATION),
            ImageName = COALESCE(NULLIF(LTRIM(RTRIM(@IMAGE_NAME)), ''), ImageName),
            FILE_HASH = COALESCE(NULLIF(LTRIM(RTRIM(@FILE_HASH)), ''), FILE_HASH),
            CANDIDATE_NAME = COALESCE(NULLIF(LTRIM(RTRIM(@CANDIDATE_NAME)), ''), CANDIDATE_NAME),
            MAIL_ID = COALESCE(NULLIF(LTRIM(RTRIM(@MAIL_ID)), ''), MAIL_ID),
            PHONE_NUMBER = COALESCE(NULLIF(LTRIM(RTRIM(@PHONE_NUMBER)), ''), PHONE_NUMBER),
            COMPANY_ID = COALESCE(@COMPANY_ID, COMPANY_ID),
            DEPARTMENT_ID = COALESCE(@DEPARTMENT_ID, DEPARTMENT_ID),
            LOCATION_ID = COALESCE(@LOCATION_ID, LOCATION_ID),
            ATS_HEAD_RATING_ID = COALESCE(@ATS_HEAD_RATING_ID, ATS_HEAD_RATING_ID),
            GENERATED_CANDIDATE_ID = NULLIF(COALESCE(@GENERATED_CANDIDATE_ID, GENERATED_CANDIDATE_ID), 0),
            REGISTRATION_NO = COALESCE(NULLIF(LTRIM(RTRIM(@REGISTRATION_NO)), ''), REGISTRATION_NO),
            ATS_STATUS = @ATS_STATUS,
            IS_SHORTLISTED = @IS_SHORTLISTED,
            IS_DUPLICATE = COALESCE(@IS_DUPLICATE, IS_DUPLICATE),
            DUPLICATE_OF_LOG_ID = @DUPLICATE_OF_LOG_ID,
            FULL_JSON = COALESCE(NULLIF(LTRIM(RTRIM(@FULL_JSON)), ''), FULL_JSON),
            CANDIDATE_JSON = COALESCE(NULLIF(LTRIM(RTRIM(@CANDIDATE_JSON)), ''), CANDIDATE_JSON)
        WHERE BulkResumeAtsScoreLogID = @BulkResumeAtsScoreLogID;

        SELECT @BulkResumeAtsScoreLogID AS BulkResumeAtsScoreLogID;
        RETURN;
    END

    -- Automatic Race-Condition Protection:
    -- If @IS_DUPLICATE is 0 but an existing log row for the same POST_ID and FILE_HASH already exists in BulkResumeAtsScoreLog,
    -- automatically treat this incoming row as a Duplicate!
    IF (@IS_DUPLICATE = 0)
    BEGIN
        DECLARE @ExistingLogID BIGINT = NULL;

        -- Check duplicate by FILE_HASH (post and location wise)
        IF (@FILE_HASH IS NOT NULL AND LEN(LTRIM(RTRIM(@FILE_HASH))) > 0)
        BEGIN
            SELECT TOP 1 @ExistingLogID = BulkResumeAtsScoreLogID
            FROM dbo.BulkResumeAtsScoreLog WITH (UPDLOCK, HOLDLOCK)
            WHERE POST_ID = @POST_ID
              AND (ISNULL(@LOCATION_ID, 0) = 0 OR LOCATION_ID = @LOCATION_ID)
              AND FILE_HASH = LTRIM(RTRIM(@FILE_HASH))
              AND IS_DUPLICATE = 0
            ORDER BY BulkResumeAtsScoreLogID ASC;
        END

        IF (@ExistingLogID IS NOT NULL)
        BEGIN
            SET @IS_DUPLICATE = 1;
            SET @DUPLICATE_OF_LOG_ID = @ExistingLogID;
        END
    END

    INSERT INTO dbo.BulkResumeAtsScoreLog
    (
        POST_ID,
        CV_NAME,
        SAVED_CV_NAME,
        RESUME_FILE_LOCATION,
        IMAGE_FILE_LOCATION,
        ImageName,
        FILE_HASH,
        CANDIDATE_NAME,
        MAIL_ID,
        PHONE_NUMBER,
        COMPANY_ID,
        DEPARTMENT_ID,
        LOCATION_ID,
        ATS_HEAD_RATING_ID,
        GENERATED_CANDIDATE_ID,
        REGISTRATION_NO,
        ATS_STATUS,
        IS_SHORTLISTED,
        IS_DUPLICATE,
        DUPLICATE_OF_LOG_ID,
        FULL_JSON,
        CANDIDATE_JSON,
        CREATED_DATE
    )
    VALUES
    (
        @POST_ID,
        @CV_NAME,
        @SAVED_CV_NAME,
        @RESUME_FILE_LOCATION,
        @IMAGE_FILE_LOCATION,
        @IMAGE_NAME,
        @FILE_HASH,
        @CANDIDATE_NAME,
        @MAIL_ID,
        @PHONE_NUMBER,
        @COMPANY_ID,
        @DEPARTMENT_ID,
        ISNULL(@LOCATION_ID, 0),
        @ATS_HEAD_RATING_ID,
        @GENERATED_CANDIDATE_ID,
        @REGISTRATION_NO,
        @ATS_STATUS,
        @IS_SHORTLISTED,
        @IS_DUPLICATE,
        @DUPLICATE_OF_LOG_ID,
        @FULL_JSON,
        @CANDIDATE_JSON,
        GETDATE()
    );

    SELECT CAST(SCOPE_IDENTITY() AS BIGINT) AS BulkResumeAtsScoreLogID;
END
GO

CREATE OR ALTER PROCEDURE dbo.PRC_GET_BULK_RESUME_ATS_BY_ID
    @BulkResumeAtsScoreLogID BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1
        BulkResumeAtsScoreLogID,
        POST_ID,
        CV_NAME,
        SAVED_CV_NAME,
        RESUME_FILE_LOCATION,
        IMAGE_FILE_LOCATION,
        ImageName,
        FILE_HASH,
        CANDIDATE_NAME,
        MAIL_ID,
        PHONE_NUMBER,
        COMPANY_ID,
        DEPARTMENT_ID,
        LOCATION_ID,
        ATS_HEAD_RATING_ID,
        GENERATED_CANDIDATE_ID,
        REGISTRATION_NO,
        ATS_STATUS,
        IS_SHORTLISTED,
        IS_DUPLICATE,
        DUPLICATE_OF_LOG_ID,
        FULL_JSON,
        CANDIDATE_JSON,
        EXAM_OBTAINED_SCORE,
        EXAM_IS_SHORTLISTED,
        EXAM_RESULT_DATE,
        CREATED_DATE
    FROM dbo.BulkResumeAtsScoreLog
    WHERE BulkResumeAtsScoreLogID = @BulkResumeAtsScoreLogID;
END
GO

CREATE OR ALTER PROCEDURE dbo.PRC_UPDATE_BULK_RESUME_ATS_SCORE
    @POST_ID INT,
    @FILE_HASH VARCHAR(64) = NULL,
    @CANDIDATE_NAME NVARCHAR(500) = NULL,
    @MAIL_ID NVARCHAR(500) = NULL,
    @PHONE_NUMBER NVARCHAR(50) = NULL,
    @CANDIDATE_ID BIGINT = NULL,
    @REGISTRATION_NO NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @CANDIDATE_ID = 0 SET @CANDIDATE_ID = NULL;

    UPDATE dbo.BulkResumeAtsScoreLog
    SET
        CANDIDATE_NAME = COALESCE(NULLIF(LTRIM(RTRIM(@CANDIDATE_NAME)), ''), CANDIDATE_NAME),
        MAIL_ID = COALESCE(NULLIF(LTRIM(RTRIM(@MAIL_ID)), ''), MAIL_ID),
        PHONE_NUMBER = COALESCE(NULLIF(LTRIM(RTRIM(@PHONE_NUMBER)), ''), PHONE_NUMBER),
        GENERATED_CANDIDATE_ID = NULLIF(COALESCE(@CANDIDATE_ID, GENERATED_CANDIDATE_ID), 0),
        REGISTRATION_NO = COALESCE(NULLIF(LTRIM(RTRIM(@REGISTRATION_NO)), ''), REGISTRATION_NO)
    WHERE POST_ID = @POST_ID
      AND FILE_HASH = @FILE_HASH
      AND IS_DUPLICATE = 0;
END
GO

CREATE OR ALTER PROCEDURE dbo.PRC_UPDATE_BULK_RESUME_EXAM_RESULT
    @BulkResumeAtsScoreLogID BIGINT,
    @EXAM_OBTAINED_SCORE DECIMAL(18,2) = NULL,
    @EXAM_IS_SHORTLISTED BIT = NULL,
    @GENERATED_CANDIDATE_ID BIGINT = NULL,
    @REGISTRATION_NO NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @GENERATED_CANDIDATE_ID = 0 SET @GENERATED_CANDIDATE_ID = NULL;

    UPDATE dbo.BulkResumeAtsScoreLog
    SET
        EXAM_OBTAINED_SCORE = @EXAM_OBTAINED_SCORE,
        EXAM_IS_SHORTLISTED = @EXAM_IS_SHORTLISTED,
        EXAM_RESULT_DATE = GETDATE(),
        GENERATED_CANDIDATE_ID = NULLIF(COALESCE(@GENERATED_CANDIDATE_ID, GENERATED_CANDIDATE_ID), 0),
        REGISTRATION_NO = COALESCE(NULLIF(LTRIM(RTRIM(@REGISTRATION_NO)), ''), REGISTRATION_NO)
    WHERE BulkResumeAtsScoreLogID = @BulkResumeAtsScoreLogID;
END
GO

CREATE OR ALTER PROCEDURE dbo.PRC_GET_BULK_RESUME_ATS_REPORT
    @COMPANY_ID INT = NULL,
    @DEPARTMENT_ID INT = NULL,
    @POST_ID INT = NULL,
    @LOCATION_ID INT = NULL,
    @KEYWORD NVARCHAR(500) = NULL,
    @FROM_DATE DATETIME = NULL,
    @TO_DATE DATETIME = NULL,
    @TAKE INT = 500
AS
BEGIN
    SET NOCOUNT ON;

    IF @TAKE IS NULL OR @TAKE <= 0
        SET @TAKE = 500;

    IF @COMPANY_ID = 0 SET @COMPANY_ID = NULL;
    IF @DEPARTMENT_ID = 0 SET @DEPARTMENT_ID = NULL;
    IF @POST_ID = 0 SET @POST_ID = NULL;
    IF @LOCATION_ID = 0 SET @LOCATION_ID = NULL;
    IF LTRIM(RTRIM(@KEYWORD)) = '' SET @KEYWORD = NULL;

    SELECT TOP (@TAKE)
        L.BulkResumeAtsScoreLogID,
        L.POST_ID,
        L.CV_NAME,
        L.SAVED_CV_NAME,
        L.RESUME_FILE_LOCATION,
        L.IMAGE_FILE_LOCATION,
        L.ImageName,
        L.FILE_HASH,
        L.CANDIDATE_NAME,
        L.MAIL_ID,
        L.PHONE_NUMBER,
        L.ATS_HEAD_RATING_ID,
        L.COMPANY_ID,
        C.Company AS COMPANY_NAME,
        C.Company AS COMPANY,
        L.DEPARTMENT_ID,
        L.LOCATION_ID,
        L.POST_ID AS JD_POST_ID,
        P.postname AS POST_NAME,
        P.postname AS POST,
        COALESCE(L.GENERATED_CANDIDATE_ID, TS.CandidateID) AS GENERATED_CANDIDATE_ID,
        COALESCE(NULLIF(LTRIM(RTRIM(L.REGISTRATION_NO)), ''), NULLIF(LTRIM(RTRIM(TC.registrationnumber)), ''), 'Not Generated') AS REGISTRATION_NO,
        COALESCE(NULLIF(LTRIM(RTRIM(L.REGISTRATION_NO)), ''), NULLIF(LTRIM(RTRIM(TC.registrationnumber)), ''), 'Not Generated') AS RegistrationNo,
        L.EXAM_OBTAINED_SCORE,
        L.EXAM_IS_SHORTLISTED,
        L.EXAM_RESULT_DATE,
        L.ATS_STATUS,
        L.IS_SHORTLISTED,
        L.IS_DUPLICATE,
        L.DUPLICATE_OF_LOG_ID,
        L.CREATED_DATE,
        CASE
            WHEN ISJSON(L.FULL_JSON) = 1 THEN JSON_VALUE(L.FULL_JSON, '$.batchId')
            ELSE NULL
        END AS BATCH_ID,
        CASE
            WHEN COALESCE(L.GENERATED_CANDIDATE_ID, TS.CandidateID) IS NOT NULL THEN 'Created'
            WHEN L.EXAM_IS_SHORTLISTED = 1 THEN 'Passed'
            WHEN L.EXAM_IS_SHORTLISTED = 0 THEN 'Failed'
            ELSE 'Pending'
        END AS EXAM_STATUS_DISPLAY,
        CASE
            WHEN ISJSON(L.FULL_JSON) = 1
                THEN CONCAT(
                    ISNULL(JSON_VALUE(L.FULL_JSON, '$.match_score'), '0'),
                    ' / ',
                    ISNULL(JSON_VALUE(L.FULL_JSON, '$.percentage'), '0'),
                    '%'
                )
            ELSE '-'
        END AS ATS_SCORE_DISPLAY,
        L.FULL_JSON,
        L.CANDIDATE_JSON
    FROM dbo.BulkResumeAtsScoreLog L
    LEFT JOIN dbo.trecruitappliedpost P
        ON P.postid = L.POST_ID
    LEFT JOIN dbo.Company C
        ON C.companyPK = L.COMPANY_ID
    LEFT JOIN dbo.trecruitcandidatesignup TS
        ON (L.GENERATED_CANDIDATE_ID IS NOT NULL AND TS.CandidateID = L.GENERATED_CANDIDATE_ID)
        OR (NULLIF(LTRIM(RTRIM(L.MAIL_ID)), '') IS NOT NULL AND TS.mailid = LTRIM(RTRIM(L.MAIL_ID)))
    LEFT JOIN dbo.trecruitcanbasicdtls TC
        ON TC.candidateid = COALESCE(L.GENERATED_CANDIDATE_ID, TS.CandidateID)
    WHERE
        (
            @COMPANY_ID IS NULL
            OR @COMPANY_ID = 0
            OR L.COMPANY_ID = @COMPANY_ID
        )
        AND (
            @DEPARTMENT_ID IS NULL
            OR @DEPARTMENT_ID = 0
            OR L.DEPARTMENT_ID = @DEPARTMENT_ID
        )
        AND
        (@POST_ID IS NULL OR @POST_ID = 0 OR L.POST_ID = @POST_ID)
        AND (@LOCATION_ID IS NULL OR @LOCATION_ID = 0 OR L.LOCATION_ID = @LOCATION_ID)
        AND (
            NULLIF(LTRIM(RTRIM(@KEYWORD)), '') IS NULL
            OR L.CANDIDATE_NAME LIKE '%' + @KEYWORD + '%'
            OR L.MAIL_ID LIKE '%' + @KEYWORD + '%'
            OR L.PHONE_NUMBER LIKE '%' + @KEYWORD + '%'
            OR L.CV_NAME LIKE '%' + @KEYWORD + '%'
            OR P.postname LIKE '%' + @KEYWORD + '%'
            OR L.REGISTRATION_NO LIKE '%' + @KEYWORD + '%'
            OR TC.registrationnumber LIKE '%' + @KEYWORD + '%'
        )
        AND (@FROM_DATE IS NULL OR L.CREATED_DATE >= @FROM_DATE)
        AND (@TO_DATE IS NULL OR L.CREATED_DATE < DATEADD(DAY, 1, @TO_DATE))
    ORDER BY L.BulkResumeAtsScoreLogID DESC;
END
GO

CREATE OR ALTER PROCEDURE dbo.PRC_CHECK_BULK_RESUME_CANDIDATE_EXISTS
    @username NVARCHAR(500) = NULL,
    @mailid NVARCHAR(500) = NULL,
    @postId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF ((@mailid IS NULL OR LTRIM(RTRIM(@mailid)) = '') AND (@username IS NULL OR LTRIM(RTRIM(@username)) = ''))
    BEGIN
        SELECT TOP 0 
            CAST(NULL AS NVARCHAR(500)) AS username, 
            CAST(NULL AS NVARCHAR(500)) AS mailid, 
            CAST(NULL AS BIGINT) AS CandidateID,
            CAST(NULL AS NVARCHAR(50)) AS RegistrationNo,
            CAST(NULL AS BIGINT) AS BulkResumeAtsScoreLogID,
            CAST(NULL AS NVARCHAR(100)) AS SourceType;
        RETURN;
    END

    -- 1. Check in trecruitcandidatesignup (registered candidates)
    IF EXISTS (
        SELECT 1 
        FROM trecruitcandidatesignup TS 
        LEFT JOIN trecruitcanbasicdtls TC ON TC.candidateid = TS.CandidateID
        WHERE (NULLIF(LTRIM(RTRIM(@mailid)), '') IS NOT NULL AND TS.mailid = LTRIM(RTRIM(@mailid)))
           OR (NULLIF(LTRIM(RTRIM(@username)), '') IS NOT NULL AND TS.username = LTRIM(RTRIM(@username)))
    )
    BEGIN
        SELECT TOP 1
            TS.CandidateID,
            COALESCE(NULLIF(LTRIM(RTRIM(TC.registrationnumber)), ''), 'Not Generated') AS RegistrationNo,
            TS.username,
            TS.mailid,
            CAST(NULL AS BIGINT) AS BulkResumeAtsScoreLogID,
            'RegisteredCandidate' AS SourceType
        FROM trecruitcandidatesignup TS
        LEFT JOIN trecruitcanbasicdtls TC ON TC.candidateid = TS.CandidateID
        WHERE (NULLIF(LTRIM(RTRIM(@mailid)), '') IS NOT NULL AND TS.mailid = LTRIM(RTRIM(@mailid)))
           OR (NULLIF(LTRIM(RTRIM(@username)), '') IS NOT NULL AND TS.username = LTRIM(RTRIM(@username)));
        RETURN;
    END

    -- 2. Check in BulkResumeAtsScoreLog for the same post (bulk uploaded candidate)
    IF (@postId IS NOT NULL AND @postId > 0)
    BEGIN
        IF EXISTS (
            SELECT 1 FROM dbo.BulkResumeAtsScoreLog
            WHERE POST_ID = @postId
              AND NULLIF(LTRIM(RTRIM(MAIL_ID)), '') = LTRIM(RTRIM(@mailid))
              AND IS_DUPLICATE = 0
        )
        BEGIN
            SELECT TOP 1
                GENERATED_CANDIDATE_ID AS CandidateID,
                COALESCE(NULLIF(LTRIM(RTRIM(REGISTRATION_NO)), ''), 'Not Generated') AS RegistrationNo,
                MAIL_ID AS username,
                MAIL_ID AS mailid,
                BulkResumeAtsScoreLogID,
                'BulkResumeLog' AS SourceType
            FROM dbo.BulkResumeAtsScoreLog
            WHERE POST_ID = @postId
              AND NULLIF(LTRIM(RTRIM(MAIL_ID)), '') = LTRIM(RTRIM(@mailid))
              --AND IS_DUPLICATE = 0
            ORDER BY BulkResumeAtsScoreLogID ASC;
            RETURN;
        END
    END
END
GO

CREATE OR ALTER PROCEDURE dbo.SP_SAVE_LMS_EXAM_RESULT_ATS_SCORE
    @CANDIDATE_ID INT,
    @POST_ID INT,
    @LOCATION_ID INT,
    @COMPANY_ID INT,
    @DEPARTMENT_ID INT,
    @ExamMarks DECIMAL(18,2),
    @ExamStatus NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    /*
     * LMS exam result save/update:
     * This SP only saves LMS exam fields in HEAD_ATS_SCORE.
     * ATS fields like TOTAL_SCORE and OBTAIN_MARKS are preserved.
     */
    DECLARE @ATS_SCORE_ID INT;

    SELECT @ATS_SCORE_ID = ATS_SCORE_ID
    FROM dbo.HEAD_ATS_SCORE
    WHERE CANDIDATE_ID = @CANDIDATE_ID
      AND ACTUAL_POST_ID = @POST_ID
      AND LOCATION_ID = @LOCATION_ID
      AND COMPANY_ID = @COMPANY_ID
      AND DEPARTMENT_ID = @DEPARTMENT_ID;

    IF @ATS_SCORE_ID IS NOT NULL
    BEGIN
        UPDATE dbo.HEAD_ATS_SCORE
        SET
            ExamMarks = @ExamMarks,
            ExamStatus = @ExamStatus
        WHERE ATS_SCORE_ID = @ATS_SCORE_ID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.HEAD_ATS_SCORE
        (
            CANDIDATE_ID,
            ACTUAL_POST_ID,
            LOCATION_ID,
            COMPANY_ID,
            DEPARTMENT_ID,
            ExamMarks,
            ExamStatus
        )
        VALUES
        (
            @CANDIDATE_ID,
            @POST_ID,
            @LOCATION_ID,
            @COMPANY_ID,
            @DEPARTMENT_ID,
            @ExamMarks,
            @ExamStatus
        );

        SET @ATS_SCORE_ID = SCOPE_IDENTITY();
    END

    SELECT @ATS_SCORE_ID AS ATS_SCORE_ID;
END
GO

CREATE OR ALTER PROCEDURE dbo.PRC_CHECK_RECRUIT_CANDIDATE_SIGNUP_BY_ID
    @CandidateID BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1
        CandidateID,
        FirstName,
        Middlename,
        Lastname,
        username,
        MailId,
        CreatedTime,
        ModifiedTime
    FROM dbo.trecruitcandidatesignup
    WHERE CandidateID = @CandidateID;
END
GO

     
CREATE OR ALTER   PROCEDURE dbo.PRC_Receruitment_PostList     
    @CompanyID INT = NULL,    
    @DepartmentID INT = NULL    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    IF @CompanyID = 0 SET @CompanyID = NULL;    
    IF @DepartmentID = 0 SET @DepartmentID = NULL;    
    
    SELECT    
        TD.PostID,    
        LTRIM(RTRIM(postname))+'-'+LTRIM(RTRIM(Location)) AS PostName,    
        IDCompany AS CompanyID,    
        Deptid AS DepartmentID,
        LC.locid AS LocationID   
    FROM trecruitappliedpost TD 
    INNER JOIN trecruitpostlocationmap LCM ON LCM.PostID=TD.postid 
    INNER JOIN trecruitpostlocation LC ON LC.locid=LCM.locid
    WHERE    
        IDCompany IS NOT NULL    
        AND Deptid IS NOT NULL    
        AND (@CompanyID IS NULL OR IDCompany = @CompanyID)    
        AND (@DepartmentID IS NULL OR Deptid = @DepartmentID)    
        AND LCM.Activeflag='Y'    
    GROUP BY    
        TD.postid,    
        LTRIM(RTRIM(postname)),
        LTRIM(RTRIM(Location)),
        IDCompany,    
        Deptid,
        LC.locid    
    ORDER BY PostName ASC;    
END 
GO

CREATE OR ALTER PROCEDURE dbo.PRC_Receruitment_Company_List
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        A.companyPK AS ID,
        A.Company AS CompanyName
    FROM Company A
    WHERE A.ActiveYN = 1;
END
GO

CREATE OR ALTER Proc PRC_Receruitment_DepartmentList            
As            
Begin            
     
WITH CTE AS (      
   SELECT ID, DeptName,  ROW_NUMBER() OVER (PARTITION BY  DeptName  ORDER BY (SELECT 0)) AS rn      
   FROM  [trecruitdepartment] WHERE ActiveFlag='Y'         
       
)      
SELECT ID, DeptName       
FROM CTE      
WHERE rn = 1  and Deptname not in ('') And Deptname not like'%DEMO%'     
ORDER BY Deptname         
End       
GO

CREATE OR ALTER PROCEDURE dbo.PRC_UPDATE_BULK_RESUME_ATS_STATUS
    @BulkResumeAtsScoreLogID BIGINT,
    @ATS_STATUS NVARCHAR(100) = NULL,
    @IS_SHORTLISTED BIT = 0,
    @IS_DUPLICATE BIT = 0,
    @DUPLICATE_OF_LOG_ID BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.BulkResumeAtsScoreLog
    SET
        ATS_STATUS = COALESCE(NULLIF(LTRIM(RTRIM(@ATS_STATUS)), ''), ATS_STATUS),
        IS_SHORTLISTED = @IS_SHORTLISTED,
        IS_DUPLICATE = @IS_DUPLICATE,
        DUPLICATE_OF_LOG_ID = @DUPLICATE_OF_LOG_ID
    WHERE BulkResumeAtsScoreLogID = @BulkResumeAtsScoreLogID;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

