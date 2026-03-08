SELECT
   -- Primary identifiers
   job_id,
   internal_job_id,
   -- Text normalization
   LOWER(TRIM(NULLIF(title,''))) AS title,
   LOWER(TRIM(
       COALESCE(NULLIF(department,''),'unknown')
   )) AS department,
   LOWER(TRIM(
       COALESCE(NULLIF(location,''),'unknown')
   )) AS location,
   LOWER(TRIM(
       COALESCE(NULLIF(company_name,''),'unknown')
   )) AS company_name,
   -- Date handling
   CAST(open_date AS DATE) AS open_date,
   CAST(close_date AS DATE) AS close_date
FROM {{ source('raw','jobs_history_raw') }}
WHERE internal_job_id IS NOT NULL