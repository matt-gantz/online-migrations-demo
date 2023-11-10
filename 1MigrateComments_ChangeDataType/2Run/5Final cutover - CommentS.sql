USE StackOverflow2010
GO

--Sanity check
IF EXISTS (
	SELECT 1
	FROM dbo.Comments 
	WHERE ScoreAsInt = -9999
	/*
	--Another validation option:
	WHERE ScoreAsInt = CAST(Score AS INT)
	*/
)
THROW 50000, 'data migration failed, check data', 1

IF EXISTS (
	SELECT 1
	FROM tempdb..MigrateComments_log
	WHERE ErrorMsg IS NOT NULL
)
THROW 50000, 'Log table has errors, check log table', 1

BEGIN TRY
BEGIN TRAN
	--Drop old column
	ALTER TABLE dbo.Comments
		DROP COLUMN Score
	
	--Rename new column
	exec sp_rename 'dbo.Comments.ScoreAsInt', 'Score', 'COLUMN'

	--Drop old default 
	ALTER TABLE dbo.Comments
		DROP CONSTRAINT DF_Comments_ScoreAsInt
	
	--Alter proc
	/*note: this will cause a couple of failures to executions in flight. */
	EXEC ('
	ALTER PROC dbo.InsertComments 
	@PostId INT
	AS

	INSERT dbo.Comments (CreationDate, PostId, [Text], Score)
	SELECT GETDATE()
	, @PostId
	, CONVERT(nvarchar(700), NEWID())
	, ABS(CHECKSUM(NEWID()) % 10) --NOW AN INTEGER
	')

COMMIT
END TRY
BEGIN CATCH
	IF XACT_STATE() != 0 ROLLBACK;
	THROW
END CATCH