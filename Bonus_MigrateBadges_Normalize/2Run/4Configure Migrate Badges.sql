
--only need for big DB

EXEC dbo.ConfigureMigrateBadges @BatchSize = 5000


EXEC dbo.ConfigureMigrateBadges @BatchSize = 50000

EXEC dbo.ConfigureMigrateBadges @BatchSize = 200000