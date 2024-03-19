{{ config(materialized='table') }}

SELECT 
    i.job_id,
    i.amount,
    it.incomename,
    i.detail_type
FROM {{ ref('item') }} it
right join {{ ref('invoices') }} i on i.item_value = it.id
order by job_id

