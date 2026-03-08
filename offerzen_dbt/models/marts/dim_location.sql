SELECT
   ROW_NUMBER() OVER (ORDER BY location) AS location_key,
   location
FROM (
   SELECT DISTINCT location
   FROM {{ ref('stg_jobs_history') }}
   UNION
   SELECT DISTINCT location
   FROM {{ ref('stg_jobs_current') }}
) locations