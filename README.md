Welcome to your new dbt project!
### Using the starter project
Try running the following commands:
- dbt run
- dbt test
### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

OfferZen Data Pipeline
This project implements an end-to-end data pipeline that ingests job data from an external API, stores it in PostgreSQL, transforms it using dbt, and produces recruitment analytics metrics.
The pipeline converts raw API data into an analytics-ready star schema and calculates key recruitment insights such as the number of open jobs, historical job counts, and average time-to-fill.

Project Architecture
The pipeline follows a layered architecture:

API
 ↓
Python Ingestion Scripts
 ↓
PostgreSQL (Raw Tables)
 ↓
dbt Staging Models
 ↓
dbt Dimensional Models (Star Schema)
 ↓
Analytics Models
 
Repository Structure
offerzen-data-pipeline
│
├ ingestion
│   ├ fetch_api_data.py
│   ├ load_csv.py
│   └ check_api_columns.py
│
├ offerzen_dbt
│   ├ models
│   │   ├ staging
│   │   │   ├ stg_jobs_current.sql
│   │   │   ├ stg_jobs_history.sql
│   │   │   └ stg_fact_jobs.sql
│   │   │
│   │   ├ marts
│   │   │   ├ dim_company.sql
│   │   │   ├ dim_department.sql
│   │   │   ├ dim_location.sql
│   │   │   ├ dim_job.sql
│   │   │   └ fact_jobs.sql
│   │   │
│   │   └ analytics
│   │       └ recruitment_metrics.sql
			└ jobs_by_departments.sql
			└ jobs_by_location.sql
			└ hiring_trend.sql
			└ avg_time_to_fil_by_department.sql
│
├ README.md
└ SOLUTION.md

Technologies Satck
Tool                     Purpose
Python                   API Ingestion
PostgreSQL               Data Warehouse
dbt (data build tool)    Data transformation & modelling
SQL                      Data Analysis

Local Setup Instructions
#1. Install PostgreSQL
Download PostgreSQL binaries and extract them locally.
Initialize the database:
initdb -D C:\postgres\data

#2. Start PostgreSQL
Open PowerShell and Run:
cd C:\postgres\pgsql\bin
.\pg_ctl -D C:\postgres\data -l logfile start
This starts the PostreSQL server on port 5432.

#3. Install Python Dependencies
Install the required Python libraries:
pip install -r requirements.txt

#4. 4 Run Data Ingestion
Run the ingestion scripts to fetch job data from the API and load it into PostgreSQL:
python fetch_api_data.py
python load_csv.py

This populates the raw tables:
jobs_current_raw
jobs_history_raw

#5. Run dbt Transformations
Navigate to the dbt project directory:
cd offerzen_dbt
Run all dbt models:
dbt run
This builds the staging, dimensional, and analytics models.

#6 Run Data Tests
Execute dbt tests to validate the data:
dbt test
These tests ensure:
• primary keys are not null
• dimension relationships are valid
• data quality rules are satisfied

#7 Generate dbt Documentation
Generate project documentation and lineage:
dbt docs generate
dbt docs serve
Open the documentation in your browser to explore:
	•	model documentation
	•	column descriptions
	•	lineage graph

Analytics Metrics
#1. Recruitment_metrics
This model provides a high-level summary of recruitment activity:
Metric                     Description
current_open_jobs          Number of jobs currently open
historical_jobs            Total number of historical jobs
avg_time_to_fill_days      Average number of days required to fill a job

Example Query
SELECT * FROM recruitment_metrics;
 
Example output:
current_open_jobs       historical_jobs     avg_time_to_fill_days
4                       314                 153
**This indicates that on average it takes approximately 153 days to fill a job position.

#2. Jobs by Department
This metric shows which departments are hiring the most.
Example Query
SELECT * FROM jobs_by_department;

Example output:
department      job_count
marketing	    61
sales	        56
data	        50
product	        50
engineering	    49
operations	    48

**Explanation
This metric identifies which departments have the highest hiring demand.
It can be used by management to understand which teams are expanding.

#3. Jobs by Location
This metric shows how job postings are distributed geographically.
Example Query
SELECT * FROM job_by_location

Example output:
Location            Job_count
netherlands	        160
south africa	    158

Explanation
This metric highlights regional hiring trends and helps identify where most hiring activity occurs.

#4.Hiring Trend Over Time
This metric shows how hiring activity changes over time.
month                   job_posted
2016-01-01 00:00:00	    1
2016-02-01 00:00:00	    2
2016-03-01 00:00:00	    1
2016-04-01 00:00:00	    3
2016-10-01 00:00:00	    2
2016-11-01 00:00:00	    3
2017-01-01 00:00:00	    2

**Explanation
This metric helps identify hiring growth or slowdowns over time.
It can be used for workforce planning and forecasting.

 
 
 
 


 
 
 

