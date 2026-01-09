# Active Processes Documentation

This document describes all active ETL processes, their schedules, dependencies, and database objects used.

Last updated: 2026-01-09

---

## Schedule Overview

| Time | Days | Job | Type |
|------|------|-----|------|
| 00:15 | Mon-Fri | MeetMax Scrape Chain | Data Import |
| 02:00 | Sunday | Weekly Cleanup | Maintenance |
| 03:00 | Daily | Database Backup | Maintenance |
| 12:15 | Mon-Fri | Gmail → Dealogic Import | Data Import |
| 14:15 | Mon-Fri | Daily MM Cancellations | Data Processing |
| 14:20 | Mon-Fri | Report 1: Daily Event Changes | Email Report |
| 14:30 | Mon-Fri | Report 3: Historical Cancellations | Email Report |
| 14:31 | Mon-Fri | Report 2: MultiConference Cancellation | Email Report (deprecated) |

---

## Process Flows

### 1. MeetMax Scrape Chain
**Schedule:** 00:15 Mon-Fri
**Script:** `meetmax_chain.sh`

```
meetmax_scrape_download.py
        │
        ▼
run_import_job.py 8 (MeetMax_URLScan_CSV_Import)
        │
        ▼
run_import_job.py 9 (MeetMax_Event_CSV_Import)
```

**Target Tables:**
- config 8 → `public.tmeetmaxurlscan`
- config 9 → `public.tmeetmaxeventdata`

---

### 2. Gmail → Dealogic Import Chain
**Schedule:** 12:15 Mon-Fri
**Cron Command:** Direct in cron file

```
run_gmail_inbox_processor.py
        │
        ▼
run_import_job.py 7 (DealogicCancels)
```

**Target Table:** `public.tdealogicevents`

---

### 3. Daily MM Cancellations
**Schedule:** 14:15 Mon-Fri
**Script:** `meetmax_daily_cancellations.sh`

```
meetmax_daily_cancellations.py
        │
        ▼
(Processes cancellation data)
```

---

## Email Reports

### Report 1: Daily Event Changes
**Schedule:** 14:20 Mon-Fri
**Report ID:** 1
**Subject:** Daily Event Changes Update
**Recipients:** marshall@yostfunds.com, ruohan@yostfunds.com

**Function:** `dba.f_get_event_changes()`

**Tables Used:**
| Table | Schema | Purpose |
|-------|--------|---------|
| tcalendardays | dba | Business day calculations |
| tdataset | dba | Dataset metadata lookup |
| tmeetmaxeventdata | public | Event data source |

---

### Report 2: MultiConference Cancellation (DEPRECATED)
**Schedule:** 14:31 Mon-Fri
**Report ID:** 2
**Subject:** MultiConference Cancellation Report - {timestamp}
**Recipients:** marshall@yostfunds.com, ruohan@yostfunds.com
**Status:** Cron comment indicates this is deprecated

**Function:** `dba.f_get_ticker_removals()`

**Tables Used:**
| Table | Schema | Purpose |
|-------|--------|---------|
| tconferenceexception | public | Conference exclusions |

**Function Dependencies:**
- Calls `dba.f_historical_cancellations()` (see Report 3 for table details)

---

### Report 3: Historical Cancellations
**Schedule:** 14:30 Mon-Fri
**Report ID:** 3
**Subject:** Historical Cancellations
**Recipients:** marshall@yostfunds.com, ruohan@yostfunds.com

**Function:** `dba.f_historical_cancellations()`

**Tables Used:**
| Table | Schema | Purpose |
|-------|--------|---------|
| thistorical_cancellations_snapshot | public | Historical snapshot data |
| ttickerexceptions | public | Ticker exclusion list |
| tdaily_cancellations_incremental | public | Daily incremental cancellations |
| tdataset | dba | Dataset metadata |
| tdealogicevents | public | Dealogic event data |

---

## Import Configurations

| Config ID | Name | Target Table | Source | Active |
|-----------|------|--------------|--------|--------|
| 1 | MeetMaxURLCheckImport | public.tmeetmaxurlcheck | MeetMax | Yes |
| 2 | MeetMax_Events_XLS_Import | public.tmeetmaxevent | MeetMax | Yes |
| 5 | Redacted_DeaLogicCancels | public.tdealogic | DeaLogic | **No** |
| 7 | DealogicCancels | public.tdealogicevents | Dealogic | Yes |
| 8 | MeetMax_URLScan_CSV_Import | public.tmeetmaxurlscan | MeetMax | Yes |
| 9 | MeetMax_Event_CSV_Import | public.tmeetmaxeventdata | MeetMax | Yes |

---

## Maintenance Jobs

### Database Backup
**Schedule:** 03:00 Daily
**Script:** `daily_backup.sh`

### Weekly Cleanup
**Schedule:** 02:00 Sunday
**Scripts:**
- `weekly_cleanup_meetmaxevents.sh`
- `weekly_cleanup_logs.sh`

---

## Database Objects Summary

### Functions Used by Reports
| Function | Used By | Status |
|----------|---------|--------|
| f_get_event_changes | Report 1 | Active |
| f_get_ticker_removals | Report 2 | Active (report deprecated) |
| f_historical_cancellations | Report 3, called by f_get_ticker_removals | Active |

### Tables Queried by Report Functions
| Table | Schema | Queried By |
|-------|--------|------------|
| tcalendardays | dba | f_get_event_changes |
| tdataset | dba | f_get_event_changes, f_historical_cancellations |
| tconferenceexception | public | f_get_ticker_removals |
| tdaily_cancellations_incremental | public | f_historical_cancellations |
| tdealogicevents | public | f_historical_cancellations |
| thistorical_cancellations_snapshot | public | f_historical_cancellations |
| tmeetmaxeventdata | public | f_get_event_changes |
| ttickerexceptions | public | f_historical_cancellations |

### Import Target Tables Only (NOT queried by reports)
| Table | Schema | Import Config | Notes |
|-------|--------|---------------|-------|
| tmeetmaxevent | public | config 2 | Was used by deprecated f_historical_cancellations_old |
| tmeetmaxurlcheck | public | config 1 | Import target only |
| tmeetmaxurlscan | public | config 8 | Import target only |
