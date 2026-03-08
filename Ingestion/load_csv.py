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
print("Connecting to database...")
engine = create_engine(DATABASE_URL)
# ---------------------------------------
# Load historical CSV
# ---------------------------------------
print("Reading historical CSV file...")
df = pd.read_csv("Data/offerzen_jobs_history_raw.csv")
print(f"Rows loaded: {len(df)}")
# ---------------------------------------
# Data quality checks
# ---------------------------------------
print("Cleaning historical data...")
df = df.drop_duplicates()
if "job_id" in df.columns:
   df = df.dropna(subset=["job_id"])
print(f"Clean rows: {len(df)}")
# ---------------------------------------
# Load into PostgreSQL
# ---------------------------------------
print("Loading historical data into database...")
df.to_sql(
   name="jobs_history_raw",
   con=engine,
   if_exists="replace",
   index=False
)
print("Historical data successfully loaded")