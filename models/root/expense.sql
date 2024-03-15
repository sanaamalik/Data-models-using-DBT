{{ config(materialized='table') }}

WITH expenses AS (
    SELECT 
    CASE 
        WHEN (line->>'DetailType') = 'ItemBasedExpenseLineDetail' AND line->'ItemBasedExpenseLineDetail' IS NOT NULL AND regexp_match(line->'ItemBasedExpenseLineDetail'->'CustomerRef'->>'name', '\d{3}-\d{3}') IS NOT NULL THEN
            regexp_replace((regexp_match(line->'ItemBasedExpenseLineDetail'->'CustomerRef'->>'name', '\d{3}-\d{3}'))[1], '[{}]', '', 'g')
        WHEN (line->>'DetailType') = 'AccountBasedExpenseLineDetail' AND line->'AccountBasedExpenseLineDetail' IS NOT NULL AND regexp_match(line->'AccountBasedExpenseLineDetail'->'CustomerRef'->>'name', '\d{3}-\d{3}') IS NOT NULL THEN
            regexp_replace((regexp_match(line->'AccountBasedExpenseLineDetail'->'CustomerRef'->>'name', '\d{3}-\d{3}'))[1], '[{}]', '', 'g')
        ELSE NULL
    END AS job_id,
    line AS line
    FROM
        public."qb_full_purchases",
        json_array_elements("qb_full_purchases"."Line"::json) AS line
)

SELECT
    "job_id",
    (line->>'DetailType') AS detail_type,
	CASE 
        WHEN (line->>'DetailType') = 'ItemBasedExpenseLineDetail' THEN (line->>'Description')
        ELSE NULL
	END AS description,
    (line->>'Amount')::numeric AS amount,
	CASE 
        WHEN (line->>'DetailType') = 'ItemBasedExpenseLineDetail' THEN (line->'ItemBasedExpenseLineDetail'->>'BillableStatus')
		WHEN (line->>'DetailType') = 'AccountBasedExpenseLineDetail' THEN (line->'AccountBasedExpenseLineDetail'->>'BillableStatus')
	END AS billable_status,
	CASE 
        WHEN (line->>'DetailType') = 'ItemBasedExpenseLineDetail' THEN (line->'ItemBasedExpenseLineDetail'->>'Qty')::numeric 
		WHEN (line->>'DetailType') = 'AccountBasedExpenseLineDetail' THEN (line->'AccountBasedExpenseLineDetail'->>'Qty')::numeric 
	END AS quatitiy,
	CASE 
        WHEN (line->>'DetailType') = 'ItemBasedExpenseLineDetail' THEN (line->'ItemBasedExpenseLineDetail'->>'UnitPrice')::numeric 
		WHEN (line->>'DetailType') = 'AccountBasedExpenseLineDetail' THEN (line->'AccountBasedExpenseLineDetail'->>'UnitPrice')::numeric 
	END AS unit_price,
    CASE 
        WHEN (line->>'DetailType') = 'ItemBasedExpenseLineDetail' THEN (line->'ItemRef'->>'name')
		WHEN (line->>'DetailType') = 'AccountBasedExpenseLineDetail' THEN (line->'AccountBasedExpenseLineDetail'->'AccountRef'->>'name')
	END AS item_name,
    CASE 
        WHEN (line->>'DetailType') = 'ItemBasedExpenseLineDetail' THEN (line->'ItemRef'->>'value')
		WHEN (line->>'DetailType') = 'AccountBasedExpenseLineDetail' THEN (line->'AccountBasedExpenseLineDetail'->'AccountRef'->>'value')
	END AS item_value
FROM
    expenses
   
WHERE
    job_id IS NOT NULL