import requests
import pandas as pd
import os
from sqlalchemy import create_engine
from dotenv import load_dotenv
# ---------------------------------------
# Load environment variables
# ---------------------------------------
load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
   raise ValueError("DATABASE_URL not found in .env")
# ---------------------------------------
# API configuration
# ---------------------------------------
API_URL = "https://api.greenhouse.io/v1/boards/offerzen/jobs?content=true"
print("Connecting to database...")
engine = create_engine(DATABASE_URL)
# ---------------------------------------
# Fetch API data
# ---------------------------------------
print("Fetching data from Greenhouse API...")
try:
   response = requests.get(API_URL, timeout=10)
   response.raise_for_status()
except requests.exceptions.RequestException as e:
   print("API request failed:", e)
   raise
data = response.json()
jobs = data.get("jobs", [])
print(f"Jobs retrieved: {len(jobs)}")
# ---------------------------------------
# Transform API JSON → dataframe
# ---------------------------------------
records = []
for job in jobs:
   try:
       record = {
           "job_id": job.get("id"),
           "internal_job_id": job.get("internal_job_id"),
           "title": job.get("title"),
           "absolute_url": job.get("absolute_url"),
           "location": job.get("location", {}).get("name"),
           "company_name": job.get("company_name"),
           "updated_at": job.get("updated_at"),
           "first_published": job.get("first_published"),
           "language": job.get("language")
       }
       records.append(record)
   except Exception as e:
       print("Skipping bad record:", e)
df = pd.DataFrame(records)
# ---------------------------------------
# Data quality checks
# ---------------------------------------
print("Running data validation...")
# remove duplicates
df = df.drop_duplicates(subset=["job_id"])
# remove null IDs
df = df.dropna(subset=["job_id"])
# convert timestamps
df["updated_at"] = pd.to_datetime(df["updated_at"], errors="coerce", utc=True)
df["first_published"] = pd.to_datetime(df["first_published"], errors="coerce", utc=True)
print(f"Clean records: {len(df)}")
# ---------------------------------------
# Load into PostgreSQL
# ---------------------------------------
print("Loading API data into database...")
try:
   df.to_sql(
       name="jobs_current_raw",
       con=engine,
       if_exists="replace",
       index=False
   )
   print("API data successfully loaded")
except Exception as e:
   print("Database load failed:", e)
   raise