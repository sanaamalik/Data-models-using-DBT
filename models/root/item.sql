{{ config(materialized='table') }}

SELECT 
    "Id" as id,
    "Name" as name,
    "Description" as description,
    CASE 
        WHEN "AssetAccountRef" IS NOT NULL THEN "AssetAccountRef"->>'name'
        ELSE NULL
	END AS assetname,
    CASE 
        WHEN "AssetAccountRef" IS NOT NULL THEN "AssetAccountRef"->>'value'
        ELSE NULL
	END AS assetref,
    CASE 
        WHEN "IncomeAccountRef" IS NOT NULL THEN "IncomeAccountRef"->>'name'
        ELSE NULL
	END AS incomename,
    CASE 
        WHEN "IncomeAccountRef" IS NOT NULL THEN "IncomeAccountRef"->>'value'
        ELSE NULL
	END AS incomeref,
    CASE 
        WHEN "ExpenseAccountRef" IS NOT NULL THEN "ExpenseAccountRef"->>'name'
        ELSE NULL
	END AS expensename,
    CASE 
        WHEN "ExpenseAccountRef" IS NOT NULL THEN "ExpenseAccountRef"->>'value'
        ELSE NULL
	END AS expenseref,
    "FullyQualifiedName" as subfield
FROM public."qb_full_items"
    