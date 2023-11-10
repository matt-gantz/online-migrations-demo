USE StackOverflow2010
GO

--New table
CREATE TABLE [dbo].[VotesCopy](
	[Id] int NOT NULL IDENTITY(1,1),
	[PostId] [int] NOT NULL,
	[UserId] [int] NULL,
	[BountyAmount] [int] NULL,
	[VoteTypeId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	--NOTE: Adding this column to allow for restartability
	[LegacyId] varchar(100) NOT NULL,
	CONSTRAINT [PK_VotesCopy__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
, INDEX IX_VotesCopy_LegacyId UNIQUE (LegacyId)
) ON [PRIMARY]
GO

--Alter proc to use double writes
ALTER PROC dbo.InsertVotes @PostId int, @VoteId varchar(100)
AS
--Note that this could be done without the transaction in the proc
-- This would require a final 'cleanup step' to fix any insert that failed between the two inserts
-- (data in one table but not the other)
BEGIN TRY
	BEGIN TRAN
	
	INSERT INTO dbo.Votes (Id,PostId, VoteTypeId, CreationDate)
	SELECT @VoteId, @PostId,  1, GETDATE()	

	INSERT INTO dbo.VotesCopy (LegacyId,PostId, VoteTypeId, CreationDate)
	SELECT @VoteId, @PostId, 1, GETDATE()
	
	COMMIT
END TRY
BEGIN CATCH
	IF XACT_STATE() != 0 ROLLBACK;
	THROW
END CATCH

GO

