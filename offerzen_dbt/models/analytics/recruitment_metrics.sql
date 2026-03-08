WITH base AS (
SELECT
   f.job_key,
   d.department,
   l.location,
   f.open_date,
   f.close_date,
   f.is_current
FROM {{ ref('fact_jobs') }} f
LEFT JOIN {{ ref('dim_department') }} d
   ON f.department_key = d.department_key
LEFT JOIN {{ ref('dim_location') }} l
   ON f.location_key = l.location_key
)
SELECT
   COUNT(*) FILTER (WHERE is_current = 1) AS current_open_jobs,
   COUNT(*) FILTER (WHERE is_current = 0) AS historical_jobs,
   AVG(close_date - open_date) AS avg_time_to_fill_days
FROM base