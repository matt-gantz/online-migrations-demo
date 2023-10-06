/*
CLEANUP 

drop table tempdb.dbo.MigrateComments_Log
drop table tempdb.dbo.MigrateComments_Config


monitor

EXEC MonitorMigrateComments


configure

EXEC ConfigureMigrateComments @batchsize = 5000
*/


--START SQL QUERY STRESS FIRST
exec MigrateComments