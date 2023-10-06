IF (COL_LENGTH('dbo.Comments','ScoreAsInt')) IS NULL
ALTER TABLE dbo.Comments
	ADD ScoreAsInt INT NOT NULL
	CONSTRAINT DF_Comments_ScoreAsInt DEFAULT (-9999)


ALTER PROC dbo.InsertComments @PostId INT
AS

INSERT dbo.Comments (CreationDate, PostId, [Text], Score, ScoreAsInt)
DECLARE @Score INT = ABS(CHECKSUM(NEWID()) % 10
SELECT GETDATE()
, @PostId
, CONVERT(nvarchar(700), NEWID()) 
, CAST( @Score AS varchar(100)) --RANDOM INT BETWEEN 1-9, CAST AS VARCHAR
, @Score