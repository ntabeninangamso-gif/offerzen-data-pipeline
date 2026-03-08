SELECT
   -- Dimension surrogate keys
   j.job_key,
   d.department_key,
   l.location_key,
   c.company_key,
   -- Fact attributes
   f.open_date,
   f.close_date,
   f.first_published,
   f.updated_at,
   f.is_current
FROM {{ ref('stg_fact_jobs') }} f
LEFT JOIN {{ ref('dim_job') }} j
   ON f.internal_job_id = j.internal_job_id
LEFT JOIN {{ ref('dim_department') }} d
   ON f.department = d.department
LEFT JOIN {{ ref('dim_location') }} l
   ON f.location = l.location
LEFT JOIN {{ ref('dim_company') }} c
   ON f.company_name = c.company_name