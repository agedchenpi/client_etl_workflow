import sys
import os
import psycopg2
# Add root directory to sys.path
sys.path.append('/home/yostfundsadmin/client_etl_workflow')
import pandas as pd
import uuid
import time
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from systemscripts.user_utils import get_username
from systemscripts.log_utils import log_message
from systemscripts.directory_management import FILE_WATCHER_DIR, LOG_DIR, ensure_directory_exists
from systemscripts.db_config import DB_PARAMS
import grp
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.service import Service
from webdriver_manager.firefox import GeckoDriverManager
from selenium.webdriver.firefox.options import Options
import glob
import re
from selenium.common.exceptions import TimeoutException

# Configuration
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
MAX_RETRIES = 2
INITIAL_DELAY = 15.0
TASK_SUBMISSION_DELAY = 5.0
MAX_WORKERS = 1

ensure_directory_exists(FILE_WATCHER_DIR)
ensure_directory_exists(LOG_DIR)

def fetch_url_data(log_file, run_uuid, user, script_start_time):
    """Fetch URL data from public.tmeetmaxurlcheck and dba.tdataset for the most recent datasetdate."""
    try:
        with psycopg2.connect(**DB_PARAMS) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    WITH MaxURLCheckDate AS (
                        SELECT MAX(t.datasetdate) AS maxdatasetdate 
                        FROM dba.tdataset t 
                        WHERE t.isactive = TRUE AND t.datasettypeid = 2
                    ),
                    LatestURLCheckDataset AS (
                        SELECT DISTINCT mm.eventid,
                            mm.isdownloadable,
                            mm.downloadlink,
                            ds.isactive,
                            mu.maxdatasetdate 
                        FROM public.tmeetmaxurlcheck mm 
                        JOIN dba.tdataset ds ON ds.datasetid = mm.datasetid 
                        CROSS JOIN MaxURLCheckDate mu 
                        WHERE ds.isactive = TRUE AND mm.isdownloadable = '1'
                            AND ds.datasetdate = mu.maxdatasetdate
                    ) 
                    SELECT eventid, isdownloadable, downloadlink, isactive, maxdatasetdate 
                    FROM LatestURLCheckDataset 
                    ORDER BY eventid;
                """)
                rows = cur.fetchall()
                columns = ['EventID', 'IsDownloadable', 'DownloadLink', 'IsActive', 'MaxDatasetDate']
                df = pd.DataFrame(rows, columns=columns)
                df['IsDownloadable'] = df['IsDownloadable'].astype(int)
                df['IsActive'] = df['IsActive'].astype(int)
                log_message(log_file, "DataFetch", f"Fetched {len(df)} rows from database",
                            run_uuid=run_uuid, stepcounter="DataFetch_0", user=user, script_start_time=script_start_time)
                if len(df) == 0:
                    log_message(log_file, "Warning", "No downloadable URLs found for the most recent datasetdate",
                                run_uuid=run_uuid, stepcounter="DataFetch_1", user=user, script_start_time=script_start_time)
                else:
                    log_message(log_file, "Debug", f"MaxDatasetDate: {df['MaxDatasetDate'].iloc[0]}",
                                run_uuid=run_uuid, stepcounter="DataFetch_1", user=user, script_start_time=script_start_time)
                    log_message(log_file, "Debug", f"DataFrame columns: {df.columns.tolist()}",
                                run_uuid=run_uuid, stepcounter="DataFetch_2", user=user, script_start_time=script_start_time)
                    log_message(log_file, "Debug", f"IsDownloadable values: {df['IsDownloadable'].value_counts().to_dict()}",
                                run_uuid=run_uuid, stepcounter="DataFetch_3", user=user, script_start_time=script_start_time)
                    log_message(log_file, "Debug", f"DataFrame dtypes: {df.dtypes.to_dict()}",
                                run_uuid=run_uuid, stepcounter="DataFetch_4", user=user, script_start_time=script_start_time)
                return df
    except psycopg2.Error as e:
        log_message(log_file, "Error", f"Database error: {str(e)}",
                    run_uuid=run_uuid, stepcounter="DataFetch_5", user=user, script_start_time=script_start_time)
        return None
    except Exception as e:
        log_message(log_file, "Error", f"Unexpected error: {str(e)}",
                    run_uuid=run_uuid, stepcounter="DataFetch_6", user=user, script_start_time=script_start_time)
        return None

def download_file(event_id, download_url, log_file, run_uuid, user, script_start_time, timestamp):
    """Download an XLS file using Selenium."""
    result = {
        "EventID": event_id,
        "DownloadURL": download_url,
        "Status": "Failed"
    }
    log_message(log_file, "Download", f"Starting download for EventID {event_id} from {download_url}",
                run_uuid=run_uuid, stepcounter=f"download_{event_id}", user=user, script_start_time=script_start_time)
    options = Options()
    options.add_argument("--headless")
    options.add_argument(f"--user-agent={USER_AGENT}")
    options.add_argument("--disable-blink-features=AutomationControlled")
    options.add_argument("--no-sandbox")
    options.set_preference("browser.download.folderList", 2)
    options.set_preference("browser.download.dir", str(FILE_WATCHER_DIR))
    options.set_preference("browser.download.manager.showWhenStarting", False)
    options.set_preference("browser.helperApps.neverAsk.saveToDisk", "text/csv,application/vnd.ms-excel,application/octet-stream,application/csv,text/comma-separated-values")
    try:
        service = Service(GeckoDriverManager().install())
        driver = webdriver.Firefox(service=service, options=options)
        driver.get(download_url)
        log_message(log_file, "Debug", f"Page title after load: {driver.title}", run_uuid=run_uuid, stepcounter=f"download_{event_id}_page", user=user, script_start_time=script_start_time)
        page_source = driver.page_source
        has_companies = "No companies found" not in page_source
        log_message(log_file, "Debug", f"Has companies data: {has_companies}", run_uuid=run_uuid, stepcounter=f"download_{event_id}_content", user=user, script_start_time=script_start_time)
        wait = WebDriverWait(driver, 30)
        try:
            initial_files = set(glob.glob(str(FILE_WATCHER_DIR / '*')))
            log_message(log_file, "Debug", f"Initial files: {list(initial_files)}", run_uuid=run_uuid, stepcounter=f"download_{event_id}_initial", user=user, script_start_time=script_start_time)
            button = wait.until(EC.element_to_be_clickable((By.LINK_TEXT, "Download Company List")))
            button.click()
            start_time = time.time()
            poll_count = 0
            while time.time() - start_time < 90:
                poll_count += 1
                current_files = set(glob.glob(str(FILE_WATCHER_DIR / '*')))
                log_message(log_file, "Debug", f"Poll {poll_count}: Current files: {list(current_files)}", run_uuid=run_uuid, stepcounter=f"download_{event_id}_poll", user=user, script_start_time=script_start_time)
                downloaded_files = current_files - initial_files
                if downloaded_files:
                    downloaded_file = Path(list(downloaded_files)[0])
                    output_file = FILE_WATCHER_DIR / f"{timestamp}_MeetMax_{event_id}.xls"
                    downloaded_file.rename(output_file)
                    log_message(log_file, "Download", f"Downloaded and renamed to {output_file}",
                                run_uuid=run_uuid, stepcounter=f"download_{event_id}", user=user, script_start_time=script_start_time)
                    result["Status"] = "Success"
                    break
                time.sleep(1)
            else:
                raise TimeoutError("Download timed out")
                log_message(log_file, "Debug", f"Dir contents after timeout: {os.listdir(FILE_WATCHER_DIR)}", run_uuid=run_uuid, stepcounter=f"download_{event_id}_timeout", user=user, script_start_time=script_start_time)
            os.chmod(output_file, 0o660)
            try:
                group_id = grp.getgrnam('etl_group').gr_gid
                os.chown(output_file, os.getuid(), group_id)
            except KeyError:
                log_message(log_file, "Warning", f"Group 'etl_group' not found; skipping chown for {output_file}",
                            run_uuid=run_uuid, stepcounter=f"download_{event_id}_chown", user=user, script_start_time=script_start_time)
        except TimeoutException:
            log_message(log_file, "Warning", f"No download link found for EventID {event_id} - likely no data", run_uuid=run_uuid, stepcounter=f"download_{event_id}_nodata", user=user, script_start_time=script_start_time)
            result["Status"] = "NoData"
    except Exception as e:
        log_message(log_file, "Error", f"Error for EventID {event_id}: {str(e)}",
                    run_uuid=run_uuid, stepcounter=f"download_{event_id}", user=user, script_start_time=script_start_time)
    finally:
        if 'driver' in locals():
            driver.quit()
    return result

def meetmax_url_download():
    """Download XLS files from MeetMax URLs."""
    script_start_time = time.time()
    run_uuid = str(uuid.uuid4())
    user = get_username()
    timestamp = datetime.now().strftime("%Y%m%dT%H%M%S")
    log_file = LOG_DIR / f"meetmax_url_download_{timestamp}.log"
    results_file = FILE_WATCHER_DIR / f"{timestamp}_meetmax_url_download_results.csv"
    log_message(log_file, "Initialization", f"Script started at {timestamp}",
                run_uuid=run_uuid, stepcounter="Initialization_0", user=user, script_start_time=script_start_time)
    log_message(log_file, "Initialization", f"Results CSV path: {results_file}",
                run_uuid=run_uuid, stepcounter="Initialization_1", user=user, script_start_time=script_start_time)
    
    # Hardcode for testing single eventID 119243
    downloadable = pd.DataFrame([
        {
            'EventID': 119243,
            'DownloadLink': 'https://www.meetmax.com/sched/event_119243/__co-list_cp.html',
            'IsDownloadable': 1,  # Assume downloadable for test
            'IsActive': 1         # Assume active for test
        }
    ])
    log_message(log_file, "TestMode", "Hardcoded single eventID 119243 for testing",
                run_uuid=run_uuid, stepcounter="TestMode_0", user=user, script_start_time=script_start_time)
    
    results = []
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = []
        for _, row in downloadable.iterrows():
            event_id = row["EventID"]
            download_url = row["DownloadLink"]
            futures.append(executor.submit(download_file, event_id, download_url, log_file, run_uuid, user, script_start_time, timestamp))
            time.sleep(TASK_SUBMISSION_DELAY)
        for future in futures:
            result = future.result()
            results.append(result)
            log_message(log_file, "Processing", f"Completed EventID {result['EventID']}, Status: {result['Status']}",
                        run_uuid=run_uuid, stepcounter=f"result_{result['EventID']}", user=user, script_start_time=script_start_time)
    # Save results
    if results:
        results_df = pd.DataFrame(results)
        results_df.to_csv(results_file, index=False)
        os.chmod(results_file, 0o660)
        try:
            group_id = grp.getgrnam('etl_group').gr_gid
            os.chown(results_file, os.getuid(), group_id)
        except KeyError:
            log_message(log_file, "Warning", f"Group 'etl_group' not found; skipping chown for {results_file}",
                        run_uuid=run_uuid, stepcounter="FinalSave_chown", user=user, script_start_time=script_start_time)
        log_message(log_file, "FinalSave", f"Saved {len(results)} rows to {results_file}",
                    run_uuid=run_uuid, stepcounter="FinalSave_0", user=user, script_start_time=script_start_time)
    else:
        log_message(log_file, "FinalSave", "No results to save",
                    run_uuid=run_uuid, stepcounter="FinalSave_1", user=user, script_start_time=script_start_time)
    log_message(log_file, "Finalization", f"Script completed, processed {len(results)} events",
                run_uuid=run_uuid, stepcounter="Finalization_0", user=user, script_start_time=script_start_time)

if __name__ == "__main__":
    meetmax_url_download()