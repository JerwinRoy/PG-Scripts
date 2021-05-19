select * from (select count(*)connections from pg_stat_activity) as a,(select setting as max_connections from pg_settings where name='max_connections') as b;
