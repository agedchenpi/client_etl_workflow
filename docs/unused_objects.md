# Unused SQL Objects Tracking

This file tracks SQL objects that are no longer used in day-to-day operations.

Last reviewed: 2026-01-09

---

## Potentially Unused Functions

| Object | Schema | Type | Reason | Date Identified | Safe to Remove? |
|--------|--------|------|--------|-----------------|-----------------|
| `f_get_event_changes_test` | dba | function | Test version, not referenced in any report | 2026-01-09 | Review needed |
| `f_get_ticker_removals_new` | dba | function | Newer version created but not used in treportmanager | 2026-01-09 | Review needed |
| `f_historical_cancellations_old` | dba | function | Old version, replaced by f_historical_cancellations | 2026-01-09 | Review needed |

---

## Deprecated But Still Running

| Object | Schema | Type | Reason | Notes |
|--------|--------|------|--------|-------|
| `f_get_ticker_removals` | dba | function | Used by Report 2, cron comment says "deprecated" | Runs at 14:31 Mon-Fri via send_reports.py 2 |

---

## Inactive Import Configs

| config_id | config_name | target_table | Reason | Date Identified |
|-----------|-------------|--------------|--------|-----------------|
| 5 | Redacted_DeaLogicCancels | public.tdealogic | is_active=0 | 2026-01-09 |

---

## Active Objects Reference

### Functions Used by Reports (treportmanager)
- `f_get_event_changes` - Report 1 (Daily Event Changes)
- `f_get_ticker_removals` - Report 2 (MultiConference Cancellation)
- `f_historical_cancellations` - Report 3 (Historical Cancellations)

### System/Utility Functions (Do Not Remove)
- `f_dataset_iu` - Dataset insert/update operations
- `fenforcesingleactivedataset` - Trigger function for tdataset
- `flogddlchanges` - DDL change logging trigger
- `f_insert_treportmanager` - Helper for inserting reports
- `f_update_treportmanager` - Helper for updating reports
- `f_insert_tscheduler` - Helper for inserting schedules
- `f_update_tscheduler` - Helper for updating schedules

### Maintenance Procedures (Run Manually/Periodically)
- `pcapturetableindexstats` - Captures table/index statistics
- `p_dataset_deactivate` - Deactivates datasets
- `pimportconfigi` - Import config insert
- `pimportconfigu` - Import config update
- `pmonitorlongrunningqueries` - Monitors long-running queries
- `ppurgeoldlogs` - Purges old log entries
- `prunmaintenancevacuumanalyze` - Runs vacuum/analyze maintenance

### Active Import Configs
- config_id 1: MeetMaxURLCheckImport
- config_id 2: MeetMax_Events_XLS_Import
- config_id 7: DealogicCancels
- config_id 8: MeetMax_URLScan_CSV_Import
- config_id 9: MeetMax_Event_CSV_Import
