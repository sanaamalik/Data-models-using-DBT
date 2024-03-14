{{ config(materialized='table') }}

WITH labor AS (
    SELECT 
        job_id, 
        SUM(amount) AS labor
    FROM 
        {{ ref('expense') }} 
    WHERE 
        description LIKE '%Crew Wages%'
    GROUP BY 
        job_id
)

SELECT 
    j.job_id,
    j.contract,
    COALESCE(l.labor, 0) AS labor,
    CASE 
        WHEN COALESCE(j.contract, '') = '' THEN 0
        ELSE COALESCE(l.labor, 0) / j.contract::float
    END AS labor_per,
    CASE
        WHEN COALESCE(j.contract, '') = '' THEN 0
        ELSE (0.14 - COALESCE(l.labor, 0) / j.contract::float) * CAST(j.contract AS double precision)
    END AS bonus,
    COALESCE(l.labor, 0) + 
    CASE
        WHEN COALESCE(j.contract, '') = '' THEN 0
        ELSE (0.14 - COALESCE(l.labor, 0) / j.contract::float) * CAST(j.contract AS double precision)
    END AS labor_bonus
FROM 
    {{ ref('jobs') }} j
LEFT JOIN 
    labor l ON j.job_id = l.job_id