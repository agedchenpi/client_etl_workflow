import sys
import time
import glob
import re
from pathlib import Path
from datetime import datetime

# Extend sys.path
sys.path.append('/home/yostfundsadmin/client_etl_workflow')

from systemscripts.directory_management import FILE_WATCHER_DIR

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.service import Service
from webdriver_manager.firefox import GeckoDriverManager
from selenium.webdriver.firefox.options import Options

print("Starting script setup...")

# ---------------------------------------------------------
# Setup download directory
# ---------------------------------------------------------
print("Setting up download directory...")
DOWNLOAD_DIR = FILE_WATCHER_DIR
DOWNLOAD_DIR.mkdir(parents=True, exist_ok=True)
print(f"Download dir set to: {DOWNLOAD_DIR}")

# ---------------------------------------------------------
# Configure Firefox
# ---------------------------------------------------------
print("Configuring Firefox options...")
options = Options()
options.add_argument("--headless")
options.set_preference("browser.download.folderList", 2)
options.set_preference("browser.download.dir", str(DOWNLOAD_DIR))
options.set_preference("browser.download.manager.showWhenStarting", False)
options.set_preference(
    "browser.helperApps.neverAsk.saveToDisk",
    "text/csv,application/vnd.ms-excel"
)
print("Options configured.")

# ---------------------------------------------------------
# URL + eventID extraction
# ---------------------------------------------------------
url = "https://www.meetmax.com/sched/event_119243/__co-list_cp.html"

print("Extracting event ID from URL...")
event_id_match = re.search(r'event_(\d+)', url)
event_id = event_id_match.group(1) if event_id_match else "unknown"
print(f"Extracted eventID: {event_id}")

timestamp = datetime.now().strftime("%Y%m%dT%H%M%S")

# Corrected filename format: timestamp_meetmax_eventid.xls
expected_filename = f"{timestamp}_meetmax_{event_id}.xls"
print(f"Expected output filename: {expected_filename}")

# ---------------------------------------------------------
# Browser automation + download logic
# ---------------------------------------------------------
try:
    print("Initializing GeckoDriver service...")
    service = Service(GeckoDriverManager().install())
    print("Service initialized.")

    print("Launching Firefox driver...")
    driver = webdriver.Firefox(service=service, options=options)
    print("Driver launched.")

    print("Navigating to URL...")
    driver.get(url)
    print("URL loaded. Page title:", driver.title)

    print("Waiting for export button...")
    wait = WebDriverWait(driver, 30)
    button = wait.until(EC.element_to_be_clickable((By.ID, "export")))
    print("Button located.")

    print("Clicking button...")
    button.click()
    print("Button clicked; waiting for download...")

    start_time = time.time()
    poll_count = 0

    while time.time() - start_time < 60:
        poll_count += 1
        print(f"Poll attempt {poll_count}: Checking for files...")

        # Broad glob (xls or csv or partial temp files)
        downloaded_files = glob.glob(str(DOWNLOAD_DIR / "*"))
        print(f"Files found in dir: {downloaded_files}")

        if downloaded_files:
            downloaded_file = Path(downloaded_files[0])
            print(f"Download detected: {downloaded_file}")

            output_file = DOWNLOAD_DIR / expected_filename
            downloaded_file.rename(output_file)

            print(f"Renamed to: {output_file}")
            break

        print("No file yet; sleeping...")
        time.sleep(2)

    else:
        print("Download timed out; no file found.")

    print("Final dir contents:", os.listdir(DOWNLOAD_DIR))

except Exception as e:
    print(f"Error during execution: {str(e)}")

finally:
    if 'driver' in locals():
        print("Quitting driver...")
        driver.quit()
    else:
        print("No driver to quit.")

print("Script completed.")
