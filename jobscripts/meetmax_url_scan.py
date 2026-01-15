import os
import sys
from pathlib import Path
sys.path.append('/home/yostfundsadmin/client_etl_workflow')
import time
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from systemscripts.directory_management import FILE_WATCHER_DIR, LOG_DIR, ensure_directory_exists
import requests
from bs4 import BeautifulSoup
import csv
import logging
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
import random

# Capture timestamp at the start
current_time = datetime.now().strftime('%Y%m%dT%H%M%S')

# Set up logging to file and console
log_filename = LOG_DIR / f"meetmax_url_scan_{current_time}.log"
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

# Hardcoded range of event IDs to scan
event_ids = range(115000, 145000)

# User-Agent list for rotation
USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Safari/537.36'
]


def create_session():
    """Create a requests session with retry logic."""
    session = requests.Session()
    retry = Retry(
        total=3,
        backoff_factor=2,
        status_forcelist=[429, 500, 502, 503, 504]
    )
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('http://', adapter)
    session.mount('https://', adapter)
    session.headers.update({
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    })
    return session


session = create_session()


def scan_meetmax_url(event_id, metadata_list):
    """Scan a MeetMax event URL and collect metadata (no company data extraction)."""
    time.sleep(random.uniform(5, 8))
    session.headers.update({'User-Agent': random.choice(USER_AGENTS)})
    logging.info(f"Scanning event {event_id}")

    url = f"https://www.meetmax.com/sched/event_{event_id}/__co-list_cp.html"
    page_status = "Invalid"
    status_code = None
    is_active_web_page = False
    is_invalid_event_id = False
    title = "N/A"
    num_companies = 0
    response = None

    try:
        response = session.get(url, timeout=10)
        if "rate limited" in response.text.lower() or "error 1015" in response.text.lower():
            logging.warning(f"Rate limit detected for {event_id}. Pausing 60 sec.")
            time.sleep(60)
            response = session.get(url, timeout=10)
        status_code = response.status_code
    except Exception as e:
        logging.error(f"Error fetching URL for event {event_id}: {str(e)}")
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status,
            "NumCompanies": num_companies
        })
        return

    if response.status_code != 200:
        if response.status_code == 403:
            page_status = "AccessDenied"
        logging.error(f"Invalid URL or error for event {event_id} (status: {response.status_code})")
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status,
            "NumCompanies": num_companies
        })
        return

    soup = BeautifulSoup(response.text, 'html.parser')
    title = soup.title.string.strip() if soup.title else "N/A"

    # Check for access denied in text (even if 200)
    if "access denied" in response.text.lower():
        page_status = "AccessDenied"
        logging.info(f"Access Denied for event {event_id}")
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status,
            "NumCompanies": num_companies
        })
        return

    # Check for invalid event ID
    if "Invalid Event ID" in response.text:
        is_invalid_event_id = True
        page_status = "Invalid"
        logging.info(f"Invalid Event ID for event {event_id}")
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status,
            "NumCompanies": num_companies
        })
        return

    # Check for no data indicator
    if "No companies found" in response.text:
        page_status = "Empty"
        logging.info(f"Valid page for event {event_id}, but no company data available.")
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status,
            "NumCompanies": num_companies
        })
        return

    # Find the main table to count companies
    table = soup.find('table')
    if not table:
        page_status = "Empty"
        logging.info(f"Valid page for event {event_id}, but no table found.")
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status,
            "NumCompanies": num_companies
        })
        return

    # Count rows (companies) in the table
    rows = table.find_all('tr')[1:]  # Skip header row
    num_companies = len([r for r in rows if r.find_all('td')])

    if num_companies == 0:
        page_status = "Empty"
        logging.info(f"Valid page for event {event_id}, but no company data in table.")
    else:
        page_status = "Active"
        is_active_web_page = True
        logging.info(f"Active page for event {event_id} with {num_companies} companies.")

    metadata_list.append({
        "EventID": event_id,
        "URL": url,
        "IsActiveWebPage": is_active_web_page,
        "IsInvalidEventID": is_invalid_event_id,
        "StatusCode": status_code,
        "Title": title,
        "PageStatus": page_status,
        "NumCompanies": num_companies
    })


if __name__ == "__main__":
    logging.info("Starting meetmax_url_scan.py script")
    logging.info(f"Scanning {len(event_ids)} event IDs: {event_ids.start} to {event_ids.stop - 1}")

    metadata_list = []

    with ThreadPoolExecutor(max_workers=5) as executor:
        list(executor.map(lambda eid: scan_meetmax_url(eid, metadata_list), event_ids))

    # Write metadata CSV
    metadata_csv = str(FILE_WATCHER_DIR / f"MeetMaxURLScan_{current_time}.csv")
    try:
        with open(metadata_csv, 'w', newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=["EventID", "URL", "IsActiveWebPage", "IsInvalidEventID", "StatusCode", "Title", "PageStatus", "NumCompanies"])
            writer.writeheader()
            writer.writerows(metadata_list)
        logging.info(f"Successfully wrote {len(metadata_list)} rows to {metadata_csv}")
    except Exception as e:
        logging.error(f"Error writing metadata CSV: {str(e)}")

    logging.info("Completed meetmax_url_scan.py script")
