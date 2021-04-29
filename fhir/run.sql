
-- DROP INDEX encounter_period_idx;
-- DROP FUNCTION encounter_period(timestamptz,timestamptz);
-- DROP FUNCTION encounter_period(text,text);
-- DROP FUNCTION to_date(text);

CREATE FUNCTION to_date (x text) RETURNS timestamptz AS $$
BEGIN
  RETURN x;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE FUNCTION encounter_period (x timestamptz, y timestamptz) RETURNS tstzrange AS $$
BEGIN
  RETURN tstzrange(x,y);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE INDEX encounter_period_idx ON encounter USING gist (
     encounter_period(
         to_date(resource #>> '{period,start}'),
         to_date(resource #>> '{period,end}'))
);

SELECT count(*)
  FROM encounter
 WHERE encounter_period(
         to_date(resource #>> '{period,start}'),
         to_date(resource #>> '{period,end}')) && '[2020-01-01,2020-02-01)'
;

explain (analyze, costs off, timing off)
SELECT *
  FROM encounter
 WHERE encounter_period(
         to_date(resource #>> '{period,start}'),
         to_date(resource #>> '{period,end}')) && '[2020-01-01,2020-02-01)'
;
