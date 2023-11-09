CREATE OR ALTER PROC dbo.InsertComments @PostId INT
AS
--RANDOM INT BETWEEN 1-9, CAST AS VARCHAR
DECLARE @Score INT = (SELECT ABS(CHECKSUM(NEWID()) % 10))

INSERT dbo.Comments (
CreationDate
, PostId
, [Text]
, Score
)
SELECT GETDATE()
, @PostId
, CONVERT(nvarchar(700), NEWID()) 
, CAST( @Score AS varchar(100)) 