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
