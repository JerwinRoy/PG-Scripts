select count(*),client_addr as IP,state as STATE,usename as USER from pg_stat_activity group by state,usename,client_addr;

