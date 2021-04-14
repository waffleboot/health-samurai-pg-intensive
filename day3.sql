drop table if exists service;
create table service (
    id int primary key
  , name text           -- Название услуги
  , practitioner text   -- Врач
  , duration interval   -- Продолжительность
);
insert into service (id, name, practitioner, duration)
values  (1, 'Прием терапевта', 'Иванова И. В.', '30 min'::interval)
       ,(2, 'Прием педиатра',  'Смирнова Т. Е.', '20 min'::interval);
drop table if exists schedule;
create table schedule(
    id serial primary key
    , start date    -- Начало действия расписания
    , "end" date    -- Конец действия расписания
    , rule jsonb    -- Правило генерации
    , service int   -- Услуга
);
insert into schedule (start, "end", service, rule)
values
('2021-05-01', '2021-05-20', 1,
    $$
        [{"dow":   "mon",
        "start": "08:00:00",
        "end":   "13:00:00"}]
    $$),

('2021-05-06', '2021-05-30', 2,
    $$
        [{"dow":   "wed",
        "start": "10:00:00",
        "end":   "13:00:00"}
        ,{"dow":   "wed",
        "start": "15:00:00",
        "end":   "16:00:00"}]
    $$);
drop table if exists appointment;
create table appointment (
    id serial primary key
  , service int       -- Услуга
  , period tstzrange  -- Занятый период времени
);

insert into appointment (service, period)
values
  (1, '[2021-05-03 07:45, 2021-05-03 12:35]')
 ,(1, '[2021-05-10 08:35, 2021-05-10 10:20]')
 ,(2, '[2021-05-12 09:30, 2021-05-12 12:45]');


-- with recursive t as
-- (
--     select * from schedule

-- )
-- select * from t

-- EXPLAIN
WITH free AS
(
SELECT s.name,
       s.practitioner,
       s.duration,
       tsrange(slot,slot+s.duration) period,
       rank() OVER (PARTITION BY s.id ORDER BY slot) n
  FROM service s
  JOIN schedule tt ON s.id = tt.service,
       generate_series(tt.start,tt.end - s.duration,s.duration) as slot,
       jsonb_to_recordset(tt.rule) AS r(dow text, start time, "end" time)
 WHERE tstzrange(slot::date + r.start,slot::date  + r.end) @> tstzrange(slot,slot + s.duration)
   AND to_char(slot,'dy') = r.dow
   AND NOT EXISTS (SELECT *
                     FROM appointment a
                    WHERE s.id = a.service
                      AND tstzrange(slot,slot + s.duration) && a.period
                  )
)
SELECT name, practitioner, duration, period
  FROM free
 WHERE n <= 5;

-- select * from appointment where service = 1;
   


--    and tstzrange(d,d + s.duration) && tsrange(q.start, q.end)
   


-- with t as (
-- select s.id,
--        generate_series(start,tt.end - s.duration,s.duration) as d
--   from schedule tt, service s
--   where tt.service = s.id
--     and s.id = 1
-- )
-- select tsrange(t.d,t.d + s.duration)
--   from t, service s, appointment a
--  where s.id = t.id
--    and not tstzrange(t.d,t.d + s.duration) && a.period
--    and false;

-- drop type if exists foo;
-- create type foo as (dow text, start text, "end" text);

-- select * from schedule, jsonb_to_recordset(rule) as (dow text, start text, "end" text)


-- with recursive t as (
--     select service,
--            start::timestamp
--       from schedule
--      where id = 1
--      union all
--     select s.id,
--            t.start + s.duration
--       from service s, schedule tt, t
--      where s.id = tt.service
--        and s.id = t.service
--        and t.start + s.duration < tt.end
-- )
-- -- select * from t
-- select t.* 
--   from t, appointment a, service s
--  where s.id = t.service
--    and s.id = a.service
--    and (t.start,s.duration) overlaps a.period