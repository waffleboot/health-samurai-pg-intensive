-- какой смысл в owner?

-- сначала все индексы, агрегат по каждой таблице, это idx
-- затем все что похоже на таблицу из pg_class + left join idx
WITH idx AS (
SELECT idx.indrelid table_oid,
       jsonb_build_object(
           'index', jsonb_object_agg(
               i.relname, 
               jsonb_build_object(
                   'size', pg_size_pretty(pg_relation_size(i.oid)),
                   'type', am.amname)),
           'index_size', pg_size_pretty(pg_indexes_size(idx.indrelid))) idx_jsonb
  FROM pg_index idx
  JOIN pg_class i ON i.oid = idx.indexrelid
  JOIN pg_am am ON am.oid = i.relam
 GROUP BY
       idx.indrelid
),
t AS (
SELECT t.relnamespace ns_oid,
       jsonb_object_agg(
           relname,
           jsonb_build_object(
               'rows',reltuples,
               'table_size', pg_size_pretty(pg_total_relation_size(t.oid)))
             || coalesce(idx_jsonb,'{"index":null,"index_size":"0 bytes"}')) t_jsonb
  FROM pg_class t
  LEFT JOIN idx ON idx.table_oid = t.oid
 WHERE relkind IN ('r','t','m','f','p','v')
 GROUP BY
       t.relnamespace
)
SELECT jsonb_pretty(jsonb_object_agg(ns.nspname,t_jsonb))
  FROM t 
  JOIN pg_namespace ns ON ns.oid = t.ns_oid;
