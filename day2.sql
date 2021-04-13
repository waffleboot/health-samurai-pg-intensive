
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

-- Materialized path
ALTER TABLE organization ADD IF NOT EXISTS path INTEGER[];
WITH RECURSIVE t AS
(
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

-- Use materialized path
SELECT * FROM organization WHERE 2 = ANY (path);