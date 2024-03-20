{{ config(materialized='table') }}

SELECT 
    i.job_id,
    i.amount,
    it.incomename AS item,
    i.detail_type AS type
FROM {{ ref('item') }} it
RIGHT JOIN {{ ref('invoices') }} i ON i.item_value = it.id
order by job_id

