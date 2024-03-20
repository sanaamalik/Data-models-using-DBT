{{ config(materialized='table') }}

select
    split_part("job", ' ', 1) AS job_id,
    "team_member" as "employee",
    "team_member_id" as "employee_id",
    "reg_hours" as "reg_hour",
    "ot_hours" as "ot_hour",
    regexp_replace("earnings", '[^\d.]+', '', 'g') AS "earnings",
    regexp_replace("total_cost", '[^\d.]+', '', 'g') AS "total_cost"
from public."miter_export"