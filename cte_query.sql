WITH miter_export AS (
    SELECT job, total_cost 
    FROM table1
)
SELECT * FROM miter_export
