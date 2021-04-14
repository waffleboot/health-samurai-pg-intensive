create table if not exists gaps (id integer primary key);
truncate table gaps;
-- insert into gaps (id) select x from generate_series(10,1,-1) x;
-- delete from gaps where id in (1,2,6,7,9,10);
-- delete from gaps where id != 3;
-- delete from gaps where id < 3;
-- delete from gaps where id > 6;
-- delete from gaps;
-- select * from gaps;
insert into gaps (id) select x from generate_series(10000,1,-1) x;
delete from gaps where id between 102 and 105;
delete from gaps where id between 134 and 176;
-- delete from gaps where id > 5000;
-- delete from gaps where id < 5000;
-- select lag(id) over () as p, id, lead(id) over () as n from gaps order by id;
drop view if exists lesson;
create view lesson as
-- with t as
-- (
WITH q AS
(
SELECT 0 id
 UNION ALL
SELECT 10001
 UNION ALL
SELECT id FROM gaps
),
t AS
(
    SELECT id + 1 f, lead(id) OVER(ORDER BY id) n FROM q
)
SELECT f, n - 1 t FROM t WHERE f < n;


-- select lag(id) over () as p, id, lead(id) over () as n from gaps order by id
-- )
-- select case id <> 1

-- select 1 as f, id - 1 as t from t where p is null and id <> 1 -- for deleted head
--  union all
-- select id + 1, n - 1 from t where id + 1 < n -- for deleted in the middle
--  union all
-- select id + 1, 10000 as t from t where n is null and id <> 10000 -- for deleted tail
--  union all
-- select 1, 10000 where not exists (select * from t); -- if all rows deleted
-- -- explain select * from lesson;
explain analyze select * from lesson;
-- select array_agg(int4range(f, t+1)) from lesson;
-- select id + 1 as f, p - 1 as t from t where id + 1 < p;
