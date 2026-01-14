# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **database-driven ETL pipeline** for a Linux homelab that automates:
- Email attachment processing via Gmail API (OAuth2)
- Web scraping (MeetMax events)
- Data transformation (XLS/XLSX to CSV)
- PostgreSQL database loading
- Automated email report distribution

**Key principle**: Pipeline behavior is controlled by PostgreSQL tables in the `dba` schema, not static config files.

## Running Scripts

**Always use the wrapper script for execution** - it handles venv activation, environment sourcing, and logging:

```bash
# Run any Python script
/bin/bash jobscripts/run_python_etl_script.sh <script_name.py> [args]

# Examples
/bin/bash jobscripts/run_python_etl_script.sh run_import_job.py 1
/bin/bash jobscripts/run_python_etl_script.sh send_reports.py 1
/bin/bash jobscripts/run_python_etl_script.sh run_gmail_inbox_processor.py

# Update cron jobs (generates local file, then manually copy to /etc/cron.d/)
/bin/bash jobscripts/run_python_etl_script.sh update_cron_jobs.py
sudo cp cron/etl_jobs /etc/cron.d/etl_jobs && sudo chown root:root /etc/cron.d/etl_jobs
```

For direct development/testing:
```bash
source env.sh && source venv/bin/activate
python jobscripts/<script>.py
```

## Architecture

### Directory Structure
- `jobscripts/` - Entry point scripts (simple CLI wrappers)
- `systemscripts/` - Core business logic modules
- `schema/` - Database schema definitions (tables, functions, procedures, triggers)
- `cron/` - Cron job configuration (reference file, manually copied to `/etc/cron.d/etl_jobs`)
- `docs/` - Documentation (unused objects tracking, etc.)
- `onboarding/sh/` - Setup scripts for new environments
- `onboarding/sql/` - Database initialization SQL
- `file_watcher/` - Staging directory for incoming files
- `archive/` - Processed files storage
- `logs/` - Log files (CSV, TXT)

### Database Configuration Tables (dba schema)
- `dba.tinboxconfig` - Email inbox processing rules
- `dba.timportconfig` - File import configurations
- `dba.treportmanager` - Email report definitions
- `dba.tscheduler` - Cron job schedules
- `dba.tlogentry` - Centralized audit logging
- `dba.tdataset` - Dataset metadata

### Data Flow
```
Gmail/Web Scraping → file_watcher/ → generic_import.py → PostgreSQL → send_reports.py → Email
```

### Key Scripts

| Script | Purpose |
|--------|---------|
| `run_python_etl_script.sh` | **Critical wrapper** - all cron jobs must use this |
| `generic_import.py` | Core ETL data loading from `dba.timportconfig` |
| `gmail_inbox_processor.py` | Gmail API interaction, rules from `dba.tinboxconfig` |
| `send_reports.py` | Report generation from `dba.treportmanager` |
| `update_cron_jobs.py` | Generates `cron/etl_jobs` from database (manually copy to `/etc/cron.d/`) |
| `xls_to_csv.py` | Excel to CSV conversion |
| `log_utils.py` | Triple-redundancy logging (CSV, TXT, PostgreSQL) |

## Database Connection

Defined in `systemscripts/db_config.py`:
- Database: `feeds`
- User: `yostfundsadmin`
- Password: from `DB_PASSWORD` env var (fallback in file)
- Host: `localhost:5432`

## Environment Variables

Set in `env.sh` (not in git):
- `ETL_EMAIL` - Gmail account
- `ETL_EMAIL_PASSWORD` - Gmail app password
- `DB_PASSWORD` - PostgreSQL password
- `PROJECT_ROOT` - Project directory path

## Logging

The `log_utils.py` module writes to three targets:
1. CSV files in `logs/` (machine-readable)
2. TXT files in `logs/` (human-readable)
3. PostgreSQL `dba.tlogentry` table

Each entry includes: `run_uuid`, `stepcounter`, `step_runtime`, `total_runtime`, `message`

## Adding New ETL Jobs

1. Add configuration row to appropriate `dba.*` table
2. (Optional) Create entry point in `jobscripts/`
3. (Optional) Add logic module in `systemscripts/`
4. Regenerate cron file and apply:
   ```bash
   /bin/bash jobscripts/run_python_etl_script.sh update_cron_jobs.py
   sudo cp cron/etl_jobs /etc/cron.d/etl_jobs && sudo chown root:root /etc/cron.d/etl_jobs
   ```

## Testing

```bash
# Test email
/bin/bash jobscripts/run_python_etl_script.sh testemail.py

# Test Gmail OAuth (generates token.json)
/bin/bash jobscripts/run_python_etl_script.sh test_oauth_gmail_headless.py

# View logs
tail -f logs/run_python_etl_script.log
```

## Scheduled Cron Jobs

The cron configuration is maintained in `cron/etl_jobs` (reference file). To apply changes, copy to `/etc/cron.d/`:
```bash
sudo cp cron/etl_jobs /etc/cron.d/etl_jobs && sudo chown root:root /etc/cron.d/etl_jobs
```

| Schedule | Job | Description |
|----------|-----|-------------|
| `20 14 * * 1-5` | `send_reports.py 1` | Report #1 (Mon-Fri 2:20 PM) |
| `30 14 * * 1-5` | `send_reports.py 3` | Historical cancellations (Mon-Fri 2:30 PM) |
| `15 12 * * 1-5` | Gmail + Import #7 | Gmail processing chain (Mon-Fri 12:15 PM) |
| `15 0 * * 1-5` | `meetmax_chain.sh` | MeetMax scrape (Mon-Fri 12:15 AM) |
| `15 14 * * 1-5` | `meetmax_daily_cancellations.sh` | Daily cancellations (Mon-Fri 2:15 PM) |
| `0 3 * * *` | `daily_backup.sh` | Database backup (Daily 3:00 AM) |
| `0 2 * * 0` | cleanup scripts | Weekly cleanup (Sunday 2:00 AM) |

## Sensitive Files (in .gitignore)
- `env.sh` - Credentials
- `systemscripts/token.json` - Gmail refresh token
- `systemscripts/credentials.json` - Google OAuth secrets
