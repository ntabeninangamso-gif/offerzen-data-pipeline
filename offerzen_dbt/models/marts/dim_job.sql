WITH job_union AS (
    SELECT
        internal_job_id,
        title
    FROM {{ ref('stg_jobs_current') }}
    UNION
    SELECT
        internal_job_id,
        title
    FROM {{ ref('stg_jobs_history') }}
),
distinct_jobs AS (
    SELECT DISTINCT
        internal_job_id,
        title
    FROM job_union
)
SELECT
    ROW_NUMBER() OVER (ORDER BY internal_job_id) AS job_key,
    internal_job_id,
    title
FROM distinct_jobs
 