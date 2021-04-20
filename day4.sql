-- CREATE TABLE if not exists route (id integer NOT NULL,
--                     name text, --  название маршрута
--  CONSTRAINT route_pkey PRIMARY KEY (id));

-- -- каждый маршрут состоит из рейсов (прямое и обратное направление)

-- CREATE TABLE if not exists trip (id integer NOT NULL,
--                               route_id integer, -- id  маршрута
--  direction integer, -- направление (0 - прямое, 1 - обратное)
--  CONSTRAINT trip_pkey PRIMARY KEY (id));

-- CREATE TABLE if not exists STOP (id integer NOT NULL,
--                               name text, -- название остановки
--  CONSTRAINT stop_pkey PRIMARY KEY (id));

--  CREATE TABLE if not exists trip_stop (trip_id integer, -- id рейса
--  stop_id integer, -- id остановки
--  "position" integer, -- позиция остановки на рейсе
--  arrival_time interval -- время прибывания на остановку относительно начала рейса (первая остановка в рейсе всегда = 0)
-- );

-- CREATE TABLE if not exists vehicle_stoplog (id serial NOT NULL,
--                                         vehicle_id integer, -- id автобуса
--  trip_id integer, -- id рейса
--  stop_id integer, -- id остановки
--  arrival_time TIMESTAMP WITH TIME ZONE, -- время прибывания автобуса на остановку
--  CONSTRAINT vehicle_stoplog_pkey PRIMARY KEY (id));

-- truncate route;
-- INSERT INTO route(id, name)
-- VALUES (1, '36Т'),
--        (2, '75');


-- truncate trip;
-- INSERT INTO trip(id, route_id, direction)
-- VALUES (1, 1, 0),
--        (2, 1, 1),
--        (3, 2, 0),
--        (4, 2, 1);

-- truncate stop;
-- INSERT INTO stop(id, name)
-- SELECT i,
--        'Остановка № ' || i::text
-- FROM generate_series(1, 27, 1) i;

-- truncate trip_stop;
-- INSERT INTO trip_stop(trip_id, stop_id, "position", arrival_time)
-- VALUES (1, 1, 1, interval '1s'*0),
--        (1, 2, 2, interval '1s'*653),
--        (1, 3, 3, interval '1s'*1206),
--        (1, 4, 4, interval '1s'*1726),
--        (1, 5, 5, interval '1s'*2358),
--        (1, 6, 6, interval '1s'*2546),
--        (1, 7, 7, interval '1s'*3188),
--        (1, 8, 8, interval '1s'*3827),
--        (1, 9, 9, interval '1s'*4206),
--        (1, 10, 10, interval '1s'*4420),
--        (1, 11, 11, interval '1s'*5196),
--        (1, 12, 12, interval '1s'*5483),
--        (2, 1, 12, interval '1s'*5483),
--        (2, 2, 11, interval '1s'*4831),
--        (2, 3, 10, interval '1s'*4278),
--        (2, 4, 9, interval '1s'*3758),
--        (2, 5, 8, interval '1s'*3125),
--        (2, 6, 7, interval '1s'*2937),
--        (2, 7, 6, interval '1s'*2295),
--        (2, 8, 5, interval '1s'*1657),
--        (2, 9, 4, interval '1s'*1278),
--        (2, 10, 3, interval '1s'*1064),
--        (2, 11, 2, interval '1s'*287),
--        (2, 12, 1, interval '1s'*0),
--        (3, 13, 1, interval '1s'*0),
--        (3, 14, 2, interval '1s'*425),
--        (3, 15, 3, interval '1s'*1002),
--        (3, 16, 4, interval '1s'*1246),
--        (3, 17, 5, interval '1s'*2016),
--        (3, 18, 6, interval '1s'*2766),
--        (3, 19, 7, interval '1s'*3618),
--        (3, 20, 8, interval '1s'*3822),
--        (3, 21, 9, interval '1s'*4249),
--        (3, 22, 10, interval '1s'*4956),
--        (3, 23, 11, interval '1s'*5786),
--        (3, 24, 12, interval '1s'*5991),
--        (3, 25, 13, interval '1s'*6430),
--        (3, 26, 14, interval '1s'*6672),
--        (4, 13, 14, interval '1s'*6672),
--        (4, 14, 13, interval '1s'*6247),
--        (4, 15, 12, interval '1s'*5671),
--        (4, 16, 11, interval '1s'*5427),
--        (4, 17, 10, interval '1s'*4656),
--        (4, 18, 9, interval '1s'*3907),
--        (4, 19, 8, interval '1s'*3055),
--        (4, 20, 7, interval '1s'*2851),
--        (4, 21, 6, interval '1s'*2423),
--        (4, 22, 5, interval '1s'*1717),
--        (4, 23, 4, interval '1s'*886),
--        (4, 24, 3, interval '1s'*681),
--        (4, 25, 2, interval '1s'*242),
--        (4, 26, 1, interval '1s'*0);

