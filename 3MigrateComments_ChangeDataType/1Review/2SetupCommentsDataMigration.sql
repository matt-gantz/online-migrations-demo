USE StackOverflow2010
GO

--Add a new column - NOT NULLable with scalar default
IF (COL_LENGTH('dbo.Comments','ScoreAsInt')) IS NULL
ALTER TABLE dbo.Comments
	ADD ScoreAsInt INT NOT NULL
	CONSTRAINT DF_Comments_ScoreAsInt DEFAULT (-9999)

GO

--Modify procedure to perform double writes (to columns)
ALTER PROC dbo.InsertComments @PostId INT
AS
DECLARE @Score INT = (SELECT ABS(CHECKSUM(NEWID()) % 10))

INSERT dbo.Comments (CreationDate, PostId, [Text], Score, ScoreAsInt)
SELECT GETDATE()
, @PostId
, CONVERT(nvarchar(700), NEWID()) 
, CAST( @Score AS varchar(100)) --RANDOM INT BETWEEN 1-9, CAST AS VARCHAR
, @Score