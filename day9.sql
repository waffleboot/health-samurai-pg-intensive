
CREATE FUNCTION encounter_period (resource jsonb) RETURNS daterange AS $$
DECLARE
  s date := (resource #>> '{period,start}');
  e date := (resource #>> '{period,end}');
BEGIN
  RETURN daterange(
      (date_trunc('month', s))::date,
      (date_trunc('month', e))::date,
      '[]');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE INDEX encounter_period_idx ON encounter USING gist (encounter_period(resource));

SELECT count(*)
  FROM encounter 
 WHERE encounter_period(resource) @> '2020-01-01'::date;

SELECT jsonb_pretty(resource -> 'period'),
       encounter_period(resource)
  FROM encounter 
 WHERE encounter_period(resource) @> '2020-01-01'::date
 LIMIT 1;

explain (analyze, costs off, timing off)
SELECT jsonb_pretty(resource -> 'period'),
       encounter_period(resource)
  FROM encounter 
 WHERE encounter_period(resource) @> '2020-01-01'::date;
