--Create new lookup table
CREATE TABLE dbo.BadgeTypes (
	Id INT NOT NULL IDENTITY(1,1)
	, Name nvarchar(40) NOT NULL 
	, CONSTRAINT PK_BadgeTypes PRIMARY KEY CLUSTERED (Id) 
	, INDEX UQ_BadgeTypes_Name UNIQUE ([Name]) WITH (IGNORE_DUP_KEY = ON)
	)

--insert our dummy value
SET IDENTITY_INSERT dbo.BadgeTypes  ON
INSERT dbo.BadgeTypes (Id,Name)
VALUES (-1, 'MigrationInProgress')
SET IDENTITY_INSERT dbo.BadgeTypes OFF

--insert our real values
INSERT dbo.BadgeTypes (Name)
SELECT DISTINCT [Name] FROM dbo.Badges
GO

--Add new column, DF, FK, Index to support FK
ALTER TABLE dbo.Badges 
	ADD BadgeTypeId INT NOT NULL
	CONSTRAINT DF_BadgeTypeId DEFAULT (-1)
	CONSTRAINT FK_Badges_BadgeTypeId FOREIGN KEY REFERENCES dbo.BadgeTypes (Id)

CREATE INDEX IX_Badges_BadgeTypeId ON dbo.Badges (BadgeTypeId) WITH (ONLINE=ON)
GO

--alter sproc to write to both columns
ALTER PROC dbo.InsertBadges @UserId INT, @BadgeName NVARCHAR(40)
AS
DECLARE @BadgeTypeId INT = (SELECT Id FROM dbo.BadgeTypes WHERE [Name] = @BadgeName)
IF @BadgeTypeId IS NULL
BEGIN
    INSERT INTO BadgeTypes ([Name])
    SELECT @BadgeName
	SELECT @BadgeTypeId = SCOPE_IDENTITY();
END

INSERT INTO dbo.Badges ([Name], UserId, [Date], BadgeTypeId)
SELECT @BadgeName
, @UserId
, GETDATE()
, @BadgeTypeId

GO
