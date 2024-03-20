{{ config(materialized='table') }}

SELECT 
    e.job_id,
    e.amount,
    e.item_name as type
FROM {{ ref('account') }} a
INNER JOIN {{ ref('expenses') }} e on e.item_value = a.id 
order by job_id