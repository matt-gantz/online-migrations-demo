CREATE OR ALTER PROC dbo.InsertBadges @UserId INT, @BadgeName NVARCHAR(40)
AS
INSERT INTO dbo.Badges ([Name], UserId, [Date])
SELECT @BadgeName
, @UserId
, GETDATE()
GO



