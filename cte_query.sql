WITH miter_export AS (
    SELECT job, total_cost,
    (total_cost::float / 500) * 100 AS tcp
    FROM table1
)
SELECT * FROM miter_export
