/*
CLEANUP 

drop table tempdb.dbo.PurgePosts_Log
drop table tempdb.dbo.PurgePosts_Config


monitor

EXEC MonitorPurgePosts

*/
exec PurgePosts @date = '20090601' , @InitialDelayTime = '00:00:00'




