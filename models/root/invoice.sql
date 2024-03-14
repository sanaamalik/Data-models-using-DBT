{{ config(materialized='table') }}

SELECT
	split_part("CustomerRef"->>'name', ' ', 1) AS job_id,
    line_data ->> 'Amount' AS amount,
	line_data ->> 'Description' AS description,
    line_data ->> 'DetailType' AS detail_type,
    line_data -> 'SalesItemLineDetail' -> 'ItemRef' ->> 'name' AS item_name,
    (line_data -> 'SalesItemLineDetail' ->> 'UnitPrice')::numeric AS unit_price,
    (line_data -> 'SalesItemLineDetail' ->> 'Qty')::numeric AS quantity
FROM
    public."qb_full_invoices",
    json_array_elements("qb_full_invoices"."Line"::json) AS line_data
