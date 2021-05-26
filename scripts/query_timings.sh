#! /bin/bash
#ACTIVE QUERY BY TIMINGS 

pg_dir=/usr/pgsql-13/bin
host=localhost
user=jerwin
database=postgres
port=5432
#query=select pid as PID,datname as DATABASE,usename as USER,client_addr as HOST,now() - query_start as DURATION,state as STATE,query as QUERY from pg_stat_activity where state='active' order by duration desc;
#out_file=/var/log/pg_query_timings.log

pqt=$($pg_dir/psql -h $host -U $user -d $database -p $port --no-psqlrc -q -t -A -c "select pid as PID,datname as DATABASE,usename as USER,client_addr as HOST,now() - query_start as DURATION,state as STATE,query as QUERY from pg_stat_activity where state='active' order by duration desc")
echo "--------------------------------------"
echo "      POSTGRES QUERY TIMINGS          "
echo "--------------------------------------"
`printf "\n"`

echo $pqt
