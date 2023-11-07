CREATE OR ALTER PROC MonitorMigrateBadges
	@RecordsToReturn INT = 10
AS
SELECT TOP (@RecordsToReturn) 
DATEDIFF(SECOND
	,STARTTIME
	,CASE WHEN EndTime IS NULL THEN GETDATE() ELSE ENDTIME END
	) AS LoopTime
,
* 
from tempdb..MigrateBadges_log
order by MigrateBadges_logid desc


