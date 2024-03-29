{{ config(materialized='table') }}

SELECT 
    "Id" as id,
    "Name" as name,
    CASE 
        WHEN "ParentRef" IS NOT NULL THEN "ParentRef"->>'value'
        ELSE NULL
	END AS ref,
    "AccountType" as type,
    "AccountSubType" as subtype,
    "Classification" as classification,
    "FullyQualifiedName" as subfield
FROM public."qb_full_accounts"
ORDER BY "Id"::integer
    
