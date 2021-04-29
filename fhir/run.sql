
-- DROP INDEX encounter_period_idx;
-- DROP FUNCTION encounter_period(date,date);
-- DROP FUNCTION to_date(text);

CREATE FUNCTION to_date(x text) RETURNS date AS $$
BEGIN
  RETURN x;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION encounter_period (x date, y date) RETURNS daterange AS $$
BEGIN
  RETURN daterange(x,y,'[]');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE INDEX encounter_period_idx ON encounter USING gist (
     encounter_period(
         to_date(resource #>> '{period,start}'),
         to_date(resource #>> '{period,end}'))
);

-- SELECT jsonb_pretty(resource -> 'period'),
--        encounter_period(resource)
--   FROM encounter
--  WHERE encounter_period(resource #>> '{period,start}',resource #>> '{period,end}') @> '2020-01-01'::date
--  LIMIT 1;

SELECT count(*)
  FROM encounter
 WHERE encounter_period(
         to_date(resource #>> '{period,start}'),
         to_date(resource #>> '{period,end}')) && '[2020-01-01,2020-02-01)'
;

explain (analyze, costs off, timing off)
SELECT count(*)
  FROM encounter
 WHERE encounter_period(
         to_date(resource #>> '{period,start}'),
         to_date(resource #>> '{period,end}')) && '[2020-01-01,2020-02-01)'
;
