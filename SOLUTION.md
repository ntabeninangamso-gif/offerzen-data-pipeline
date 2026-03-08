# Solution Overview

This project implements an end-to-end data pipeline that ingests job data from an external API, stores the data in PostgreSQL, transforms it using dbt, and exposes analytics-ready models for recruitment insights.

The pipeline follows a modern analytics engineering architecture consisting of the following stages:

1. Data ingestion
2. Data storage
3. Data transformation
4. Data modeling
5. Analytics layer

The goal of the project is to transform raw job data into a clean and structured analytics dataset that supports recruitment insights.

---

# Architecture

The architecture follows a typical modern data pipeline structure.

API Source  
↓  
Python Ingestion Scripts  
↓  
PostgreSQL Raw Tables  
↓  
dbt Staging Models  
↓  
dbt Dimensional Models (Star Schema)  
↓  
Analytics Models

This layered architecture separates responsibilities between ingestion, transformation, and analytics.

---

# Technology Choices

## Python
Python was used to ingest data from the external API and process the data before loading it into the database.

Python was chosen because:

- it provides strong HTTP libraries for API access
- it is commonly used in data engineering pipelines
- it integrates well with databases and ETL workflows

---

## PostgreSQL
PostgreSQL is used as the data warehouse for this project.
Reasons for choosing PostgreSQL:
- open source and lightweight
- strong SQL support
- commonly used for analytical workloads
- easy integration with dbt

The database stores both raw and transformed datasets.

---
## dbt (Data Build Tool)
dbt is used to transform raw data into structured analytical models.
dbt was chosen because it provides:
- modular SQL transformations
- version controlled data models
- automated data testing
- built-in documentation generation

dbt allows transformations to be written in SQL while maintaining a clean project structure.
--

# Pipeline Design
The pipeline consists of three main layers.

## 1. Raw Layer
The raw layer stores data exactly as it is retrieved from the API.
Tables:

- jobs_current_raw
- jobs_history_raw

These tables contain untransformed data and act as the source for downstream transformations.

---

## 2. Staging Layer

The staging layer performs data cleaning and normalization.

Models:

- stg_jobs_current
- stg_jobs_history
- stg_fact_jobs

Transformations include:

- trimming whitespace
- converting text to lowercase
- handling missing values
- standardizing column names

This layer prepares the data for dimensional modeling.

Environment Configuration
The project uses a .env file to manage environment-specific configuration variables such as the database connection string.

Instead of hardcoding credentials directly in the Python scripts, sensitive configuration values are stored in the .env file and loaded using environment variables.
example
DATABASE_URL=postgresql://postgres:password@localhost:5432/offerzen_db
The ingestion scripts load these variables using the python-dotenv library:
from dotenv import load_dotenv
import os
load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")

This approach provides several benefits:
	•	improves security by avoiding hardcoded credentials
	•	allows easy configuration across different environments
	•	simplifies deployment when running the pipeline in different environments such as development, staging, or production.

---

## 3. Data Warehouse (Dimensional Modeling)
The project implements a **star schema** to support analytical queries.

### Fact Table

fact_jobs

This table stores job events and references dimension tables through surrogate keys.

### Dimension Tables
- dim_company
- dim_department
- dim_location
- dim_job

These tables store descriptive attributes used in analytical queries.

This design improves query performance and simplifies analysis.

---

# Analytics Layer
The analytics layer provides recruitment insights using aggregated models.
Models created:

- recruitment_metrics
- jobs_by_department
- jobs_by_location
- hiring_trend
- avg_time_to_fill_by_department

These models provide insights into hiring patterns and recruitment efficiency.

Example insights include:

- number of open jobs
- hiring trends over time
- hiring distribution by department
- hiring distribution by location
- average time required to fill jobs

---
# Data Quality Testing
dbt tests were implemented to ensure data quality.

Examples include:

- not_null tests on important columns
- validation of key identifiers
- consistency checks between staging and fact tables

These tests help ensure the reliability of the analytical data.

---
# Pipeline Scheduling and Orchestration

In a production environment, the pipeline would be scheduled and orchestrated using **Apache Airflow**.

Apache Airflow is a workflow orchestration platform that allows data pipelines to be defined as Directed Acyclic Graphs (DAGs). Each step in the pipeline is represented as a task, and Airflow manages task dependencies, scheduling, monitoring, and retries.

Airflow is widely used in modern data engineering environments because it provides:

- reliable pipeline scheduling
- dependency management between tasks
- automatic retries for failed jobs
- logging and monitoring of pipeline runs
- integration with Python-based workflows

### Example Pipeline Workflow

The pipeline would typically run the following steps:

1. **Fetch API Data**  
  Execute the Python script that retrieves job data from the external API.

2. **Load Raw Data**  
  Insert the retrieved data into PostgreSQL raw tables.

3. **Run dbt Transformations**  
  Execute dbt models to transform raw data into staging, dimensional, and analytics layers.

4. **Run dbt Tests**  
  Validate data quality using dbt tests.

### Example DAG Structure
fetch_api_data  
↓  
load_raw_tables  
↓  
dbt_run  
↓  
dbt_test  

### Example Schedule

The pipeline could run daily using a cron schedule:

0 6 * * *

This means the pipeline would run **every day at 06:00 AM** to refresh the analytics models.

Airflow would also allow monitoring pipeline runs and automatically retrying failed tasks.

---
# Error Handling Strategy

The pipeline includes several mechanisms for identifying and handling failures:

- validation of API responses during ingestion
- dbt tests to detect missing or inconsistent data
- modular transformation models that isolate errors

If failures occur, dbt clearly identifies the failing model, allowing faster debugging.

---

# Trade-offs and Design Decisions

### Star Schema vs Flat Tables
A star schema was chosen instead of flat tables because it:

- reduces redundancy
- improves query performance
- simplifies analytical queries

---

### dbt vs Custom SQL Scripts
dbt was chosen because it:
- manages dependencies between models
- enables automated documentation
- simplifies testing

---

### Local Database vs Cloud Warehouse
The pipeline was implemented locally using PostgreSQL for simplicity.

However, the architecture can easily scale to cloud data warehouses such as:

- Snowflake
- BigQuery
- Amazon Redshift

---

# Future Improvements
Several improvements could further enhance the pipeline:

- deploying the pipeline in a cloud environment
- containerizing the pipeline using Docker
- orchestrating pipelines using managed Airflow services
- implementing incremental dbt models
- building dashboards using BI tools such as Power BI or Tableau
- implementing automated monitoring and alerting

---

# Conclusion
This project demonstrates a full analytics engineering workflow from raw data ingestion to analytics-ready data models.

By combining Python, PostgreSQL, and dbt, the pipeline transforms raw API data into structured datasets that support recruitment analytics and decision making.

The modular architecture ensures the pipeline can be easily extended, automated, and deployed to production environments.
 
