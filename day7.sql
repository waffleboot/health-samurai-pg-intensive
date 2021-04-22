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
    "value":"+7-981-123-12-01",
    "system":"phone"
}]
}$$);
-- select jsonb_pretty(resource) from test_patient;

-- t3 := resource | json [ pth ] where pth := { "pth" : ["telecom",2,"value"] , "value" : "+7" }
WITH RECURSIVE t3 AS (

    SELECT tp.resource,
           jap.pths
      FROM test_patient tp,
   lateral /*jap*/ (

        WITH RECURSIVE keys AS
        (
            SELECT '[]'::jsonb pth,
                   tp.resource,
                   null::bool telecom,
                   null::bool mobile,
                   null::bool upd
             UNION ALL
            SELECT kv.*
              FROM keys,
           lateral /*kv*/ (
                    SELECT keys.pth||to_jsonb(t.key),
                           t.value,
                           t.key = 'telecom',
                           null,
                           keys.mobile AND t.key = 'value' AND starts_with(t.value #>> '{}', '+7') upd
                      FROM jsonb_each(resource) t
                     WHERE jsonb_typeof(resource) = 'object'
                     UNION ALL 
                    SELECT keys.pth||to_jsonb(t.pos-1),
                           t.element,
                           null,
                           keys.telecom AND t.element @> '{"use":"mobile","system":"phone"}' mobile,
                           null
                      FROM jsonb_array_elements(resource) WITH ordinality t(element,pos)
                     WHERE jsonb_typeof(resource) = 'array'
            ) kv
        )
        SELECT jsonb_agg(jsonb_build_object('pth',pth,'value',resource)) pths
          FROM keys
         WHERE upd

      ) jap
    
    union all

    select jsonb_set(t3.resource, (select array_agg(t) from jsonb_array_elements_text(t3.pths -> 0 -> 'pth') t), 
             to_jsonb (overlay  ( (t3.pths -> 0 ->> 'value')    placing '8'  from 1 for  2      ))
           ),
           t3.pths - 0
      from t3
     where t3.pths != '[]'
)
select resource
  from t3
 where t3.pths = '[]';
-- select *
--   from t3;




/*WITH RECURSIVE keys AS
(
    SELECT '[]'::jsonb pth,
           resource,
           null::bool telecom,
           null::bool mobile,
           null::bool upd
      FROM test_patient
     UNION ALL
    SELECT nxt.*
      FROM keys,
      lateral (
            SELECT keys.pth||to_jsonb(t.key),
                   t.value,
                   t.key = 'telecom',
                   keys.mobile,
                --    keys.mobile AND t.key = 'value'
                   keys.mobile AND t.key = 'value' AND starts_with(t.value #>> '{}', '+7')
              FROM jsonb_each(resource) t
             WHERE jsonb_typeof(resource) = 'object'
             UNION ALL 
            SELECT keys.pth||to_jsonb(t.pos-1),
                   t.value,
                   keys.telecom,
                --    keys.telecom,
                   keys.telecom AND t.value @> '{"use":"mobile","system":"phone"}',
                   null
              FROM jsonb_array_elements(resource) with ordinality t(value,pos)
             WHERE jsonb_typeof(resource) = 'array'
     ) nxt
)
select jsonb_agg(pth) pth
    --  , resource
  from keys
 where upd;*/