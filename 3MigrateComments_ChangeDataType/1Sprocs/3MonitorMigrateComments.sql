CREATE OR ALTER PROC MonitorMigrateComments
	@RecordsToReturn INT = 10
AS
SELECT TOP (@RecordsToReturn) 
DATEDIFF(SECOND
	,STARTTIME
	,CASE WHEN EndTime IS NULL THEN GETDATE() ELSE ENDTIME END
	) AS LoopTime
,
* 
from tempdb..MigrateComments_log
order by MigrateComments_logid desc


