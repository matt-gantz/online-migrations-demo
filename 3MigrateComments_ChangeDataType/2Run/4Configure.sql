EXEC ConfigureMigrateComments @BatchSize = 5000, @DelayTime = '00:00:00'


EXEC ConfigureMigrateComments @BatchSize = 10000, @DelayTime = '00:00:00'

EXEC ConfigureMigrateComments @BatchSize = 20000, @DelayTime = '00:00:00'

EXEC ConfigureMigrateComments @BatchSize = 50000, @DelayTime = '00:00:00'

EXEC ConfigureMigrateComments @BatchSize = 100000, @DelayTime = '00:00:00'
--start to see LCK_M_IX

EXEC ConfigureMigrateComments @BatchSize = 200000, @DelayTime = '00:00:00'

EXEC ConfigureMigrateComments @BatchSize = 500000, @DelayTime = '00:00:00'