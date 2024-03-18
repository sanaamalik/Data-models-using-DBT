
{{ config(materialized='table') }}

SELECT *
FROM {{ ref('cte_query') }}
