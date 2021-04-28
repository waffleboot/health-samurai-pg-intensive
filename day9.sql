
CREATE FUNCTION encounter_period (resource jsonb) RETURNS daterange AS $$
BEGIN
  RETURN daterange(
      (resource #>> '{period,start}')::date,
      (resource #>> '{period,end}')::date,
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
 WHERE encounter_period(resource) @> '2020-01-01'::date;

explain (analyze, costs off, timing off)
SELECT jsonb_pretty(resource -> 'period'),
       encounter_period(resource)
  FROM encounter 
 WHERE encounter_period(resource) @> '2020-01-01'::date;
