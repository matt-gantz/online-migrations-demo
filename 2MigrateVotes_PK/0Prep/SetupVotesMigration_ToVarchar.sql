BEGIN TRY
BEGIN TRAN

	CREATE TABLE [dbo].[VotesCopy](
		[Id] varchar(100) NOT NULL,
		[PostId] [int] NOT NULL,
		[UserId] [int] NULL,
		[BountyAmount] [int] NULL,
		[VoteTypeId] [int] NOT NULL,
		[CreationDate] [datetime] NOT NULL,
	 CONSTRAINT [PK_VotesCopy__Id] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	INSERT INTO VotesCopy(Id, PostId, UserId, BountyAmount, VoteTypeId, CreationDate)
	SELECT Id, PostId, UserId, BountyAmount, VoteTypeId, CreationDate
	FROM dbo.Votes
	DROP TABLE dbo.Votes
	EXEC sp_rename 'dbo.VotesCopy', 'Votes', 'OBJECT'
	EXEC sp_rename 'dbo.PK_VotesCopy__Id', 'PK_Votes__Id', 'OBJECT'

COMMIT
END TRY
BEGIN CATCH
	IF XACT_STATE() != 0 ROLLBACK;
	THROW
END CATCH