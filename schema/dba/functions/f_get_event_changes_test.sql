CREATE OR REPLACE FUNCTION dba.f_get_event_changes_test(p_fulldate date DEFAULT NULL::date)
 RETURNS TABLE(eventid character varying, company_name text, ticker text, mindate date, maxdate date, url text, scenario text)
 LANGUAGE sql
AS $function$
WITH DateRange AS (
SELECT
COALESCE(p_fulldate, CURRENT_DATE) AS periodenddate,
(SELECT MAX(c2.fulldate)
FROM dba.tcalendardays c2
WHERE c2.fulldate <= (COALESCE(p_fulldate, CURRENT_DATE) - INTERVAL '30 days')
AND c2.isbusday = TRUE
AND c2.isholiday = FALSE
) AS periodstartdate
),
PrevBusDay AS (
SELECT MAX(c.fulldate) AS prev_bus_day
FROM dba.tcalendardays c
WHERE c.fulldate < COALESCE(p_fulldate, CURRENT_DATE)
AND c.isbusday = TRUE
AND c.isholiday = FALSE
),
EventsDataSets AS (
SELECT
t.datasetid,
t.datasetdate,
t.label AS eventid
FROM dba.tdataset t
CROSS JOIN DateRange d
WHERE t.datasettypeid = 3
AND t.isactive = TRUE
AND t.datasetdate BETWEEN d.periodstartdate AND d.periodenddate
),
EventsData AS (
SELECT
ed.eventid,
UPPER(t.company_name) as company_name,
UPPER(t.tickers) as tickers,
MIN(ed.datasetdate) AS mindate,
MAX(ed.datasetdate) AS maxdate
FROM EventsDataSets ed
JOIN public.tmeetmaxeventdata t ON t.datasetid = ed.datasetid
GROUP BY
ed.eventid,
UPPER(t.company_name),
UPPER(t.tickers)
)
SELECT
e.eventid,
e.company_name,
e.tickers,
e.mindate,
e.maxdate,
NULL AS url, -- Set to NULL since LatestURLCheckDataset is removed
x.scenario
FROM EventsData e
CROSS JOIN PrevBusDay p
LEFT JOIN LATERAL (
SELECT CASE
WHEN e.mindate = e.maxdate AND e.maxdate = COALESCE(p_fulldate, CURRENT_DATE) THEN 'added'
WHEN e.mindate = e.maxdate AND e.maxdate < p.prev_bus_day THEN 'removed-previously'
WHEN e.maxdate < p.prev_bus_day THEN 'removed-previously'
WHEN e.maxdate >= p.prev_bus_day THEN 'removed'
WHEN e.mindate <> e.maxdate AND e.maxdate = COALESCE(p_fulldate, CURRENT_DATE) THEN 'normal'
ELSE 'normal'  -- Exception: if maxdate = one business day less (i.e., >= prev_bus_day but < pdate), treat as normal
END AS scenario
) x ON TRUE
WHERE 1=1
AND x.scenario <> 'normal'
ORDER BY x.scenario asc,eventid, tickers;
$function$

