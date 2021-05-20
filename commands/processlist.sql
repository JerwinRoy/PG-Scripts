-- GET UPTIME
SELECT (now() - pg_postmaster_start_time()) as Uptime;

-- LIST ALL PROCESSESS
select pid as PROCESS_ID, 
         usename as USER, 
         datname as DATABASE, 
         client_addr as HOST, 
         application_name as APP_NAME,
         backend_start as STARTED_AT,
         state as STATE
from pg_stat_activity;

-- GET ALL CURRENT PROCESS COUNT 
select count(*) from pg_stat_activity;

-- ACTIVE QUERY BY TIMINGS 
select pid as PID,datname as DATABASE,usename as USER,client_addr as HOST,
now() - query_start as DURATION,state as STATE,query as QUERY 
from pg_stat_activity 
where state='active' order by duration desc;

-- GET CURRENT CONNECTIONS
select * from (select count(*)connections from pg_stat_activity) 
as a,(select setting as max_connections from pg_settings 
where name='max_connections') as b;

-- GET CURRENT CONNECTION COUNT PER USER

select count(*),client_addr as HOST,state as STATE,usename as USER 
from pg_stat_activity group by state,usename,client_addr;

-- CHECK A PARTICULAR PID 
select pid as PROCESS_ID, 
         usename as USER, 
         datname as DATABASE, 
         query,
         state
from pg_stat_activity where pid='1234';

-- KILL A QUERY
SELECT pg_cancel_backend(PID);

-- GET DISTINCT IP/HOST LIST 
select DISTINCT client_addr as HOST from pg_stat_activity ;

-- SLOW QUERY
SELECT pid, AGE(clock_timestamp(), query_start) as DURATION, usename as USER, query 
FROM pg_stat_activity 
WHERE query != '<IDLE>' AND query NOT ILIKE '%pg_stat_activity%' 
ORDER BY query_start desc;



