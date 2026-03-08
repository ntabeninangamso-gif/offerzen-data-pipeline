SELECT
    d.department,
    COUNT(*) AS job_count
FROM fact_jobs f
JOIN dim_department d
ON f.department_key = d.department_key
GROUP BY d.department
ORDER BY job_count DESC
 