BEGIN TRY
BEGIN TRAN

	ALTER TABLE dbo.Comments
		DROP COLUMN Score
	
	exec sp_rename 'dbo.Comments.ScoreAsInt', 'Score', 'COLUMN'

	ALTER TABLE dbo.Comments
		DROP CONSTRAINT DF_Comments_ScoreAsInt
	
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