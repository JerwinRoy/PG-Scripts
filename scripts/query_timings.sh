#! /bin/bash
#ACTIVE QUERY BY TIMINGS 

PG_PATH=/usr/pgsql-13/bin
PG_HOST=localhost
PG_USER=jerwin
PG_DB=postgres
PG_PORT=5432
#query=select pid as PID,datname as DATABASE,usename as USER,client_addr as HOST,now() - query_start as DURATION,state as STATE,query as QUERY from pg_stat_activity where state='active' order by duration desc;
#out_file=/var/log/pg_query_timings.log

pqt=$($PG_PATH/psql -h $PG_HOST -U $PG_USER -d $PG_DB -p $PG_PORT --no-psqlrc -q -t -A -c "select pid as PID,datname as DATABASE,usename as USER,client_addr as HOST,now() - query_start as DURATION,state as STATE,query as QUERY from pg_stat_activity where state='active' order by duration desc")
echo "--------------------------------------"
echo "  POSTGRES QUERY BY TIMINGS           "
echo "--------------------------------------"
`printf "\n"`

echo $pqt
