--set Name column to NULLable
ALTER TABLE dbo.Badges 
	ALTER COLUMN [Name] nvarchar(40) NULL

--alter proc to ignore NULLable Name column
ALTER PROC dbo.InsertBadges @UserId INT, @BadgeName NVARCHAR(40)
AS
DECLARE @BadgeTypeId INT = SELECT Id FROM dbo.BadgeTypes WHERE [Name] = @BadgeName
IF @BadgeTypeId IS NULL
    INSERT INTO BadgeTypes ([Name])
    SELECT @BadgeName
SELECT @BadgeTypeId = SCOPE_IDENTITY();

INSERT INTO dbo.Badges (UserId, [Date], BadgeTypeId)
SELECT 
 @UserId
, GETDATE()
, @BadgeTypeId

GO

--Drop Name column
ALTER TABLE dbo.Badges 
	DROP COLUMN [Name]
