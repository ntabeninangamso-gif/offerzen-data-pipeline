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

Prerequisites

Ensure the following tools are installed on your machine:
Tool			Version
Python			3.11.x
PostgreSQL		14+
pip				latest
Git				latest

You can verify installations using:
python --version
pip --version
psql --version
git --version

1.Clone the Repository
git clone https://github.com/ntabeninangamso-gif/offerzen-data-pipeline.git
cd offerzen-data-pipeline

2.Create a Python virtual environment
python -m venv venv
 
3.Activate the virtual environment

Mac / Linux
source venv/bin/activate
 
Windows
venv\Scripts\activate
 
4.Install dependencies

Install all required packages:
pip install -r requirements.txt
 
Dependencies include:
	•	pandas
	•	sqlalchemy
	•	psycopg2-binary
	•	python-dotenv
	•	requests
	•	dbt-postgres
 
5.Configure environment variables
Create a .env file in the root of the project:
 
DATABASE_URL=postgresql://postgres:password@localhost:5432/offerzen_db
 
Update the values to match your PostgreSQL configuration.
 
6.Create the PostgreSQL database

Open PostgreSQL and create the database:
CREATE DATABASE offerzen_db;
 
You can also create it via terminal:
createdb offerzen_db
 
7.Run the ingestion scripts
Load the raw CSV and API data into PostgreSQL.
Run:
python Ingestion/load_csv.py

and

python Ingestion/fetch_api_data.py
 
These scripts will populate the raw tables in PostgreSQL.
These are the tables:
jobs_current_raw
jobs_history_raw
 
8.Run dbt models
Navigate to the dbt project directory:
cd offerzen_dbt
Run dbt transformations:
dbt run

To run tests:
dbt test

These tests ensure:
• primary keys are not null
• dimension relationships are valid
• data quality rules are satisfied
 
This will create the following layers:
	•	staging
	•	marts
	•	analytics
 
9.Verify the pipeline

You can inspect the created tables in PostgreSQL:
stg_jobs_current
stg_jobs_history
stg_fact_jobs
dim_company
dim_department
dim_job
dim_location
fact_jobs
 
Analytics models include:
	•	hiring_trend
	•	job_by_location
	•	recruitment_metrics
	•	avg_time_to_fill_by_department
	•	jobs_by_department
 
Expected Project Flow
The pipeline follows this structure:
 
CSV + API Data
       ↓
Python Ingestion Layer
       ↓
PostgreSQL Raw Tables
       ↓
dbt Staging Models
       ↓
dbt Marts
       ↓
Analytics Models

10.Generate dbt Documentation
Generate project documentation and lineage:
dbt docs generate

dbt docs serve
Open the documentation in your browser to explore:
	•	model documentation
	•	column descriptions
	•	lineage graph
 
Notes

	•	The project was developed using Python 3.11, so using the same version is recommended.
	•	All file paths use cross-platform compatible paths.
	•	The setup instructions are compatible with Mac, Linux, and Windows environments.
 


Analytics Metrics explained

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

 
 
 
 


 
 
 

