-- GET BLOCKING & BLOCKED QUERY
SELECT blocked_locks.pid         AS blocked_pid,
       blocked_activity.usename  AS blocked_user,
       now() - blocked_activity.query_start
                                 AS blocked_duration,
       blocking_locks.pid        AS blocking_pid,
       blocking_activity.usename AS blocking_user,
       now() - blocking_activity.query_start
                                 AS blocking_duration,
       blocked_activity.query    AS blocked_statement,
       blocking_activity.query   AS blocking_statement
FROM pg_catalog.pg_locks AS blocked_locks
JOIN pg_catalog.pg_stat_activity AS blocked_activity
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks AS blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
        AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
        AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
        AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
        AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
        AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
        AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
        AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
        AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
        AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
        AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity AS blocking_activity
    ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;

-- LIST ALL LCOKS FROM PG LOCKS
select relation::regclass, * from pg_locks where not granted;

-- COUNT OF LOCKS
select count(*) from pg_locks where not granted;

-- LOCK WAITING TIME
SELECT w.query                          AS waiting_query,                                                                                                                                                  w.pid                            AS waiting_pid,

       w.usename                        AS waiting_user,
       now() - w.query_start            AS waiting_duration,
       l.query                          AS locking_query,
       l.pid                            AS locking_pid,
       l.usename                        AS locking_user,
       t.schemaname || '.' || t.relname AS tablename,
       now() - l.query_start            AS locking_duration
FROM pg_stat_activity w
         JOIN pg_locks l1 ON w.pid = l1.pid AND NOT l1.granted
         JOIN pg_locks l2 ON l1.relation = l2.relation AND l2.granted
         JOIN pg_stat_activity l ON l2.pid = l.pid
         JOIN pg_stat_user_tables t ON l1.relation = t.relid order by locking_duration desc;

-- CLEAR LOCKS
SELECT pg_cancel_backend(pid) FROM pg_stat_activity WHERE  pid <> pg_backend_pid()
 and datname='DB_NAME' and usename='USER_NAME'
AND state_change < current_timestamp - INTERVAL '1' MINUTE ;

-- SHELL SCRIPT ON BASH TO CLEAR LOCKS
#!/bin/sh
exec 3>&1 4>&2
exec 1>log.out 2>&1
export PGPASSWORD='tK!2yG-d'
lockcount=$(psql -U postgres -d DBNAME -tA -c 'select count(*) from pg_locks;')
if [ "$lockcount" -gt "100" ];
then
 psql -U postgres -d DBNAME -c "SELECT pg_cancel_backend(pid) FROM pg_stat_activity WHERE  pid <> pg_backend_pid() and datname='DBNAME' and usename='USER' AND state_change < current_timestamp - INTERVAL '5' MINUTE ;"
else
 exit

-- CHECK A PARTICULAR PID 
select pid as PROCESS_ID, 
         usename as USER, 
         datname as DATABASE, 
         query,
         state
from pg_stat_activity where pid='1234';

-- KILL A QUERY
SELECT pg_cancel_backend(1234);
