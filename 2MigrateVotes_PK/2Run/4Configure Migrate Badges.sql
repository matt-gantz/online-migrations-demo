USE StackOverflow2010
GO

EXEC ConfigureMigrateVotes @batchsize = 50000

--example: too large a batch for this system
EXEC ConfigureMigrateVotes @batchsize = 400000

--example: something smaller might be better
EXEC ConfigureMigrateVotes @batchsize = 20000

