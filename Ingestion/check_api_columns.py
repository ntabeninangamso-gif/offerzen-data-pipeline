import requests
import json
# Greenhouse API endpoint (hardcoded)
API_URL = "https://api.greenhouse.io/v1/boards/offerzen/jobs?content=true"
print("Fetching data from Greenhouse API...")
try:
   response = requests.get(API_URL, timeout=10)
   response.raise_for_status()
except requests.exceptions.RequestException as e:
   print(f"API request failed: {e}")
   raise
data = response.json()
# Check top-level structure
print("\nTop-level keys in response:")
print(list(data.keys()))
# Extract jobs list
jobs = data.get("jobs", [])
print(f"\nTotal jobs returned: {len(jobs)}")
if len(jobs) == 0:
   print("No jobs found.")
   exit()
# Look at the first job
first_job = jobs[0]
print("\nFields available in each job object:")
for key in first_job.keys():
   print(f"- {key}")
# Check nested location structure
if "location" in first_job:
   print("\nFields inside 'location':")
   for key in first_job["location"].keys():
       print(f"- location.{key}")
# Pretty print one full job example
print("\nExample job object:")
print(json.dumps(first_job, indent=2))