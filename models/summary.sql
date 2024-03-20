{{ config(materialized='table') }}

WITH labor AS (
    SELECT 
        job_id, 
        SUM(amount) AS labor
    FROM 
        {{ ref('expenses') }}
    WHERE 
        description LIKE '%Crew Wages%'
    GROUP BY 
        job_id
),
commission AS (
    SELECT 
        job_id, 
        SUM(amount) AS commission
    FROM 
        {{ ref('expenses') }}
    WHERE 
        description LIKE '%Sales Commission%'
    GROUP BY 
        job_id
),
commission_owned AS (
    SELECT
        j.job_id,
        COALESCE(sc.commission, 0) AS commission,
        CASE WHEN p.income::NUMERIC = 0 THEN 0 ELSE COALESCE(sc.commission, 0) / p.income::NUMERIC END as commission_owned
    FROM 
        {{ ref('jobs') }} j
    LEFT JOIN 
        commission sc ON j.job_id = sc.job_id
    LEFT JOIN
        {{ ref('profit') }} p ON p.job_id = j.job_id
)

SELECT 
    j.job_id,
    j.sales_men,
    j.lead AS crew,
    j.contract,
    COALESCE(sc.commission, 0) AS commission,
    COALESCE(co.commission_owned, 0) as commission_owned,
    COALESCE(NULLIF(j.contract, '')::NUMERIC, 0) * (p.profit_per - p.bonus_per - COALESCE(co.commission_owned, 0)) as gp,
    p.profit_per - p.bonus_per - (CASE WHEN p.income::NUMERIC = 0 THEN 0 ELSE COALESCE(sc.commission, 0) / p.income::NUMERIC END) as gpp,
    lb.bonus,
    COALESCE(l.labor, 0) AS labor,
    lb.labor_per,
    j.job_start,
    j.job_end
FROM 
    {{ ref('jobs') }} j
LEFT JOIN 
    labor l ON j.job_id = l.job_id
LEFT JOIN 
    commission sc ON j.job_id = sc.job_id
LEFT JOIN
    {{ ref('labor_bonus') }} lb ON j.job_id = lb.job_id
LEFT JOIN
    {{ ref('profit') }} p ON p.job_id = lb.job_id
LEFT JOIN 
    commission_owned co ON j.job_id = co.job_id