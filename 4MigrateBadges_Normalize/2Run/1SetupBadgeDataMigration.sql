CREATE TABLE dbo.BadgeTypes (
	Id INT NOT NULL IDENTITY(1,1)
	, Name nvarchar(40) NOT NULL 
	, CONSTRAINT PK_BadgeTypes PRIMARY KEY CLUSTERED (Id) 
	, INDEX UQ_BadgeTypes_Name UNIQUE ([Name]) WITH (IGNORE_DUP_KEY = ON)
	)
		
SET IDENTITY_INSERT dbo.BadgeTypes  ON
INSERT dbo.BadgeTypes (Id,Name)
VALUES (-1, 'MigrationInProgress')
SET IDENTITY_INSERT dbo.BadgeTypes OFF

ALTER TABLE dbo.Badges 
	ADD BadgeTypeId INT NOT NULL
	CONSTRAINT DF_BadgeTypeId DEFAULT (-1)
	CONSTRAINT FK_Badges_BadgeTypeId FOREIGN KEY REFERENCES dbo.BadgeTypes (Id)

INSERT dbo.BadgeTypes (Name)
SELECT DISTINCT [Name] FROM dbo.Badges
GO

ALTER PROC dbo.InsertBadges @UserId INT, @BadgeName NVARCHAR(40)
AS
DECLARE @BadgeTypeId INT = SELECT Id FROM dbo.BadgeTypes WHERE [Name] = @BadgeName
IF @BadgeTypeId IS NULL
    INSERT INTO BadgeTypes ([Name])
    SELECT @BadgeName
SELECT @BadgeTypeId = SCOPE_IDENTITY();

INSERT INTO dbo.Badges ([Name], UserId, [Date], BadgeTypeId)
SELECT @BadgeName
, @UserId
, GETDATE()
, @BadgeTypeId

GO