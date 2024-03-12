{{ config(materialized='table') }}

select
    "Job_Number" as "srno",
    "Home_Owner" as "customer",
    "Crew_Lead" as "lead",
    "City" as "city",
    "Address" as "location",
    TO_CHAR("Created"::timestamp, 'Month') as "month",
    "Contract_Amount" as "contract",
    "Engineer" as "sales_men",
    "Class" as "center"
from public."ss_Foundation_Sandbox___Production"
