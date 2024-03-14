{{ config(materialized='table') }}

select
    job_id,
    customer,
    location,
    lead,
    city,
    month,
    sales_men,
    contract,
    center
from {{ ref('jobs') }}
