USE StackOverflow2010
GO

--Sanity check
/*
--Only need this check if you have DELETES also running
IF EXISTS (
	SELECT 1
	FROM dbo.VotesCopy vc
	WHERE vc.LegacyId NOT IN (
		SELECT v.Id FROM dbo.Votes v 
		)
	)
THROW 50000, 'data migration failed, check data', 1
*/
IF EXISTS (-- 2mins to run
	SELECT 1
	FROM dbo.Votes v 
	WHERE v.Id NOT IN (
		SELECT vc.LegacyId FROM dbo.VotesCopy vc 
		)
	)
THROW 50000, 'data migration failed, check data', 1

IF EXISTS (
	SELECT 1
	FROM tempdb..MigrateVotes_log
	WHERE ErrorMsg IS NOT NULL
	)
THROW 50000, 'Log table has errors, check log table', 1


BEGIN TRY
BEGIN TRAN
	/* 
	--Instead of rename, option to drop table (e.g. if space is limited)
	--Make sure you have a good backup if you do this!
		DROP TABLE dbo.Votes	
	*/
	--Rename old table to allow new table to use the name Votes
	EXEC sp_rename 'dbo.Votes', 'Votes_Migrated', 'OBJECT'
	EXEC sp_rename 'dbo.PK_Votes__Id', 'PK_Votes_Migrated__Id', 'OBJECT'

	--Rename new table to 'Votes'
	EXEC sp_rename 'dbo.VotesCopy', 'Votes', 'OBJECT'
	EXEC sp_rename 'dbo.PK_VotesCopy__Id', 'PK_Votes__Id', 'OBJECT'

	--Alter proc to remove double writes
	EXEC ('
	CREATE OR ALTER PROC dbo.InsertVotes @PostId int, @VoteId varchar(100)
	AS
	INSERT INTO dbo.Votes (LegacyId ,PostId, VoteTypeId, CreationDate)
	SELECT @VoteId, @PostId, 1, GETDATE()
	')


COMMIT
END TRY
BEGIN CATCH
	IF XACT_STATE() != 0 ROLLBACK;
	THROW
END CATCH