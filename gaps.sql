create table if not exists gaps (id integer primary key);
truncate table gaps;
-- insert into gaps (id) select x from generate_series(1,10) x;
-- delete from gaps where id not in (3,4,5,8);
-- delete from gaps where id != 3;
-- delete from gaps where id < 2;
-- delete from gaps where id > 11;
-- delete from gaps;
-- select * from gaps;
insert into gaps (id) select x from generate_series(1,10000) x;
delete from gaps where id between 102 and 105;
delete from gaps where id between 134 and 176;
-- delete from gaps where id > 5000;
-- delete from gaps where id < 5000;
-- select lag(id) over () as p, id, lead(id) over () as n from gaps order by id;
drop view if exists lesson;
create view lesson as
with t as
(
select lag(id) over () as p, id, lead(id) over () as n from gaps order by id
)
select 1 as f, id - 1 as t from t where p is null and id <> 1 -- for deleted head
 union all
select id + 1, n - 1 from t where id + 1 < n -- for deleted in the middle
 union all
select id + 1, 10000 as t from t where n is null and id <> 10000 -- for deleted tail
 union all
select 1, 10000 where not exists (select * from t); -- if all rows deleted
explain select * from lesson;
select * from lesson;
-- select array_agg(int4range(f, t+1)) from lesson;
-- select id + 1 as f, p - 1 as t from t where id + 1 < p;
