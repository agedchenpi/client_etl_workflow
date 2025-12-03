import os
import sys
from pathlib import Path
sys.path.append('/home/yostfundsadmin/client_etl_workflow')
import pandas as pd
import uuid
import time
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from systemscripts.user_utils import get_username
from systemscripts.log_utils import log_message
from systemscripts.directory_management import FILE_WATCHER_DIR, LOG_DIR, ensure_directory_exists
import requests
from bs4 import BeautifulSoup
import csv
import logging

# Set up logging to file
log_filename = LOG_DIR / f"scrape_test_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
logging.basicConfig(
    filename=str(log_filename),
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Call to ensure directories exist
ensure_directory_exists(str(FILE_WATCHER_DIR))
ensure_directory_exists(str(LOG_DIR))

# Variations for company and ticker columns (lowercase)
COMPANY_VARIATIONS = [
    "company name",
    "company/organization",
    "company description",
    "company description (bio)",
    "organization description",
    "description"
]
TICKER_VARIATIONS = ["ticker", "company ticker"]

def scrape_meetmax(event_id):
    logging.info(f"Starting scrape for event {event_id}")
    url = f"https://www.meetmax.com/sched/event_{event_id}/__co-list_cp.html"
    try:
        response = requests.get(url)
    except Exception as e:
        logging.error(f"Error fetching URL for event {event_id}: {str(e)}")
        return f"Error fetching URL for event {event_id}: {str(e)}"
    
    if response.status_code != 200:
        logging.error(f"Invalid URL or error for event {event_id} (status: {response.status_code})")
        return f"Invalid URL or error for event {event_id} (status: {response.status_code})"
    
    soup = BeautifulSoup(response.text, 'html.parser')
    
    # Check for no data indicator
    if "No companies found" in response.text:
        logging.info(f"Valid page for event {event_id}, but no company data available.")
        return f"Valid page for event {event_id}, but no company data available."
    
    # Find the main table containing company data
    table = soup.find('table')
    if not table:
        logging.info(f"Valid page for event {event_id}, but no table found.")
        return f"Valid page for event {event_id}, but no table found."
    
    # Get headers
    header_row = table.find('tr')
    if header_row:
        headers = [th.text.strip() for th in header_row.find_all('th')]
        headers_lower = [h.lower() for h in headers]
    else:
        headers = []
        headers_lower = []
    
    # Find column indices
    company_idx = next((i for i, h in enumerate(headers_lower) if h in COMPANY_VARIATIONS), 0)
    ticker_idx = next((i for i, h in enumerate(headers_lower) if h in TICKER_VARIATIONS), -1)
    
    companies = []
    rows = table.find_all('tr')[1:]  # Skip header row
    
    for row in rows:
        cells = row.find_all('td')
        if len(cells) < 1:
            continue
        
        # Get company name
        company = cells[company_idx].text.strip() if len(cells) > company_idx else ""
        
        # Get ticker if column exists
        if ticker_idx != -1 and len(cells) > ticker_idx:
            ticker = cells[ticker_idx].text.strip()
        else:
            ticker = "N/A"
        
        # Handle private or empty ticker
        if "private" in ticker.lower():
            ticker = "Private (No Ticker)"
        elif not ticker:
            ticker = "N/A"
        
        # Clean company name if no ticker column (likely attendees appended)
        if ticker_idx == -1 and ':' in company:
            company = company.split(':', 1)[0].strip()
        
        # Skip if company is empty or appears to be a non-company (e.g., KOL panel)
        if not company or company.startswith("** KOL"):
            continue
        
        companies.append((company, ticker))
    
    if not companies:
        logging.info(f"Valid page for event {event_id}, but no company data extracted from table.")
        return f"Valid page for event {event_id}, but no company data extracted from table."
    
    # Use absolute path
    csv_filename = str(FILE_WATCHER_DIR / f"event_{event_id}_companies.csv")
    try:
        with open(csv_filename, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['Company Name', 'Tickers'])
            for name, tickers in companies:
                writer.writerow([name, tickers])
        logging.info(f"Successfully wrote data for event {event_id} to {csv_filename}")
    except Exception as e:
        logging.error(f"Error writing CSV for event {event_id}: {str(e)}")
        return f"Error writing CSV for event {event_id}: {str(e)}"
    
    result = f"Companies for event {event_id} (written to {csv_filename}):\n"
    for name, tickers in companies:
        result += f"- {name}: {tickers}\n"
    
    return result

# Proof of concept with the event IDs
event_ids = ["112573", "113453", "119243", "120103", "120097"]

logging.info("Starting scrape_test.py script")

with ThreadPoolExecutor(max_workers=5) as executor:
    results = list(executor.map(scrape_meetmax, event_ids))

for result in results:
    print(result)
    print("\n---\n")

logging.info("Completed scrape_test.py script")