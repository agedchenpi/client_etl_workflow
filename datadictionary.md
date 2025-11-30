# ETL Pipeline Scripts and Database Tables Data Dictionary

This data dictionary provides an overview of the scripts and key PostgreSQL tables in the ETL pipeline project. The pipeline uses Python and Bash on Linux Mint, focusing on scraping, conversion, processing, database loading, and reporting.

## Scripts Overview
Entries are organized alphabetically by script name. Each includes purpose, key functionalities, inputs, and outputs.

### directory_management.py
- **Purpose**: Manages directory creation, cleanup, and file organization for ETL structure.
- **Key Functionalities**: Creates directories; removes temporary files; verifies paths.
- **Inputs**: Path configurations from environment or files; file lists for cleanup.
- **Outputs**: Managed directories; status logs.

### generic_import.py
- **Purpose**: Loads CSV data into PostgreSQL for ETL import.
- **Key Functionalities**: Reads CSVs; validates/transforms with pandas; inserts/updates records; batch processing.
- **Inputs**: CSV paths; DB connection from dba.tinboxconfig.
- **Outputs**: Updated tables; import status (rows, errors).

### install_dependencies.sh
- **Purpose**: Installs packages for ETL environment setup.
- **Key Functionalities**: Updates lists; installs Python, pip, PostgreSQL client, pandas, openpyxl, psycopg2, Scrapy.
- **Inputs**: None; optional flags.
- **Outputs**: Installed packages; status log.

### log_utils.py
- **Purpose**: Centralized logging for ETL tracking.
- **Key Functionalities**: Initializes loggers; supports levels; writes to file/console; formats with timestamps.
- **Inputs**: Messages; optional log path.
- **Outputs**: Log files (e.g., etl.log).

### meetmax_url_check.py
- **Purpose**: Checks URLs for new content, outputs downloadable links CSV.
- **Key Functionalities**: HTTP requests; parses links; filters by type/date; CSV output.
- **Inputs**: URLs from config/DB; user agent.
- **Outputs**: url_check_results.csv (URL, Status, IsDownloadable).

### meetmax_url_download.py
- **Purpose**: Downloads files from identified URLs.
- **Key Functionalities**: Reads check CSV; downloads with retries; saves files; updates status.
- **Inputs**: CSV from checks; download paths.
- **Outputs**: Downloaded .xls; status CSV.

### run_python_etl_script.sh
- **Purpose**: Orchestrates ETL pipeline sequence.
- **Key Functionalities**: Sets variables; calls scripts in order; email reports.
- **Inputs**: None; optional params.
- **Outputs**: Logs; notifications.

### user_utils.py
- **Purpose**: Handles user configs and utilities.
- **Key Functionalities**: Manages credentials; fetches settings; supports secure exchanges.
- **Inputs**: User IDs; config queries.
- **Outputs**: Configs or sessions.

### xls_to_csv.py
- **Purpose**: Converts XLS/XLSX to CSV.
- **Key Functionalities**: Reads Excel; handles sheets; data cleaning; CSV write.
- **Inputs**: XLS paths.
- **Outputs**: CSVs for import.

## Database Tables Overview
Entries are organized alphabetically by schema-qualified table name. Each includes purpose, key columns (inferred based on script interactions), and usage in the pipeline. Tables support configuration, data storage, and history tracking for modularity and dynamic processing.

### dba.tdataset
- **Purpose**: Tracks dataset metadata, such as processing history and dates, to enable incremental loads and avoid duplicates.
- **Key Columns**: dataset_id (primary key), source (e.g., 'meetmax'), datasetdate (timestamp), status, file_path.
- **Usage**: Queried in meetmax_url_check.py for historical max dates; updated post-import in generic_import.py; helps scripts like run_python_etl_script.sh determine if new data exists.

### dba.tinboxconfig
- **Purpose**: Stores centralized configurations for the pipeline, allowing dynamic updates without code changes (e.g., paths, URLs, import settings).
- **Key Columns**: key (unique identifier, e.g., 'import_settings'), value (config data, JSON or string), user_id (for client-specific), active (boolean).
- **Usage**: Fetched in most scripts (e.g., generic_import.py for DB connections, meetmax_url_check.py for URLs); drives automation in run_python_etl_script.sh; supports email and scraping params.

### public.tmeetmaxevent
- **Purpose**: Holds processed event data from MeetMax sources, serving as the main analytical table post-ETL.
- **Key Columns**: event_id (primary key), company_name, event_date, attendees, other scraped fields (e.g., location, status).
- **Usage**: Loaded via generic_import.py after CSV conversion; queried for reports or notifications; integrated with tdataset for versioning.

### public.tmeetmaxurlcheck
- **Purpose**: Logs URL check results to track downloadable content and statuses for auditing and retries.
- **Key Columns**: url_id (primary key), url, status (e.g., '200'), is_downloadable (boolean), check_date, dataset_id (foreign key to tdataset).
- **Usage**: Populated by meetmax_url_check.py; queried in meetmax_url_download.py for filtering; aids debugging in log_utils.py integrations.


## Cron Job Configuration
This section explains the cron table used for scheduling the ETL pipeline on Linux Mint. Cron is a time-based job scheduler that automates recurring tasks, such as weekly runs of the pipeline.

- **Purpose**: Automates execution of run_python_etl_script.sh at regular intervals to ensure timely data processing and reporting without manual intervention.
- **Key Details**: Configured via the user's crontab file; runs the Bash script weekly; logs output for monitoring.
- **Example Crontab Entry**: `0 2 * * 0 /path/to/run_python_etl_script.sh >> /path/to/etl_cron.log 2>&1`  
  (This runs every Sunday at 2:00 AM; redirects stdout and stderr to a log file.)
- **Setup**: Use the command `crontab -e` to edit the crontab; insert the entry with absolute paths to the script and log file; save and exit to activate.
- **Usage Notes**: Frequency can be adjusted (e.g., daily: `0 2 * * *`); monitor the log file for errors; dynamic scheduling params (e.g., alternative frequencies) can be stored in dba.tinboxconfig for script-level checks; ensure the cron daemon is running (`systemctl status cron`).