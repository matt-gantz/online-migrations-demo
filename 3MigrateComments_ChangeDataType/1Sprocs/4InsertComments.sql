CREATE OR ALTER PROC dbo.InsertComments @PostId INT
AS

INSERT dbo.Comments (CreationDate, PostId, [Text], Score)
SELECT GETDATE()
, @PostId
, CONVERT(nvarchar(700), NEWID()) 
, CAST( ABS(CHECKSUM(NEWID()) % 10) AS varchar(100)) --RANDOM INT BETWEEN 1-9, CAST AS VARCHAR
