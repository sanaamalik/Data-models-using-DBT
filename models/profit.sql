{{ config(materialized='table') }}

WITH job_expense AS (
    SELECT 
        j.job_id, 
        e.amount, 
        e.detail_type, 
        e.description
    FROM 
        {{ ref('jobs') }} j
    INNER JOIN 
        {{ ref('expense') }} e ON e.job_id = j.job_id
    ORDER BY 
        job_id
),
expenses AS (
    SELECT 
        job_id, 
        SUM(amount) AS expense
    FROM 
        job_expense
    GROUP BY 
        job_id
),
invoices AS (
    SELECT 
        j.job_id, 
        i.amount AS invoice
    FROM 
        {{ ref('jobs') }} j
    INNER JOIN 
        {{ ref('invoice') }} i ON i.job_id = j.job_id
    WHERE 
        i.detail_type = 'SubTotalLineDetail'
    ORDER BY 
        job_id
)

SELECT 
    i.job_id, 
    i.invoice as income, 
    e.expense,
    (CAST(i.invoice AS numeric) - e.expense) as profit,
    CASE 
        WHEN (CAST(i.invoice AS numeric) - e.expense) = 0 THEN 0
        ELSE i.invoice::numeric / (CAST(i.invoice AS numeric) - e.expense) 
    END AS profit_per,
    l.bonus::numeric / (CAST(i.invoice AS numeric) - e.expense) AS bonus_per
FROM 
   expenses e
LEFT JOIN 
    invoices i ON i.job_id = e.job_id
LEFT JOIN 
    {{ ref('labor_bonus') }} l ON l.job_id = e.job_id