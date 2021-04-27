-- DROP FUNCTION IF EXISTS weight CASCADE;
CREATE FUNCTION weight (resource jsonb) RETURNS real AS $$
BEGIN
  RETURN resource #>> '{valueQuantity,value}';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE INDEX observation_weight ON observation (weight(resource))
 WHERE resource @> '{"code":{"coding":[{"code":"29463-7","system":"http://loinc.org"}]}}';

SELECT CASE
       WHEN n IS NOT NULL THEN
            concat_ws(' ',
                (SELECT string_agg(q, ' ') FROM jsonb_array_elements_text(n -> 'prefix') q),
                (SELECT string_agg(q, ' ') FROM jsonb_array_elements_text(n -> 'given') q),
                n ->> 'family',
                (SELECT string_agg(q, ' ') FROM jsonb_array_elements_text(n -> 'suffix') q))
       ELSE 'anonymous'
       END,
       weight(o.resource) w
  FROM observation o
  JOIN patient p ON p.id = o.resource #>> '{subject,id}'
  LEFT JOIN LATERAL jsonb_path_query_first(p.resource, '$.name[*] ? (@.use == "official")') n ON true
 WHERE o.resource @> '{"code":{"coding":[{"code":"29463-7","system":"http://loinc.org"}]}}'
 ORDER BY 2 DESC
 LIMIT 1;

EXPLAIN (analyze, costs off, timing off)
SELECT CASE
       WHEN n IS NOT NULL THEN
            concat_ws(' ',
                (SELECT string_agg(q, ' ') FROM jsonb_array_elements_text(n -> 'prefix') q),
                (SELECT string_agg(q, ' ') FROM jsonb_array_elements_text(n -> 'given') q),
                n ->> 'family',
                (SELECT string_agg(q, ' ') FROM jsonb_array_elements_text(n -> 'suffix') q))
       ELSE 'anonymous'
       END,
       weight(o.resource) w
  FROM observation o
  JOIN patient p ON p.id = o.resource #>> '{subject,id}'
  LEFT JOIN LATERAL jsonb_path_query_first(p.resource, '$.name[*] ? (@.use == "official")') n ON true
 WHERE o.resource @> '{"code":{"coding":[{"code":"29463-7","system":"http://loinc.org"}]}}'
 ORDER BY 2 DESC
 LIMIT 1;

--  сам поисковый запрос, 
--  план и результат его выполнения. 
--  В конечном результате вывести имя и вес самого тяжелого пациента.