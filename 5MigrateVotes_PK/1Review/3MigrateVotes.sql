CREATE OR ALTER PROC dbo.MigrateVotes
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

IF (OBJECT_ID ('tempdb.dbo.MigrateVotes_Log') IS NULL)
	CREATE TABLE tempdb.dbo.MigrateVotes_Log (
		MigrateVotes_LogId INT IDENTITY NOT NULL PRIMARY KEY CLUSTERED
		, StartTime DATETIME2(7) NOT NULL
		, StartDMLTime DATETIME2(7) NULL
		, EndTime DATETIME2(7) NULL
		, RecordCount INT NULL
		, [BatchSize] INT NOT NULL
		, ErrorMsg NVARCHAR(4000) NULL
		, ErrorNum INT NULL
		);

IF (OBJECT_ID ('tempdb.dbo.MigrateVotes_Config') IS NULL)
	CREATE TABLE tempdb.dbo.MigrateVotes_Config (
		MigrateVotes_ConfigId INT NOT NULL DEFAULT (1) PRIMARY KEY CLUSTERED 
		, DelayTime varchar(8)
		, [BatchSize] INT NOT NULL
		, [Stop] bit not null default (0)
		, CONSTRAINT CH_MigrateVotes_ConfigId CHECK (MigrateVotes_ConfigId =1)
		);

IF ((SELECT COUNT(1) FROM tempdb.dbo.MigrateVotes_Config WHERE MigrateVotes_ConfigId = 1)=0)
	INSERT INTO tempdb.dbo.MigrateVotes_Config (DelayTime,BatchSize)
	VALUES (@InitialDelayTime, @InitialBatchSize)
ELSE
	UPDATE tempdb.dbo.MigrateVotes_Config
		SET [BatchSize] = @InitialBatchSize
		, DelayTime = @InitialDelayTime
		, [Stop] = 0

IF (OBJECT_ID ('#ToProcess') IS NULL)
	CREATE TABLE #ToProcess (Id VARCHAR(100) NOT NULL PRIMARY KEY CLUSTERED)
IF (OBJECT_ID ('#Batch') IS NULL)
	CREATE TABLE #Batch (Id VARCHAR(100) NOT NULL PRIMARY KEY CLUSTERED)

-----------------Gather Ids------------------------------------	
--To allow this to be restartable, we can filter out already migrated Ids (NOTE: this might need some polish on larger tables)
INSERT INTO #ToProcess (Id)
SELECT Id 
FROM dbo.Votes v
WHERE NOT EXISTS (SELECT 1 FROM dbo.VotesCopy vc WHERE vc.LegacyId = v.Id) 

-----------------Main Loop------------------------------------
WHILE (@Stop = 0)
BEGIN
	--Start the logging for this iteration
	INSERT INTO tempdb.dbo.MigrateVotes_Log (StartTime,[BatchSize])
	SELECT GETDATE(), @BatchSize
	SELECT @LogId = SCOPE_IDENTITY()

	--Load up our batch table while deleting from the main set
	DELETE TOP (@BatchSize) FROM #ToProcess 
	OUTPUT DELETED.Id INTO #Batch (Id)

	--Once the rowcount is less than the batchsize, we can stop (after this loop interation)
	IF @@ROWCOUNT < @BatchSize
		SELECT @Stop = 1
	
	--update the log table
	UPDATE tempdb.dbo.MigrateVotes_Log 
		SET StartDMLTime = GETDATE()
	WHERE MigrateVotes_LogId = @LogId

	--UPDATE
	BEGIN TRY
		SELECT @RwCnt = 0
		, @ErrorMsg = NULL
		, @ErrorNum = NULL

		INSERT dbo.VotesCopy (PostId, UserId, BountyAmount, VoteTypeId, CreationDate, LegacyId)
		SELECT  v.PostId, v.UserId, v.BountyAmount, v.VoteTypeId, v.CreationDate, v.Id
		FROM dbo.Votes v
		JOIN #Batch b ON v.Id = b.Id

		SELECT @RwCnt += @@ROWCOUNT
	END TRY
	BEGIN CATCH
		SELECT @ErrorMsg = ERROR_MESSAGE()
		, @ErrorNum = ERROR_NUMBER()
	END CATCH
	--End the logging for this iteration
	UPDATE tempdb.dbo.MigrateVotes_Log 
		SET EndTime = GETDATE()
		, [BatchSize] = @BatchSize
		, RecordCount = @RwCnt
		, ErrorMsg = @ErrorMsg
		, ErrorNum = @ErrorNum
	WHERE MigrateVotes_LogId = @LogId

	--Clear out Batch table 
	TRUNCATE TABLE #Batch
	--Reload configs for next batch
	SELECT @BatchSize = [BatchSize]
		, @DelayTime = [DelayTime]
		--ONLY UPDATE @Stop when it is 0
		, @Stop = CASE WHEN @Stop = 1 THEN 1 ELSE [Stop] END
	FROM tempdb.dbo.MigrateVotes_Config
	--Waitfor delay, if any
	WAITFOR DELAY @DelayTime	
END

