
-- DROP INDEX encounter_period_idx;
-- DROP FUNCTION encounter_period(timestamptz,timestamptz);
-- DROP FUNCTION encounter_period(text,text);
-- DROP FUNCTION to_date(text);

-- CREATE FUNCTION to_date (x text) RETURNS timestamptz AS $$
-- BEGIN
--   RETURN x;
-- END;
-- $$ LANGUAGE plpgsql IMMUTABLE;

-- CREATE FUNCTION encounter_period (x timestamptz, y timestamptz) RETURNS tstzrange AS $$
-- BEGIN
--   RETURN tstzrange(x,y);
-- END;
-- $$ LANGUAGE plpgsql IMMUTABLE;

-- CREATE INDEX encounter_period_idx ON encounter USING gist (
--      encounter_period(
--          to_date(resource #>> '{period,start}'),
--          to_date(resource #>> '{period,end}'))
-- );

-- VACUUM FULL encounter;
-- ANALYZE encounter;
-- ANALYZE encounter_period_idx;

-- SELECT count(*)
--   FROM encounter
--  WHERE encounter_period(
--          to_date(resource #>> '{period,start}'),
--          to_date(resource #>> '{period,end}')) && '[2020-01-01,2020-02-01)'
-- ;

explain (analyze, costs off, timing off, buffers on)
SELECT *
  FROM encounter
 WHERE encounter_period(
         to_date(resource #>> '{period,start}'),
         to_date(resource #>> '{period,end}')) && '[2020-01-01,2020-02-01)'
;


-- select current_setting('seq_page_cost'); set seq_page_cost = 10;
-- select current_setting('random_page_cost'); set random_page_cost = 0;
-- select current_setting('cpu_index_tuple_cost'); set cpu_index_tuple_cost = 0;
-- select current_setting('cpu_operator_cost'); set cpu_operator_cost = 0;
-- select current_setting('cpu_tuple_cost'); set cpu_tuple_cost = 0;

-- select 4577.08 / 10;
-- select 2.81 / 0.005;
-- select 1.68 / 0.0025;
-- select 5.62 / 0.01;

-- select 474 * 4 + 562 * 0.005 + 672 * 0.0025 + 562 * 0.01;

-- select 441 * 4 + 562 * 0.005 + 672 * 0.0025 + 562 * 0.01;

select 556 * 4 + 562 * 0.005 + (100+568+5) * 0.0025 + 562 * 0.01;

-- select 56153 * 441 / 56153;

-- select log(441)/log(100);

select log(56153);

-- select relpages,reltuples from pg_class where relname = 'encounter';
select relpages,reltuples from pg_class where relname = 'encounter_period_idx';

SET enable_seqscan = off;
SET enable_bitmapscan = off;

explain --(analyze, costs off, timing off)
SELECT *
  FROM encounter
 WHERE encounter_period(
         to_date(resource #>> '{period,start}'),
         to_date(resource #>> '{period,end}')) && '[2020-01-01,2020-02-01)'
;

set seq_page_cost = 1;
set random_page_cost = 4;
set cpu_index_tuple_cost = 0.005;
set cpu_operator_cost = 0.0025;
set cpu_tuple_cost = 0.01;

SET enable_bitmapscan = on;
SET enable_seqscan = on;



-- SET enable_indexscan = off;

-- explain --(analyze, costs off, timing off)
-- SELECT *
--   FROM encounter
--  WHERE encounter_period(
--          to_date(resource #>> '{period,start}'),
--          to_date(resource #>> '{period,end}')) && '[2020-01-01,2020-02-01)'
-- ;

-- select relpages from pg_class where relname = 'encounter_period_idx';
