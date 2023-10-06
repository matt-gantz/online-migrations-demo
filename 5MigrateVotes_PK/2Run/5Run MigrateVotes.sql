/*
CLEANUP 

drop table tempdb.dbo.MigrateVotes_Log
drop table tempdb.dbo.MigrateVotes_Config


monitor

EXEC MonitorMigrateVotes


configure

EXEC ConfigureMigrateVotes @batchsize = 5000
*/

exec MigrateVotes