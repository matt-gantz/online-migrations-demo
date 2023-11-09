CREATE OR ALTER PROC dbo.MigrateBadges
	 @InitialBatchSize INT = 50
	, @InitialDelayTime varchar(8) = '00:00:00'
AS
SET NOCOUNT ON
-----------------Prepare Pre-Reqs ------------------------------------
DECLARE @BatchSize INT = @InitialBatchSize
	, @DelayTime varchar(8) = @InitialDelayTime
	, @Stop BIT = 0
	, @LogId INT
	, @RwCnt INT
	, @ErrorMsg nvarchar(4000)
	, @ErrorNum INT

IF (OBJECT_ID ('tempdb.dbo.MigrateBadges_Log') IS NULL)
	CREATE TABLE tempdb.dbo.MigrateBadges_Log (
		MigrateBadges_LogId INT IDENTITY NOT NULL PRIMARY KEY CLUSTERED
		, StartTime DATETIME2(7) NOT NULL
		, EndTime DATETIME2(7) NULL
		, RecordCount INT NULL
		, [BatchSize] INT NOT NULL
		, ErrorMsg NVARCHAR(4000) NULL
		, ErrorNum INT NULL
		);

IF (OBJECT_ID ('tempdb.dbo.MigrateBadges_Config') IS NULL)
	CREATE TABLE tempdb.dbo.MigrateBadges_Config (
		MigrateBadges_ConfigId INT NOT NULL DEFAULT (1) PRIMARY KEY CLUSTERED 
		, DelayTime varchar(8)
		, [BatchSize] INT NOT NULL
		, [Stop] bit not null default (0)
		, CONSTRAINT CH_MigrateBadges_ConfigId CHECK (MigrateBadges_ConfigId =1)
		);

IF ((SELECT COUNT(1) FROM tempdb.dbo.MigrateBadges_Config WHERE MigrateBadges_ConfigId = 1)=0)
	INSERT INTO tempdb.dbo.MigrateBadges_Config (DelayTime,BatchSize)
	VALUES (@InitialDelayTime, @InitialBatchSize)
ELSE
	UPDATE tempdb.dbo.MigrateBadges_Config
		SET [BatchSize] = @InitialBatchSize
		, DelayTime = @InitialDelayTime
		, [Stop] = 0

IF (OBJECT_ID ('#ToProcess') IS NULL)
	CREATE TABLE #ToProcess (Id INT NOT NULL PRIMARY KEY CLUSTERED)
IF (OBJECT_ID ('#Batch') IS NULL)
	CREATE TABLE #Batch (Id INT NOT NULL PRIMARY KEY CLUSTERED)

-----------------Gather Ids------------------------------------
INSERT INTO #ToProcess (Id)
SELECT Id 
FROM dbo.Badges 
WHERE BadgeTypeId = -1

-----------------Main Loop------------------------------------
WHILE (@Stop = 0)
BEGIN
	--Load up our batch table while deleting from the main set
	DELETE TOP (@BatchSize) #ToProcess 
	OUTPUT DELETED.Id INTO #Batch (Id)

	--Once the rowcount is less than the batchsize, we can stop (after this loop interation)
	IF @@ROWCOUNT < @BatchSize
		SELECT @Stop = 1
	--Start the logging for this iteration
	INSERT INTO tempdb.dbo.MigrateBadges_Log (StartTime,[BatchSize])
	SELECT GETDATE(), @BatchSize
	SELECT @LogId = SCOPE_IDENTITY()
	--UPDATE
	BEGIN TRY
		SELECT @RwCnt = 0
		, @ErrorMsg = NULL
		, @ErrorNum = NULL

		UPDATE p
			SET p.BadgeTypeId = t.Id
		FROM dbo.Badges p
		JOIN #Batch b on p.Id = b.Id
		JOIN dbo.BadgeTypes t ON t.[Name] =p.[Name]
	
		SELECT @RwCnt += @@ROWCOUNT
	END TRY
	BEGIN CATCH
		SELECT @ErrorMsg = ERROR_MESSAGE()
		, @ErrorNum = ERROR_NUMBER()
	END CATCH
	--End the logging for this interation
	UPDATE tempdb.dbo.MigrateBadges_Log 
		SET EndTime = GETDATE()
		, [BatchSize] = @BatchSize
		, RecordCount = @RwCnt
		, ErrorMsg = @ErrorMsg
		, ErrorNum = @ErrorNum
	WHERE MigrateBadges_LogId = @LogId

	--Clear out Batch table 
	TRUNCATE TABLE #Batch
	--Reload configs for next batch
	SELECT @BatchSize = [BatchSize]
		, @DelayTime = [DelayTime]
		--ONLY UPDATE @Stop when it is 0
		, @Stop = CASE WHEN @Stop = 1 THEN 1 ELSE [Stop] END
	FROM tempdb.dbo.MigrateBadges_Config
	--Waitfor delay, if any
	WAITFOR DELAY @DelayTime	
END

