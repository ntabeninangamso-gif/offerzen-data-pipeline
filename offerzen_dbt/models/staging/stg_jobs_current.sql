SELECT
   -- Primary identifiers
   job_id,
   internal_job_id,
   -- Text fields standardized
   LOWER(TRIM(NULLIF(title,''))) AS title,
   LOWER(TRIM(
       COALESCE(NULLIF(company_name,''),'unknown')
   )) AS company_name,
   LOWER(TRIM(
       COALESCE(NULLIF(location,''),'unknown')
   )) AS location,
   -- Dates standardized
   CAST(first_published AS TIMESTAMP) AS first_published,
   CAST(updated_at AS TIMESTAMP) AS updated_at
FROM {{ source('raw','jobs_current_raw') }}