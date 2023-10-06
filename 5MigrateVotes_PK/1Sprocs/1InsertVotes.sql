CREATE OR ALTER PROC dbo.InsertVotes @PostId int, @VoteId varchar(100)
AS
INSERT INTO dbo.Votes (Id,PostId,  VoteTypeId, CreationDate)
SELECT @VoteId, @PostId,  1, GETDATE()
GO


