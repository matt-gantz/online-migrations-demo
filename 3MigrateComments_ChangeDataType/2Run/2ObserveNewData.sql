USE StackOverflow2010
GO

SELECT TOP (1000) [Id]
      ,[CreationDate]
      ,[PostId]
      ,[Text]
      ,[UserId]
      ,[Score]
      ,[ScoreAsInt]
  FROM [StackOverflow2010].[dbo].[Comments]
ORDER BY 1 DESC