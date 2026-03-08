SELECT
   ROW_NUMBER() OVER (ORDER BY company_name) AS company_key,
   company_name
FROM (
   SELECT DISTINCT company_name
   FROM {{ ref('stg_jobs_history') }}
   UNION
   SELECT DISTINCT company_name
   FROM {{ ref('stg_jobs_current') }}
) companies