-- truncate vehicle_stoplog;
-- INSERT INTO vehicle_stoplog(vehicle_id, trip_id, stop_id, arrival_time)
-- VALUES (3101,1,1, to_timestamp(1618423171)),
--        (3101,1,4, to_timestamp(1618426583)),
--        (3101,1,5, to_timestamp(1618429246)),
--        (3101,1,7, to_timestamp(1618435659)),
--        (3101,1,8, to_timestamp(1618439318)),
--        (3101,1,10, to_timestamp(1618447826)),
--        (3101,1,11, to_timestamp(1618453043)),
--        (3101,1,12, to_timestamp(1618459089)),
--        (3102,2,12, to_timestamp(1618417195)),
--        (3102,2,11, to_timestamp(1618418085)),
--        (3102,2,10, to_timestamp(1618419520)),
--        (3102,2,9, to_timestamp(1618421714)),
--        (3102,2,8, to_timestamp(1618424123)),
--        (3102,2,7, to_timestamp(1618426805)),
--        (3102,2,6, to_timestamp(1618429829)),
--        (3102,2,4, to_timestamp(1618437390)),
--        (3102,2,2, to_timestamp(1618448009)),
--        (3102,2,1, to_timestamp(1618454094)),
--        (3103,3,13, to_timestamp(1618423892)),
--        (3103,3,14, to_timestamp(1618424284)),
--        (3103,3,15, to_timestamp(1618424972)),
--        (3103,3,16, to_timestamp(1618425956)),
--        (3103,3,18, to_timestamp(1618429579)),
--        (3103,3,19, to_timestamp(1618432038)),
--        (3103,3,20, to_timestamp(1618434928)),
--        (3103,3,21, to_timestamp(1618438534)),
--        (3103,3,23, to_timestamp(1618447323)),
--        (3103,3,24, to_timestamp(1618452750)),
--        (3103,3,26, to_timestamp(1618465427)),
--        (3104,4,26, to_timestamp(1618416052)),
--        (3104,4,23, to_timestamp(1618420253)),
--        (3104,4,22, to_timestamp(1618422707)),
--        (3104,4,21, to_timestamp(1618425801)),
--        (3104,4,20, to_timestamp(1618429670)),
--        (3104,4,19, to_timestamp(1618433881)),
--        (3104,4,18, to_timestamp(1618438455)),
--        (3104,4,17, to_timestamp(1618443652)),
--        (3104,4,15, to_timestamp(1618455479)),
--        (3104,4,13, to_timestamp(1618468534));

-- select * from route;
-- select * from trip;
-- select * from stop;
-- select * from trip_stop;
-- select * from vehicle_stoplog;

-- select * from vehicle_stoplog;

-- select distinct vehicle_id, trip_id
--   from vehicle_stoplog


-- drop table if exists foo;
-- create table if not exists foo (
--     id integer,
--     pos integer,
--     val integer
-- );

-- truncate foo;
-- insert into foo (id,pos,val) select 20-n, 2*n,n*10 from generate_series(1,10) n;
-- update foo set val = null where pos in (2,4,12,14,18,20);

-- insert into foo (id,pos) values (1,null),(2,20),(3,30),(4,null),(5,null),(6,60),(7,null);
-- select * from foo order by pos;

-- select id,
--        lead
--   from foo
--  where pos is not null;

-- with t as (
-- select pos a,
--        lead(pos) over (order by pos) b,
--        lead(val) over (order by pos) val,
--        max(pos)  over() mxb,
--        last_value(val) over (order by pos) mxv
--   from foo where val is not null
-- ) select a, coalesce(b, mxb), val, mxv
--    from t;

-- select t1.pos,
--        t1.val,
--        t2.va,
--        t2.vb,
--        coalesce(t1.val,t2.va) ans
--   from foo t1
--   left join (select lag(pos) over (order by pos) a,
--                     pos b,
--                     lead(pos) over (order by pos) c,
--                     lag(val) over (order by pos) va,
--                     val vb,
--                     lead(val) over (order by pos) vc
--                from foo where val is not null) t2 on
--        (t2.b < t1.pos and t1.pos < t2.c) or (t1.pos > t2.a and t2.b is null)
--  order by t1.pos;



