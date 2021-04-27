
-- Largest Organization
WITH RECURSIVE t AS (
    SELECT id as root,
           id
      FROM organization
     WHERE parent IS NULL
     UNION ALL
    SELECT t.root,
           ch.id
      FROM organization ch
      JOIN t ON ch.parent = t.id
), r AS (
SELECT root,
       count(*) cnt
  FROM t
 GROUP BY root
),
q AS (
SELECT r.*,
       rank() OVER (ORDER BY cnt DESC) rnk
  FROM r
)
SELECT name,
       cnt
  FROM q
  JOIN organization o ON o.id = q.root
 WHERE rnk = 1;

-- Materialized path
ALTER TABLE organization ADD IF NOT EXISTS path INTEGER[];
WITH RECURSIVE t AS
(
    SELECT id,
           array[]::integer[] path
      FROM organization
     WHERE parent IS NULL
     UNION ALL
    SELECT ch.id,
           t.path || t.id
      FROM t
      JOIN organization ch ON ch.parent = t.id
)
UPDATE organization o
   SET path = t.path
  FROM t
 WHERE t.id = o.id;

-- Use materialized path
SELECT * FROM organization WHERE path && '{2}';