{{ config(materialized='table') }}

select
    "Job_Number" as "job_id",
    "Home_Owner" as "customer",
    "Crew_Lead" as "lead",
    "City" as "city",
    "Address" as "location",
    TO_CHAR("Created"::timestamp, 'Month') as "month",
    "Contract_Amount" as "contract",
    "Engineer" as "sales_men",
    "Class" as "center",
    "Engineer" as "engineer",
    "Permit_Issue_Fee" as "permit",
    "Job_Start_Date" as "job_start",
    "Job_Finish_Date" as "job_end"
from public."ss_Foundation_Sandbox___Production"
