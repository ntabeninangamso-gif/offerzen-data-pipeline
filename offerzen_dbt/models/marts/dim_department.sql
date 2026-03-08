SELECT
   ROW_NUMBER() OVER (ORDER BY department) AS department_key,
   department
FROM (
   SELECT DISTINCT department
   FROM {{ ref('stg_jobs_history') }}
) departments