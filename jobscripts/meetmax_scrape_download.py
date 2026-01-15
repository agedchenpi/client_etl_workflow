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
from systemscripts.db_config import DB_PARAMS
import psycopg2
import requests
from bs4 import BeautifulSoup
import csv
import logging
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
import random  # For random delays and UA rotation

# Capture timestamp at the start
current_time = datetime.now().strftime('%Y%m%dT%H%M%S')

# Set up logging to file and console
log_filename = LOG_DIR / f"meetmax_scrape_download_{current_time}.log"
file_handler = logging.FileHandler(str(log_filename))
console_handler = logging.StreamHandler()
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[file_handler, console_handler]
)

# Call to ensure directories exist
ensure_directory_exists(str(FILE_WATCHER_DIR))
ensure_directory_exists(str(LOG_DIR))


def get_valid_event_ids():
    """
    Fetch valid event IDs from the database based on the most recent MeetMaxURLScan dataset.
    Returns a list of event IDs that are valid and have active web pages.
    """
    query = """
    SELECT t.eventid
    FROM public.tmeetmaxurlscan t
    LEFT JOIN public.tconferenceexception t2 ON t2.conferencename = t.eventid
    WHERE UPPER(t.isinvalideventid) = 'FALSE'
        AND UPPER(t.isactivewebpage) = 'TRUE'
        AND t.datasetid = (
            SELECT MAX(ds.datasetid)
            FROM dba.tdataset ds
            WHERE ds.label = 'MeetMaxURLScan'
                AND ds.isactive = TRUE
                AND ds.effthrudate = '9999-01-01 00:00:00'::timestamp
        )
        AND t2.conferencename IS NULL
    ORDER BY t.eventid;
    """
    try:
        conn = psycopg2.connect(**DB_PARAMS)
        cursor = conn.cursor()
        cursor.execute(query)
        rows = cursor.fetchall()
        cursor.close()
        conn.close()
        event_ids = [int(row[0]) for row in rows]
        logging.info(f"Fetched {len(event_ids)} valid event IDs from database")
        return event_ids
    except Exception as e:
        logging.error(f"Failed to fetch event IDs from database: {str(e)}")
        return []


# Fetch valid event IDs from database
event_ids = get_valid_event_ids()
if not event_ids:
    logging.error("No valid event IDs found. Exiting.")
    sys.exit(1)




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
# Add User-Agent list for rotation
USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Safari/537.36'
]
# Enhanced session with retries and headers
def create_session():
    session = requests.Session()
    retry = Retry(
        total=3,  # Retry up to 3 times
        backoff_factor=2,  # Wait 1s, 2s, 4s between retries
        status_forcelist=[429, 500, 502, 503, 504]  # Retry on these status codes
    )
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('http://', adapter)
    session.mount('https://', adapter)
    session.headers.update({
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    })
    return session

session = create_session()

def scrape_meetmax(event_id, current_time):
    """Scrape company data from a MeetMax event page."""
    time.sleep(random.uniform(5, 8))
    session.headers.update({'User-Agent': random.choice(USER_AGENTS)})
    logging.info(f"Starting scrape for event {event_id}")
    url = f"https://www.meetmax.com/sched/event_{event_id}/__co-list_cp.html"
    response = None

    try:
        response = session.get(url, timeout=10)
        if "rate limited" in response.text.lower() or "error 1015" in response.text.lower():
            logging.warning(f"Rate limit detected for {event_id}. Pausing 60 sec.")
            time.sleep(60)
            response = session.get(url, timeout=10)
    except Exception as e:
        logging.error(f"Error fetching URL for event {event_id}: {str(e)}")
        return None

    if response.status_code != 200:
        logging.error(f"Invalid URL or error for event {event_id} (status: {response.status_code})")
        return None

    soup = BeautifulSoup(response.text, 'html.parser')

    # Check for access denied in text (even if 200)
    if "access denied" in response.text.lower():
        logging.info(f"Access Denied for event {event_id}")
        return None

    # Check for invalid event ID
    if "Invalid Event ID" in response.text:
        logging.info(f"Invalid Event ID for event {event_id}")
        return None

    # Check for no data indicator
    if "No companies found" in response.text:
        logging.info(f"Valid page for event {event_id}, but no company data available.")
        return None

    # Find the main table containing company data
    table = soup.find('table')
    if not table:
        logging.info(f"Valid page for event {event_id}, but no table found.")
        return None
    
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
        return None

    # Write company data to CSV
    csv_filename = str(FILE_WATCHER_DIR / f"MeetMaxEvent_{event_id}_{current_time}.csv")
    try:
        with open(csv_filename, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['Company Name', 'Tickers'])
            for name, tickers in companies:
                writer.writerow([name, tickers])
        logging.info(f"Successfully wrote {len(companies)} companies for event {event_id} to {csv_filename}")
    except Exception as e:
        logging.error(f"Error writing CSV for event {event_id}: {str(e)}")
        return None

    return csv_filename

logging.info("Starting meetmax_scrape_download.py script")
logging.info(f"Processing {len(event_ids)} event IDs from database")

with ThreadPoolExecutor(max_workers=5) as executor:
    results = list(executor.map(lambda eid: scrape_meetmax(eid, current_time), event_ids))

successful = sum(1 for r in results if r is not None)
logging.info(f"Completed: {successful}/{len(event_ids)} events had company data written")
logging.info("Completed meetmax_scrape_download.py script")