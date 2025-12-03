#!/bin/bash
. /home/yostfundsadmin/client_etl_workflow/env.sh
LOGFILE="/home/yostfundsadmin/client_etl_workflow/logs/meetmax_scrape_import_$(date +%Y%m%dT%H%M%S).log"
cd /home/yostfundsadmin/client_etl_workflow/jobscripts || { echo "Failed to cd" >> "$LOGFILE"; exit 1; }
./run_python_etl_script.sh meetmax_scrape_download.py >> "$LOGFILE" 2>&1
echo "Scrape completed with $? at $(date)" >> "$LOGFILE"
./run_python_etl_script.sh run_import_job.py 8 >> "$LOGFILE" 2>&1
echo "Import 8 completed with $? at $(date)" >> "$LOGFILE"
./run_python_etl_script.sh run_import_job.py 9 >> "$LOGFILE" 2>&1
echo "Import 9 completed with $? at $(date)" >> "$LOGFILE"