/*
CLEANUP 

drop table tempdb.dbo.PurgePosts_Log
drop table tempdb.dbo.PurgePosts_Config


*/

exec PurgePosts_V2 
	@date = '20100101' 
, @InitialBatchSize = 50
, @InitialDelayTime = '00:00:02'