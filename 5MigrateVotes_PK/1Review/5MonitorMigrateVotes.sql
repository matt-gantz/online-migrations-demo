CREATE OR ALTER PROC MonitorMigrateVotes
	@RecordsToReturn INT = 10
AS
with cte as (
select DATEDIFF(MILLISECOND
	,StartTime
	,CASE WHEN EndTime IS NULL THEN GETDATE() ELSE EndTime END
	) / 1000.0 AS LoopTime
,DATEDIFF(MILLISECOND
	,StartDMLTime
	,CASE WHEN EndTime IS NULL THEN GETDATE() ELSE EndTime END
	) / 1000.0 AS DMLTime
,*
from tempdb..MigrateVotes_log

)

SELECT TOP (@RecordsToReturn) 
CAST(LoopTime AS numeric(18,1)) AS LoopTime
,CAST(DMLTime AS numeric(18,1)) AS DMLTime
,CASE WHEN LoopTime > 0 THEN 	
	CAST( RecordCount / LoopTime as int) 
	ELSE NULL END AS RecordsPerSecond
,StartTime
,StartDMLTime
,EndTime
,RecordCount
,[BatchSize]
,ErrorMsg
,ErrorNum
from cte
order by MigrateVotes_logid desc


