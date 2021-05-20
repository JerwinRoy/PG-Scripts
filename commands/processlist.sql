-- CHECK PROCESSLIST 
select pid as process_id, 
         usename as username, 
         datname as database_name, 
         client_addr as client_address, 
         application_name,
         backend_start,
         state,
         state_change
from pg_stat_activity;

-- GET ALL CURRENT PROCESS COUNT 
select count(*) from pg_stat_activity;

--
