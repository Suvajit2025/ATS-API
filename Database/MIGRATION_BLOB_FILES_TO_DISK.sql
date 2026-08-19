-- =========================================================================================
-- SCRIPT: Database Schema Updates & Stored Procedures for BLOB to File Disk Migration
-- TABLES: dbo.trecruituploadresume & dbo.trecruituploadimage
-- =========================================================================================

-- =========================================================================================
-- 1. ALTER TABLE: dbo.trecruituploadresume
-- =========================================================================================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'IsMigrated')
    ALTER TABLE dbo.trecruituploadresume ADD IsMigrated BIT NOT NULL DEFAULT 0;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'ConvertToPath')
    ALTER TABLE dbo.trecruituploadresume ADD ConvertToPath BIT NOT NULL DEFAULT 0;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'FileName')
    ALTER TABLE dbo.trecruituploadresume ADD FileName VARCHAR(255) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'FileUrl')
    ALTER TABLE dbo.trecruituploadresume ADD FileUrl VARCHAR(500) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'ResumeFilePath')
    ALTER TABLE dbo.trecruituploadresume ADD ResumeFilePath VARCHAR(500) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'MigrationDate')
    ALTER TABLE dbo.trecruituploadresume ADD MigrationDate DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'MigrationStatus')
    ALTER TABLE dbo.trecruituploadresume ADD MigrationStatus VARCHAR(50) NULL DEFAULT 'Pending';

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'MigrationError')
    ALTER TABLE dbo.trecruituploadresume ADD MigrationError NVARCHAR(MAX) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadresume') AND name = 'FileSize')
    ALTER TABLE dbo.trecruituploadresume ADD FileSize BIGINT NULL;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_trecruituploadresume_Migration' AND object_id = OBJECT_ID('dbo.trecruituploadresume'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_trecruituploadresume_Migration 
    ON dbo.trecruituploadresume (IsMigrated, id);
END
GO

-- =========================================================================================
-- 2. ALTER TABLE: dbo.trecruituploadimage
-- =========================================================================================
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'IsMigrated')
    ALTER TABLE dbo.trecruituploadimage ADD IsMigrated BIT NOT NULL DEFAULT 0;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'ConvertToPath')
    ALTER TABLE dbo.trecruituploadimage ADD ConvertToPath BIT NOT NULL DEFAULT 0;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'FileName')
    ALTER TABLE dbo.trecruituploadimage ADD FileName VARCHAR(255) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'FilePath')
    ALTER TABLE dbo.trecruituploadimage ADD FilePath VARCHAR(500) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'FileUrl')
    ALTER TABLE dbo.trecruituploadimage ADD FileUrl VARCHAR(500) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'MigrationDate')
    ALTER TABLE dbo.trecruituploadimage ADD MigrationDate DATETIME NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'MigrationStatus')
    ALTER TABLE dbo.trecruituploadimage ADD MigrationStatus VARCHAR(50) NULL DEFAULT 'Pending';

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'MigrationError')
    ALTER TABLE dbo.trecruituploadimage ADD MigrationError NVARCHAR(MAX) NULL;

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.trecruituploadimage') AND name = 'FileSize')
    ALTER TABLE dbo.trecruituploadimage ADD FileSize BIGINT NULL;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_trecruituploadimage_Migration' AND object_id = OBJECT_ID('dbo.trecruituploadimage'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_trecruituploadimage_Migration 
    ON dbo.trecruituploadimage (IsMigrated, imageid);
END
GO

-- =========================================================================================
-- 3. STORED PROCEDURE: PRC_GET_MIGRATION_STATUS
-- =========================================================================================
CREATE OR ALTER PROCEDURE dbo.PRC_GET_MIGRATION_STATUS
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        'Image' AS Category,
        COUNT(1) AS TotalRecords,
        SUM(CASE WHEN ISNULL(IsMigrated, 0) = 1 OR ISNULL(ConvertToPath, 0) = 1 THEN 1 ELSE 0 END) AS MigratedRecords,
        SUM(CASE WHEN (ISNULL(IsMigrated, 0) = 0 AND ISNULL(ConvertToPath, 0) = 0) AND Data IS NOT NULL THEN 1 ELSE 0 END) AS PendingRecords
    FROM dbo.trecruituploadimage WITH (NOLOCK)
    UNION ALL
    SELECT 
        'Resume' AS Category,
        COUNT(1) AS TotalRecords,
        SUM(CASE WHEN ISNULL(IsMigrated, 0) = 1 OR ISNULL(ConvertToPath, 0) = 1 THEN 1 ELSE 0 END) AS MigratedRecords,
        SUM(CASE WHEN (ISNULL(IsMigrated, 0) = 0 AND ISNULL(ConvertToPath, 0) = 0) AND resumefile IS NOT NULL THEN 1 ELSE 0 END) AS PendingRecords
    FROM dbo.trecruituploadresume WITH (NOLOCK);