-- select id,
--        pos,
--        (select pos from foo f2 where f2.id >= f1.id and f2.pos is not null order by f2.id limit 1)
--   from foo f1
--   order by id;

-- select * from foo;

-- select id, pos, generate_series(id, lead(id-1) over (order by id))
--   from foo
--  where pos is not null;

-- select ts.position,
--        ts.arrival_time,
--        vs.arrival_time,
--        case when vs.arrival_time is null then 1
--        else 2
--        end
--   from trip_stop ts
--   left join vehicle_stoplog vs on ts.trip_id = vs.trip_id and ts.stop_id = vs.stop_id
--  where ts.trip_id = 1
--  order by ts.position

-- select * from trip_stop where trip_id = 1;

drop view comb1 cascade;
create view comb1 as
select t1.trip_id,
       t1.stop_id a,
       t2.stop_id b,
       t1.position p1,
       t2.position p2,
       t2.arrival_time - t1.arrival_time arrival_time,
       extract (epoch from t1.arrival_time) e1,
       extract (epoch from t2.arrival_time) e2,
       extract (epoch from t2.arrival_time - t1.arrival_time) ed
  from trip_stop t1 join trip_stop t2 on t1.trip_id = t2.trip_id and t1.position < t2.position;
select count(*) from comb1;

drop view data cascade;
create view data as
select ts.trip_id,
       ts.stop_id,
       ts.position,
       min(ts.position) over (partition by ts.trip_id) min_pos,
       max(ts.position) over (partition by ts.trip_id) max_pos,
       first_value(ts.stop_id)       over (partition by ts.trip_id order by ts.position)      min_stop_id,
       first_value(ts.stop_id)       over (partition by ts.trip_id order by ts.position desc) max_stop_id,
       first_value(vs.arrival_time)  over (partition by ts.trip_id order by ts.position)      min_time,
       first_value(vs.arrival_time)  over (partition by ts.trip_id order by ts.position desc) max_time,
       vs.arrival_time,
       lead(vs.arrival_time) over (partition by ts.trip_id order by ts.position) - vs.arrival_time delta_time,
       lead(ts.position)     over (partition by ts.trip_id order by ts.position) next_pos,
       lead(ts.stop_id)      over (partition by ts.trip_id order by ts.position) next_stop_id
  from vehicle_stoplog vs
  join trip_stop ts on ts.trip_id = vs.trip_id and ts.stop_id = vs.stop_id;

drop view state cascade;
create view state as
select ts.trip_id,
       ts.stop_id,
       case
       when ts.stop_id  = t.stop_id then  0
       when ts.position < t.min_pos then -1
       when ts.position > t.max_pos then +1
       else +2
       end m,
       t.arrival_time,
       t.delta_time,
       case
       when ts.position < t.min_pos then ts.stop_id
       when ts.position > t.max_pos then t.max_stop_id
       else t.stop_id
       end a1,
       case
       when ts.position < t.min_pos then t.min_stop_id
       when ts.position > t.max_pos then ts.stop_id
       else ts.stop_id
       end b1,
       case
       when ts.position < t.min_pos then ts.stop_id
       when ts.position > t.max_pos then t.max_stop_id
       else t.stop_id
       end a2,
       case
       when ts.position < t.min_pos then t.min_stop_id
       when ts.position > t.max_pos then ts.stop_id
       else t.next_stop_id
       end b2
  from data t
 cross join trip_stop ts
 where ts.trip_id = t.trip_id
   and (ts.position < t.min_pos or ts.position > t.max_pos or ts.position >= t.position and ts.position < coalesce(t.next_pos,max_pos+1));

select r.name route_name,
       t.direction,
       s.name stop_name,
       case
       when m =  0 then q.arrival_time
       when m = -1 then q.arrival_time - c1.arrival_time
       when m = +1 then q.arrival_time + c1.arrival_time
       when m = +2 then extract (epoch from c1.arrival_time) / extract (epoch from c2.arrival_time) * (q.delta_time) + q.arrival_time
       end fact_time,
       case
       when m =  0 then 0
       else 1
       end calculated
  from state q
  join trip t on t.id = q.trip_id
  join stop s on s.id = q.stop_id
  join route r on r.id = t.route_id
  left join comb1 c1 on c1.a = q.a1 and c1.b = q.b1 and c1.trip_id = q.trip_id
  left join comb1 c2 on c2.a = q.a2 and c2.b = q.b2 and c2.trip_id = q.trip_id
 where r.id = 1 and t.direction = 0
 order by t.id, t.direction;
