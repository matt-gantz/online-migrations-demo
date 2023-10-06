BEGIN TRY
BEGIN TRAN

	ALTER TABLE dbo.Comments
		DROP COLUMN Score
	
	exec sp_rename 'dbo.Comments.ScoreAsVarchar', 'Score', 'COLUMN'

	exec sp_rename 'dbo.DF_Comments_ScoreAsVarchar','DF_Comments_Score', 'OBJECT'

	ALTER TABLE dbo.Comments
		DROP CONSTRAINT DF_Comments_Score

COMMIT
END TRY
BEGIN CATCH
	IF XACT_STATE() != 0 ROLLBACK;
	THROW
END CATCH