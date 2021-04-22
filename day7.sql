drop table if exists test_patient;
create table if not exists test_patient (
    resource jsonb
);
insert into test_patient values ($$
{"resourceType": "Patient",
"telecom": [
{
    "use":"work",
    "value":"+7555-486-3253",
    "system":"phone"
},{
    "use":"work",
    "value":"call-me@baby",
    "system":"emal"
},{
    "use":"mobile",
    "value":"   +  7-981-123-12-01",
    "system":"phone"
}]
}$$);
-- select jsonb_pretty(resource) from test_patient;


SELECT resource || (SELECT jsonb_build_object('telecom', jsonb_agg(
       CASE
       WHEN t.value @?
       $$
           $ ? (
               @.use == "mobile" && 
               @.system == "phone" && 
               @.value like_regex "^[[:space:]]*[+][[:space:]]*7")
       $$
       THEN t.value || jsonb_build_object(
           'value',
           regexp_replace(
               t.value ->> 'value',
               '^[[:space:]]*[+][[:space:]]*7',
               '8'))
       ELSE t.value
       END)) FROM jsonb_array_elements(resource #> '{telecom}') t)
  FROM test_patient;