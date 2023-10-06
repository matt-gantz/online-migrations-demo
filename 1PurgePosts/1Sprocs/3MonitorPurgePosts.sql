CREATE OR ALTER PROC MonitorPurgePosts
	@RecordsToReturn INT = 10
AS
SELECT TOP (@RecordsToReturn) 
DATEDIFF(SECOND
	,STARTTIME
	,CASE WHEN EndTime IS NULL THEN GETDATE() ELSE ENDTIME END
	) AS LoopTime
,
* 
from tempdb..PurgePosts_log
order by purgeposts_logid desc


