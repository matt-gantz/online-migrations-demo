BEGIN TRY
BEGIN TRAN

	ALTER TABLE dbo.VotesCopy
		ALTER COLUMN LegacyId varchar(100) NULL
	
	EXEC sp_rename 'dbo.Votes', 'Votes_Migrated', 'OBJECT'
	EXEC sp_rename 'dbo.PK_Votes__Id', 'PK_Votes_Migrated__Id', 'OBJECT'

	EXEC sp_rename 'dbo.VotesCopy', 'Votes', 'OBJECT'
	EXEC sp_rename 'dbo.PK_VotesCopy__Id', 'PK_Votes__Id', 'OBJECT'

	EXEC ('
	CREATE OR ALTER PROC dbo.InsertVotes @PostId int, @VoteId varchar(100)
	AS
	INSERT INTO dbo.Votes (LegacyId,PostId,  VoteTypeId, CreationDate)
	SELECT @VoteId, @PostId,  1, GETDATE()
	')


COMMIT
END TRY
BEGIN CATCH
	IF XACT_STATE() != 0 ROLLBACK;
	THROW
END CATCH