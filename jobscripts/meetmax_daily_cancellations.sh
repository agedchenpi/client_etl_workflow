#!/bin/bash
. /home/yostfundsadmin/client_etl_workflow/env.sh
LOGFILE="/home/yostfundsadmin/client_etl_workflow/logs/meetmax_daily_cancellations_$(date +%Y%m%dT%H%M%S).log"
cd /home/yostfundsadmin/client_etl_workflow/jobscripts || { echo "Failed to cd" >> "$LOGFILE"; exit 1; }
./run_python_etl_script.sh meetmax_daily_cancellations.py >> "$LOGFILE" 2>&1
echo "Daily cancellations completed with $? at $(date)" >> "$LOGFILE"