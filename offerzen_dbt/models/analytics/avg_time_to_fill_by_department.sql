SELECT
   d.department,
   AVG(close_date - open_date) AS avg_time_to_fill
FROM {{ ref('fact_jobs') }} f
JOIN {{ ref('dim_department') }} d
ON f.department_key = d.department_key
WHERE close_date IS NOT NULL
GROUP BY d.department
ORDER BY avg_time_to_fill DESC