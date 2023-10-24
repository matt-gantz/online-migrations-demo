EXEC MonitorMigrateComments

EXEC sp_whoisactive

/*
SELECT COUNT (1) AS RWCNT FROM dbo.Comments (nolock) WHERE ScoreAsInt = -9999

*/