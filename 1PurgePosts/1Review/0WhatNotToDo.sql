USE StackOverflow2013
GO
--Start SQL Stress test to see blocking


DELETE FROM dbo.Posts WHERE CreationDate < '20100101'