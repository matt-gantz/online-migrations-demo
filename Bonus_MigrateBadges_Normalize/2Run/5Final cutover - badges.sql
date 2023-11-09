--Sanity check
IF EXISTS (
	SELECT 1
	FROM dbo.Badges (NOLOCK)
	WHERE BatchTypeId = -1
)
THROW 50000, 'data migration failed, check data', 1

IF EXISTS (
	SELECT 1
	FROM tempdb..MigrateBadges_log
	WHERE ErrorMsg IS NOT NULL
)
THROW 50000, 'Log table has errors, check log table', 1


--set Name column to NULLable
ALTER TABLE dbo.Badges 
	ALTER COLUMN [Name] nvarchar(40) NULL
GO

--alter proc to ignore NULLable Name column
ALTER PROC dbo.InsertBadges @UserId INT, @BadgeName NVARCHAR(40)
AS
DECLARE @BadgeTypeId INT = (SELECT Id FROM dbo.BadgeTypes WHERE [Name] = @BadgeName)
IF @BadgeTypeId IS NULL
BEGIN
    INSERT INTO BadgeTypes ([Name])
    SELECT @BadgeName
	SELECT @BadgeTypeId = SCOPE_IDENTITY();
END

INSERT INTO dbo.Badges (UserId, [Date], BadgeTypeId)
SELECT 
 @UserId
, GETDATE()
, @BadgeTypeId

GO

--Drop Name column
ALTER TABLE dbo.Badges 
	DROP COLUMN [Name]
GO

--Remove dummy BadgeTypeId
DELETE FROM dbo.BadgeTypes
WHERE Id = -1

GO

--rebuild index to see space savings
ALTER INDEX ALL ON dbo.Badges REBUILD WITH (ONLINE=ON)

