EXEC MonitorMigrateVotes

EXEC sp_whoisactive


/*

select count (1) from dbo.VotesCopy (nolock)
select count (1) from dbo.Votes (nolock)
52,940,009
*/