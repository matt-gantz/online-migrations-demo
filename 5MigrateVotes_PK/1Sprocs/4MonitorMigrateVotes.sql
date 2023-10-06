CREATE OR ALTER PROC MonitorMigrateVotes
	@RecordsToReturn INT = 10
AS
SELECT TOP (@RecordsToReturn) 
DATEDIFF(SECOND
	,STARTTIME
	,CASE WHEN EndTime IS NULL THEN GETDATE() ELSE ENDTIME END
	) AS LoopTime
,
* 
from tempdb..MigrateVotes_log
order by MigrateVotes_logid desc


