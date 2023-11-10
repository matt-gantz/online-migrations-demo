USE StackOverflow2013
GO

EXEC ConfigurePurgePosts @BatchSize = 5000, @DelayTime = '00:00:00'
EXEC ConfigurePurgePosts @BatchSize = 10000, @DelayTime = '00:00:00'
