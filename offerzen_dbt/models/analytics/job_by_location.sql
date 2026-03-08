SELECT
   l.location,
   COUNT(*) AS job_count
FROM {{ ref('fact_jobs') }} f
JOIN {{ ref('dim_location') }} l
ON f.location_key = l.location_key
GROUP BY l.location
ORDER BY job_count DESC