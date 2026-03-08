SELECT
   DATE_TRUNC('month', open_date) AS month,
   COUNT(*) AS jobs_posted
FROM {{ ref('fact_jobs') }}
GROUP BY month
ORDER BY month