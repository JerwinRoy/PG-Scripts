-- LIST ALL INDEXES
\di

-- GIVES DETAILS ABOUT A TABLE INDEXES
select * from pg_indexes where tablename='table_name';

SELECT CONCAT(n.nspname,'.', c.relname) AS table,
    i.relname AS index_name FROM pg_class c
     JOIN pg_index x ON c.oid = x.indrelid
     JOIN pg_class i ON i.oid = x.indexrelid LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE c.relkind = ANY (ARRAY['r', 't']) AND c.relname like 'table_name';

-- LIST INDEX WITH TABLE STRUCTURES
\d+ table_name

-- GET INDEX DEFINITION
\d index_name

--SIZE OF INDEX
SELECT pg_size_pretty(pg_relation_size('table_name'));

--INDEX SIZE WITH TABLE
SELECT    CONCAT(n.nspname,'.', c.relname) AS table,
          i.relname AS index_name, pg_size_pretty(pg_relation_size(x.indrelid)) AS table_size,
          pg_size_pretty(pg_relation_size(x.indexrelid)) AS index_size,
          pg_size_pretty(pg_total_relation_size(x.indrelid)) AS total_size FROM pg_class c 
JOIN      pg_index x ON c.oid = x.indrelid
JOIN      pg_class i ON i.oid = x.indexrelid
LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE     c.relkind = ANY (ARRAY['r', 't'])
AND       n.oid NOT IN (99, 11, 12375);

---UNIQUE INDEX CHECK
SELECT    i.relname AS index_name,
          indisunique is_unique
FROM      pg_class c
JOIN      pg_index x ON c.oid = x.indrelid
JOIN      pg_class i ON i.oid = x.indexrelid
LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE     c.relkind = ANY (ARRAY['r', 't'])
AND       c.relname LIKE 'pgbench_accounts';

--UNUSED INDEXES
SELECT s.relname AS table_name,
       indexrelname AS index_name,
       i.indisunique,
       idx_scan AS index_scans
FROM   pg_catalog.pg_stat_user_indexes s,
       pg_index i
WHERE  i.indexrelid = s.indexrelid;

---DUPLICATE INDEXES
SELECT   indrelid::regclass table_name,
         att.attname column_name,
         amname index_method
FROM     pg_index i,
         pg_class c,
         pg_opclass o,
         pg_am a,
         pg_attribute att
WHERE    o.oid = ALL (indclass) 
AND      att.attnum = ANY(i.indkey)
AND      a.oid = o.opcmethod
AND      att.attrelid = c.oid
AND      c.oid = i.indrelid
GROUP BY table_name, 
         att.attname,
         indclass,
         amname, indkey
HAVING count(*) > 1;

-- DUPLICATE INDEXES
SELECT pg_size_pretty(sum(pg_relation_size(idx))::bigint) as size,
       (array_agg(idx))[1] as idx1, (array_agg(idx))[2] as idx2,
       (array_agg(idx))[3] as idx3, (array_agg(idx))[4] as idx4
FROM (
    SELECT indexrelid::regclass as idx, (indrelid::text ||E'\n'|| indclass::text ||E'\n'|| indkey::text ||E'\n'||
                                         coalesce(indexprs::text,'')||E'\n' || coalesce(indpred::text,'')) as key
    FROM pg_index) sub
GROUP BY key HAVING count(*)>1
ORDER BY sum(pg_relation_size(idx)) DESC;



