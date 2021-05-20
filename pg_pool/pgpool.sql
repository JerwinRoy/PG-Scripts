-- CHECK STATUS/START/STOP
systemctl status pgpool-II-11
systemctl restart pgpool-II-11
systemctl start pgpool-II-11
systemctl stop pgpool-II-11

-- GET INFO ABOUT EACH NODES
pcp_node_info -n 0 -U user -h localhost
pcp_node_info -n 1 -U user -h localhost

-- ATTACH A NODE
pcp_attach_node -n 0 -U user 
pcp_attach_node -n 1 -U user

-- DETACH A NODE
pcp_detach_node -n 0 -U user
pcp_detach_node -n 1 -U user

-- CHECK CONNECTIVITY FROM POSTGRES USING HOST
psql -d postgres -h hostname -U user

-- LOGIN TO PGPOOL
psql -U user -d postgres -h pgpool_host

-- CHECK NODES STATUS AFTER LOGGINH IN 
show pool_nodes;

---ERROR LOG
it will be there /var/log/pgpool/pgpool.log

---CREATE A PASSWORD ON PGPOOL
pg_md5 -m -f /etc/pgpool-II/pgpool.conf -u user -p

cat pool_passwd 
encrypted