END
GO

-- =========================================================================================
-- 4. STORED PROCEDURE: PRC_GET_PENDING_MIGRATION_IMAGES
-- =========================================================================================
CREATE OR ALTER PROCEDURE dbo.PRC_GET_PENDING_MIGRATION_IMAGES
    @BatchSize INT = 500,
    @ImageId BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @BatchSize <= 0 SET @BatchSize = 500;

    SELECT TOP (@BatchSize) 
        imageid,
        candidateid,
        name,
        ContentType,
        Data,
        username
    FROM dbo.trecruituploadimage WITH (NOLOCK)
    WHERE (@ImageId IS NOT NULL OR (ISNULL(IsMigrated, 0) = 0 AND ISNULL(ConvertToPath, 0) = 0))
      AND (@ImageId IS NULL OR imageid = @ImageId)
      AND Data IS NOT NULL
    ORDER BY imageid ASC;
END
GO

-- =========================================================================================
-- 5. STORED PROCEDURE: PRC_UPDATE_MIGRATED_IMAGE
-- =========================================================================================
CREATE OR ALTER PROCEDURE dbo.PRC_UPDATE_MIGRATED_IMAGE
    @ImageId BIGINT,
    @FileName VARCHAR(255) = NULL,
    @FilePath VARCHAR(500) = NULL,
    @FileUrl VARCHAR(500) = NULL,
    @FileSize BIGINT = NULL,
    @Status VARCHAR(50) = 'Success',
    @ErrorMessage NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Status = 'Success'
    BEGIN
        UPDATE dbo.trecruituploadimage
        SET FileName = @FileName,
            FilePath = @FilePath,
            FileUrl = @FileUrl,
            IsMigrated = 1,
            ConvertToPath = 1,
            MigrationDate = GETDATE(),
            MigrationStatus = 'Success',
            MigrationError = NULL,
            FileSize = @FileSize,
            modifiedtime = GETDATE()
        WHERE imageid = @ImageId;
    END
    ELSE
    BEGIN
        UPDATE dbo.trecruituploadimage
        SET MigrationStatus = 'Failed',
            MigrationError = @ErrorMessage,
            modifiedtime = GETDATE()
        WHERE imageid = @ImageId;
    END
END
GO

-- =========================================================================================
-- 6. STORED PROCEDURE: PRC_GET_PENDING_MIGRATION_RESUMES
-- =========================================================================================
CREATE OR ALTER PROCEDURE dbo.PRC_GET_PENDING_MIGRATION_RESUMES
    @BatchSize INT = 500,
    @Id BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @BatchSize <= 0 SET @BatchSize = 500;

    SELECT TOP (@BatchSize) 
        id,
        candidateid,
        Name,
        ContentType,
        resumefile,
        username
    FROM dbo.trecruituploadresume WITH (NOLOCK)
    WHERE (@Id IS NOT NULL OR (ISNULL(IsMigrated, 0) = 0 AND ISNULL(ConvertToPath, 0) = 0))
      AND (@Id IS NULL OR id = @Id)
      AND resumefile IS NOT NULL
    ORDER BY id ASC;
END
GO

-- =========================================================================================
-- 7. STORED PROCEDURE: PRC_UPDATE_MIGRATED_RESUME
-- =========================================================================================
CREATE OR ALTER PROCEDURE dbo.PRC_UPDATE_MIGRATED_RESUME
    @Id BIGINT,
    @FileName VARCHAR(255) = NULL,
    @ResumeFilePath VARCHAR(500) = NULL,
    @FileUrl VARCHAR(500) = NULL,
    @FileSize BIGINT = NULL,
    @Status VARCHAR(50) = 'Success',
    @ErrorMessage NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Status = 'Success'
    BEGIN
        UPDATE dbo.trecruituploadresume
        SET FileName = @FileName,
            ResumeFilePath = @ResumeFilePath,
            FileUrl = @FileUrl,
            IsMigrated = 1,
            ConvertToPath = 1,
            MigrationDate = GETDATE(),
            MigrationStatus = 'Success',
            MigrationError = NULL,
            FileSize = @FileSize,
            modifiedtime = GETDATE()
        WHERE id = @Id;
    END
    ELSE
    BEGIN
        UPDATE dbo.trecruituploadresume
        SET MigrationStatus = 'Failed',
            MigrationError = @ErrorMessage,
            modifiedtime = GETDATE()
        WHERE id = @Id;
    END
END
GO
