{{ config(materialized='table') }}

SELECT
 	split_part(line->'ItemBasedExpenseLineDetail'->>'CustomerRef', ' ', 1) AS job_id,
    (line->>'Description') AS description,
    (line->>'Amount')::numeric AS amount,
    (line->>'DetailType') AS detail_type,
    (line->'ItemBasedExpenseLineDetail'->'CustomerRef'->>'name') AS customer_name,
    (line->'ItemBasedExpenseLineDetail'->>'BillableStatus') AS billable_status,
    (line->'ItemBasedExpenseLineDetail'->>'Qty')::numeric AS qty,
    (line->'ItemBasedExpenseLineDetail'->>'UnitPrice')::numeric AS unit_price
FROM
	public."qb_full_purchases",
    json_array_elements("qb_full_purchases"."Line"::json) AS line
