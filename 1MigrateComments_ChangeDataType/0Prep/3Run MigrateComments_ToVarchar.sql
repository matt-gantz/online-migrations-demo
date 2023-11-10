/*
CLEANUP 

drop table tempdb.dbo.MigrateComments_Log
drop table tempdb.dbo.MigrateComments_Config


monitor

EXEC MonitorMigrateComments


configure

EXEC ConfigureMigrateComments @batchsize = 5000, @delaytime = '00:00:00'
*/

exec MigrateComments_ToVarchar