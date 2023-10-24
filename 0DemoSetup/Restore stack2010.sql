--BACKUP DATABASE [StackOverflow2010] TO DISK = N'C:\SqlData\MSSQL13.MSSQLSERVER\MSSQL\Backup\StackOverflow2010_DemoVersion.bak' WITH  NOUNLOAD,  STATS = 5 , COMPRESSION
--BACKUP DATABASE [StackOverflow2013] TO DISK = N'C:\SqlData\MSSQL13.MSSQLSERVER\MSSQL\Backup\StackOverflow2013_DemoVersion.bak' WITH  NOUNLOAD,  STATS = 5 , COMPRESSION
--BACKUP DATABASE [DemoIds2010] TO DISK = N'C:\SqlData\MSSQL13.MSSQLSERVER\MSSQL\Backup\DemoIds2010_DemoVersion.bak' WITH  NOUNLOAD,  STATS = 5 , COMPRESSION
--BACKUP DATABASE [DemoIds2013] TO DISK = N'C:\SqlData\MSSQL13.MSSQLSERVER\MSSQL\Backup\DemoIds2013_DemoVersion.bak' WITH  NOUNLOAD,  STATS = 5 , COMPRESSION


USE [master]
ALTER DATABASE StackOverFlow2010 set offline with rollback immediate
RESTORE DATABASE [StackOverflow2010] FROM  DISK = N'C:\SqlData\MSSQL13.MSSQLSERVER\MSSQL\Backup\StackOverflow2010_DemoVersion.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO


USE [master]
ALTER DATABASE StackOverFlow2013 set offline with rollback immediate
RESTORE DATABASE [StackOverflow2013] FROM  DISK = N'C:\SqlData\MSSQL13.MSSQLSERVER\MSSQL\Backup\StackOverflow2013_DemoVersion.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO

