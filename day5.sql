

-- drop table if exists test;
-- create table if not exists test (
--     first_name text,
--     last_name  text,
--     status     bool,
--     age        int,
--     head       json,
--     body       jsonb
-- );
-- insert into test (first_name,last_name,status,age,head,body) values 
-- ('bob','smith',true,50,null,null),
-- ('andrei','yangabishev',true,43,'[1]',null),
-- ('mike',null,null,null,'  {"age":10,"age":12}     ','     {"age":10,"age":12}    '),
-- ('bob','smile',false,null,'2',null),
-- ('jane','[1,2,3,4]',null,null,'[]',null),
-- ('jane','[1,2,3,{test:1}]',false,32,'{}',null),
-- ('adam','{age:78}',null,30,null,null);

-- select json_agg(first_name) from test;
-- -- select json_agg(last_name) from test;
-- select json_agg(status) from test;
-- select json_agg(age) from test;
-- select json_agg(head) from test;
-- select json_agg(body) from test;
-- select jsonb_agg(first_name) from test;
-- select jsonb_agg(last_name) from test;
-- select jsonb_agg(status) from test;
-- select jsonb_agg(age) from test;
-- select jsonb_agg(head) from test;
-- select jsonb_agg(body) from test;

-- select jsonb_object_agg(k,v)
--   from (values (1,'null'::json),(2,'[]'),(2,'{"age":12}')) t(k,v);


-- 8.14. JSON Types
-- 9.16. JSON Functions and Operators

-- select '{"name":"Bob", "name":"Bob"}'::json;
-- select '{"name":"Bob", "name":"Boba","age":12}'::jsonb;
-- select json_build_array(1,2,3,'Bob',3);
-- select jsonb_build_array(1,2,3,'Bob',3);
-- select json_build_object('name','Bob','age',12,'name','Bob');
-- select jsonb_build_object('name','Bob','age',12,'name','Bob') ? 'name';

-- select jsonb_build_object('name','Bob','age',12,'name','Buba');

-- select '{"name":"Bob","name":"Bob"}'::jsonb ? 'name';
-- select '{"name":"Bob","name":"Bob"}' ? 'name';
-- select '{"meta":{"name":"Bob"}}'::jsonb ? 'name';
-- select '{"meta":{"name":"Bob"}}' ? 'name';

-- select '{"name":"Bob","age":[1,2],"meta":{"name":"Smith"}}'::jsonb @> '{"name":"Bob","age":[1],"meta":{"name":"Smith"}}'

-- select '{"name":"Bob"}'::jsonb || '{"age":12}'::jsonb;
-- select '{"name":"Bob","age":12}'::jsonb - 'name';
-- select '{"name":"Bob","age":12}'::jsonb - 'name';
-- select '{"name":"Bob","age":12}'::jsonb #- '{age}';
-- select '{"name":"Bob","age":12}'::jsonb #- '{name}';
-- select '{"name":"Bob","age":12}'::jsonb #- '{name,age}';
-- select '{"meta":{"name":"Bob","item":10},"age":12}'::jsonb - 1;
-- select '[{"meta":{"name":"Bob","item":10},"age":12}]'::jsonb #- '{0,meta,name}';
-- select coalesce('[{"meta":{"name":"Bob","item":10},"age":12}]'::jsonb #- '{meta,name}','{}');

-- select jsonb_set('[{"name":"Bob","age":12},2]','{0,age}','20')

-- select '[0,1,{"name":"Bob","meta":{"age":12}},5]'::jsonb -> 2;
-- select '{"name":"Bob","meta":{"age":12}}'::jsonb -> 'name';
-- select '{"name":"Bob","meta":{"age":12}}'::jsonb -> 'meta';
-- select '[0,1,{"name":"Bob","meta":{"age":12}},5]'::jsonb ->> 2
-- select '{"name":"Bob","meta":{"age":12}}'::jsonb ->> 'name';
-- select '{"name":"Bob","meta":{"age":12}}'::jsonb ->> 'meta';
-- select '"name"'::jsonb;

/* 
 * TODO надо посмотреть
 * как указываются массивы
 * если условие не подходит по тип, например #-, то как проверяется, можно ли такие обойти?
 * что за значение "name" jsonb
 */

-- select '{"bar":"baz", "name":"Boba","age11111":12}'::jsonb;
-- SELECT '{"bar": "baz", "balance": 7.77, "active":false}'::json;
-- SELECT '{"bar": "baz", "balance": 7.77, "active":false}'::jsonb;

-- select ' {    "name":   "Bob" }'::jsonb;





DROP TABLE IF EXISTS test_patient;
CREATE TABLE IF NOT EXISTS test_patient (
    id          serial      primary key,
    resource    jsonb
);
COPY test_patient(resource) FROM '/opt/host/patient.csv' (FORMAT csv , delimiter e'\t' , quote '|' , escape '\');
-- SELECT COUNT(*) FROM test_patient;

-- select jsonb_pretty(resource) from test_patient limit 1;

-- select k, '$.' || k, jsonb_typeof(jsonb_path_query(resource, ('$.' || k)::jsonpath))
--   from test_patient, jsonb_object_keys(resource) k;

-- with t as (
--     select k, v, jsonb_typeof(v) typ
--       from test_patient,
--            jsonb_object_keys(resource) k,
--            jsonb_path_query(resource, ('$.'||k)::jsonpath) v
--     union all


-- )
-- select * from t;

-- select k, typ
--   from test_patient, jsonb_typeof(resource) typ,
--   lateral (select * from jsonb_object_keys(resource)) k;

-- with recursive t as (
--     select k,
--            v,
--            jsonb_typeof(v) typ
--       from test_patient, 
--            jsonb_object_keys(resource) k, 
--            jsonb_path_query(resource, ('$.'||k)::jsonpath) v
--     union all
--     with q as (
--         select * from t
--     )
--     select * from q
-- )
-- select * from t;

-- with recursive t as (
--     select 1 x from (values(1)) x
--     union all
--     select * from (
--     select x+1 from t where x < 10
--     union all
--     select x+1 from t where x < 20
--     ) x
-- )
-- select * from t;

-- select x
--   from test_patient,
--   lateral (select jsonb_array_elements(jsonb_path_query_array(resource,'$ ? (@.type()=="object")')) qq) a,
--   lateral (select jsonb_object_keys(a.qq)) x,
--   lateral (select jsonb_path_query_array(resource,'$ ? (@.type()=="array")')) b;

-- select t from (values(1)) t;

-- select p.key from json_each('{"a":"foo", "b":"bar"}') p;

-- select jsonb_each(resource) from test_patient p;

-- select null, resource from test_patient;

WITH RECURSIVE keys AS
(
    SELECT null::text[] pth,
           resource,
           false good
      FROM test_patient
     UNION ALL
    SELECT nxt.*
      FROM keys,
      lateral (
            SELECT keys.pth||array[(jsonb_each(resource)).key],
                   (jsonb_each(resource)).value,
                   true
             WHERE jsonb_typeof(resource) = 'object'
             UNION ALL 
            SELECT keys.pth,
                   jsonb_array_elements(resource),
                   null
             WHERE jsonb_typeof(resource) = 'array'
     ) nxt
),
total AS
(
	SELECT count(*) ttl
      FROM test_patient
)
SELECT pth,
       count(*),
       (count(*)/ttl::float)*100 persent
  FROM keys,
       total
 WHERE good
 GROUP BY pth, ttl
 ORDER BY persent DESC;

-- select count(*) ttl from "organization";
      
--       values (null::jsonb) union all select jsonb_path_query(resource,'$ ? (@.type()=="object")')) t(zz),
--   lateral (values (null) union all select jsonb_object_keys(t.zz)) q(zz)

-- select '1'
--   from test_patient, jsonb_path_query(resource,'$ ? (@.type()=="object")')
--  where jsonb_typeof(resource) = 'array'
--  union all
-- select '2'
--   from test_patient, jsonb_path_query(resource,'$ ? (@.type()=="array")')
--  where jsonb_typeof(resource) = 'array'
-- union all
-- select e.key
--   from test_patient,
--        jsonb_each(resource) e
--  where jsonb_typeof(resource) = 'object' 
--    and jsonb_typeof(e.value)  = 'object'
-- union all
-- select e.key
--   from test_patient, 
--        jsonb_each(resource) e
--  where jsonb_typeof(resource) = 'object' 
--    and jsonb_typeof(e.value)  = 'array'
-- union all
-- select e.key
--   from test_patient, 
--        jsonb_each(resource) e
--  where jsonb_typeof(resource) = 'object' 
--    and jsonb_typeof(e.value) not in ('object','array');


/*
если это массив, то обойти каждый элемент
    если это простой объект, то пропускаем
    если это объект, то проваливаемся на обработку объекта
    если это массив, то проваливаемся на обработу массива
если это объект, то вытаскиваем все ключи
для каждого ключа вытаскиваем значение
если это значение объект, то проваливаемся на объекты
если это значение массив, то проваливаемся на обработку массива
*/