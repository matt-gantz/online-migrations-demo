USE StackOverflow2013
GO

SELECT * FROM tempdb..PurgePosts_log WHERE ErrorMsg IS NOT NULL

SELECT *
  FROM [StackOverflow2013].[dbo].[Posts]
  where CreationDate < '20090101' -- 1min