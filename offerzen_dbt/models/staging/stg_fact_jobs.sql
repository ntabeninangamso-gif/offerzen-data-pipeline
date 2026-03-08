WITH history_jobs AS (
   SELECT
       job_id,
       internal_job_id,
       department,
       location,
       company_name,
       -- fields that exist in history
       open_date,
       close_date,
       -- fields missing in history
        CAST(NULL AS TIMESTAMP)  AS first_published,
        CAST(NULL AS TIMESTAMP) AS updated_at,
       0 AS is_current
   FROM {{ ref('stg_jobs_history') }}
),
current_jobs AS (
   SELECT
       job_id,
       internal_job_id,
       'unknown' as department,
       location,
       company_name,
       -- fields missing in current
       CAST(NULL AS TIMESTAMP) AS open_date,
        CAST(NULL AS TIMESTAMP) AS close_date,
       -- fields that exist in current
       first_published,
       updated_at,
       1 AS is_current
   FROM {{ ref('stg_jobs_current') }}
),
all_jobs AS (
   SELECT * FROM history_jobs
   UNION
   SELECT * FROM current_jobs
)
SELECT DISTINCT *
FROM all_jobs