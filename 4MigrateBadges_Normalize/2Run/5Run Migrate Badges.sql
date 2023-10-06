/*
CLEANUP 

drop table tempdb.dbo.MigrateBadges_Log
drop table tempdb.dbo.MigrateBadges_Config


monitor

EXEC MonitorMigrateBadges

*/

exec MigrateBadges 

--took 1 min (10GB)