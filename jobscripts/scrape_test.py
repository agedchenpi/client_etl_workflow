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

# Capture timestamp at the start
current_time = datetime.now().strftime('%Y%m%dT%H%M%S')

# Set up logging to file
log_filename = LOG_DIR / f"scrape_test_{current_time}.log"
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

def scrape_meetmax(event_id, metadata_list, current_time):
    logging.info(f"Starting scrape for event {event_id}")
    url = f"https://www.meetmax.com/sched/event_{event_id}/__co-list_cp.html"
    page_status = "Invalid"
    status_code = None
    is_active_web_page = False
    is_invalid_event_id = False
    title = "N/A"
    result = ""
    response = None
    try:
        response = requests.get(url)
        status_code = response.status_code
    except Exception as e:
        logging.error(f"Error fetching URL for event {event_id}: {str(e)}")
        result = f"Error fetching URL for event {event_id}: {str(e)}"
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status
        })
        return result
    
    if response.status_code != 200:
        if response.status_code == 403:
            page_status = "AccessDenied"
        logging.error(f"Invalid URL or error for event {event_id} (status: {response.status_code})")
        result = f"Invalid URL or error for event {event_id} (status: {response.status_code})"
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status
        })
        return result
    
    soup = BeautifulSoup(response.text, 'html.parser')
    title = soup.title.string.strip() if soup.title else "N/A"
    
    # Check for access denied in text (even if 200)
    if "access denied" in response.text.lower():
        page_status = "AccessDenied"
        logging.info(f"Access Denied for event {event_id}")
        result = f"Access Denied for event {event_id}"
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status
        })
        return result
    
    # Check for invalid event ID
    if "Invalid Event ID" in response.text:
        is_invalid_event_id = True
        page_status = "Invalid"
        logging.info(f"Invalid Event ID for event {event_id}")
        result = f"Invalid Event ID for event {event_id}"
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status
        })
        return result
    
    # Check for no data indicator
    if "No companies found" in response.text:
        page_status = "Empty"
        logging.info(f"Valid page for event {event_id}, but no company data available.")
        result = f"Valid page for event {event_id}, but no company data available."
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status
        })
        return result
    
    # Find the main table containing company data
    table = soup.find('table')
    if not table:
        page_status = "Empty"
        logging.info(f"Valid page for event {event_id}, but no table found.")
        result = f"Valid page for event {event_id}, but no table found."
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status
        })
        return result
    
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
        page_status = "Empty"
        logging.info(f"Valid page for event {event_id}, but no company data extracted from table.")
        result = f"Valid page for event {event_id}, but no company data extracted from table."
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status
        })
        return result
    
    page_status = "Active"
    is_active_web_page = True
    # Use absolute path with timestamp
    csv_filename = str(FILE_WATCHER_DIR / f"MeetMaxEvent_{event_id}_{current_time}.csv")
    try:
        with open(csv_filename, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(['Company Name', 'Tickers'])
            for name, tickers in companies:
                writer.writerow([name, tickers])
        logging.info(f"Successfully wrote data for event {event_id} to {csv_filename}")
    except Exception as e:
        logging.error(f"Error writing CSV for event {event_id}: {str(e)}")
        result = f"Error writing CSV for event {event_id}: {str(e)}"
        metadata_list.append({
            "EventID": event_id,
            "URL": url,
            "IsActiveWebPage": is_active_web_page,
            "IsInvalidEventID": is_invalid_event_id,
            "StatusCode": status_code,
            "Title": title,
            "PageStatus": page_status
        })
        return result
    
    result = f"Companies for event {event_id} (written to {csv_filename}):\n"
    for name, tickers in companies:
        result += f"- {name}: {tickers}\n"
    
    metadata_list.append({
        "EventID": event_id,
        "URL": url,
        "IsActiveWebPage": is_active_web_page,
        "IsInvalidEventID": is_invalid_event_id,
        "StatusCode": status_code,
        "Title": title,
        "PageStatus": page_status
    })
    return result

# Proof of concept with the event IDs
event_ids = ["112573", "113453", "119243", "120103", "120097","120999"]

logging.info("Starting scrape_test.py script")

metadata_list = []

with ThreadPoolExecutor(max_workers=5) as executor:
    results = list(executor.map(lambda eid: scrape_meetmax(eid, metadata_list, current_time), event_ids))

for result in results:
    print(result)
    print("\n---\n")

# Write metadata CSV
metadata_csv = str(FILE_WATCHER_DIR / f"MeetMaxURLScan_{current_time}.csv")
try:
    with open(metadata_csv, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=["EventID", "URL", "IsActiveWebPage", "IsInvalidEventID", "StatusCode", "Title", "PageStatus"])
        writer.writeheader()
        writer.writerows(metadata_list)
    logging.info(f"Successfully wrote metadata to {metadata_csv}")
except Exception as e:
    logging.error(f"Error writing metadata CSV: {str(e)}")

logging.info("Completed scrape_test.py script")