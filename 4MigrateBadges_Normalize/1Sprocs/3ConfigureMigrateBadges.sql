CREATE OR ALTER PROC ConfigureMigrateBadges
	  @BatchSize INT = NULL
	, @Stop BIT = NULL
	, @DelayTime varchar(8) = NULL
AS
UPDATE tempdb.dbo.MigrateBadges_config 
	SET [BatchSize] = CASE WHEN @BatchSize IS NULL THEN [BatchSize] ELSE @BatchSize END
	, [Stop] = CASE WHEN @Stop IS NULL THEN [Stop] ELSE @Stop END
	, DelayTime = CASE WHEN @DelayTime IS NULL THEN DelayTime ELSE @DelayTime END

SELECT
	[BatchSize]
	,[Stop]
	,DelayTime
FROM tempdb.dbo.MigrateBadges_config
