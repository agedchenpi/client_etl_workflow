import sys
import os
from pathlib import Path
import uuid
import time
from datetime import datetime
import psycopg2

# Add root directory to sys.path
sys.path.append('/home/yostfundsadmin/client_etl_workflow')

from systemscripts.directory_management import LOG_DIR, ensure_directory_exists
from systemscripts.log_utils import log_message, DB_PARAMS
from systemscripts.user_utils import get_username

def run_daily_cancellations_procedure():
    script_start_time = time.time()
    run_uuid = str(uuid.uuid4())
    user = get_username()
    timestamp = datetime.now().strftime("%Y%m%dT%H%M%S")
    log_file = LOG_DIR / f"run_daily_cancellations_{timestamp}"

    try:
        ensure_directory_exists(str(LOG_DIR))
        log_message(log_file, "Initialization", f"Script started at {timestamp}", run_uuid=run_uuid, stepcounter="Initialization_0", user=user, script_start_time=script_start_time)
    except Exception as e:
        print(f"Error initializing log directory: {str(e)}")
        sys.exit(1)

    conn = None
    cur = None
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**DB_PARAMS)
        cur = conn.cursor()
        
        log_message(log_file, "Database", "Connected to database. Calling procedure p_insert_daily_cancellations.", run_uuid=run_uuid, stepcounter="Procedure_Call_0", user=user, script_start_time=script_start_time)
        
        # Call the stored procedure
        cur.callproc('public.p_insert_daily_cancellations')
        
        # Commit the transaction
        conn.commit()
        log_message(log_file, "Database", "Procedure executed successfully and changes committed.", run_uuid=run_uuid, stepcounter="Procedure_Call_1", user=user, script_start_time=script_start_time)
        
    except psycopg2.Error as e:
        log_message(log_file, "Error", f"Database error: {str(e)}", run_uuid=run_uuid, stepcounter="Procedure_Error_0", user=user, script_start_time=script_start_time)
        if conn:
            conn.rollback()
    except Exception as e:
        log_message(log_file, "Error", f"Unexpected error: {str(e)}", run_uuid=run_uuid, stepcounter="Procedure_Error_1", user=user, script_start_time=script_start_time)
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()
        log_message(log_file, "Finalization", "Database connection closed.", run_uuid=run_uuid, stepcounter="Finalization_0", user=user, script_start_time=script_start_time)

if __name__ == "__main__":
    run_daily_cancellations_procedure()