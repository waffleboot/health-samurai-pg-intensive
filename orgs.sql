drop table if EXISTS organization;
CREATE TABLE organization (
    id      INT,
    parent  INT,
    name    TEXT
);
TRUNCATE organization;
INSERT 
  INTO organization (id, parent, name)
VALUES (1, null, 'ГКБ 1')
	  ,(2, null, 'ГКБ 2')
	  ,(3, 1, 'Детское отделение')
	  ,(4, 3, 'Правое крыло')
	  ,(5, 4, 'Кабинет педиатора')
	  ,(6, 2, 'Хирургия')
	  ,(7, 6, 'Кабинет 1')
	  ,(8, 6, 'Кабинет 2')
	  ,(9, 6, 'Кабинет 3');

-- Largest Organization
WITH RECURSIVE t AS
(
    SELECT name,
           id
      FROM organization
     WHERE parent IS NULL
     UNION ALL
    SELECT t.name,
           o.id
      FROM organization o, t
     WHERE o.parent = t.id
)
SELECT name,
       count(*) AS cnt
  FROM t
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 1;

-- ответ на второй вопрос
ALTER TABLE organization ADD if not EXISTS path integer[];
WITH RECURSIVE t AS (
    SELECT id,
           parent,
           0 as lvl
      FROM organization
     WHERE parent IS NOT NULL
     UNION ALL
    SELECT t.id,
           p.parent,
           t.lvl + 1
      FROM t, organization p
     WHERE t.parent = p.id
       AND p.parent IS NOT NULL
)
UPDATE organization o
   SET path = q.path
  FROM (SELECT id, array_agg(parent ORDER BY lvl DESC) path FROM t GROUP BY id) q
 WHERE o.id = q.id;

select id,path from organization;

-- ответ на третий вопрос
SELECT * FROM organization WHERE 2 = ANY (path);