CREATE OR REPLACE FUNCTION dba.f_historical_cancellations_old()
 RETURNS TABLE(source text, company_name text, ticker text, event_name text, min_date date, max_date date, end_date date, cancellation_date date, status text)
 LANGUAGE sql
AS $function$
WITH SourceMaxDates AS (
SELECT
UPPER(ds.sourcename) AS sourcename,
MAX(t.datasetdate) AS overall_maxdate
FROM dba.tdataset t
JOIN dba.tdatasource ds ON ds.datasourceid = t.datasourceid
JOIN public.tmeetmaxevent mm ON mm.datasetid = t.datasetid
WHERE t.isactive = TRUE
AND UPPER(ds.sourcename) IN ('MEETMAX')
GROUP BY UPPER(ds.sourcename)
),
MeetMaxEvents AS (
SELECT
t.label AS EventID,
UPPER(COALESCE(
company_name,
"company/organization",
company_description,
"company_description_(bio)",
organization_description,
description
)) AS company_name,
UPPER(COALESCE(ticker, company_ticker)) AS ticker,
MIN(t.datasetdate) AS mindate,
MAX(t.datasetdate) AS maxdate
FROM dba.tdataset t
JOIN public.tmeetmaxevent mm ON mm.datasetid = t.datasetid
WHERE t.isactive = TRUE
GROUP BY
t.label,
UPPER(COALESCE(
company_name,
"company/organization",
company_description,
"company_description_(bio)",
organization_description,
description
)),
UPPER(COALESCE(ticker, company_ticker))
),
CombinedEvents AS (
-- Dealogic part, aggregated
SELECT
'Dealogic' AS source,
name AS company_name,
ticker,
conference_title AS event_name,
MIN(datasetdate) AS min_date,
MAX(datasetdate) AS max_date,
MAX(CASE
WHEN end_date ~ '^\d{4}-\d{1,2}-\d{1,2}$' THEN
TO_DATE(
REGEXP_REPLACE(end_date, '^(\d{4})-(\d{1,2})-(\d{1,2})$', '\1-' || LPAD('\2', 2, '0') || '-' || LPAD('\3', 2, '0')),
'YYYY-MM-DD'
)
WHEN end_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN
TO_DATE(
REGEXP_REPLACE(end_date, '^(\d{1,2})/(\d{1,2})/(\d{4})$', LPAD('\1', 2, '0') || '/' || LPAD('\2', 2, '0') || '/' || '\3'),
'MM/DD/YYYY'
)
ELSE NULL
END) AS end_date
FROM (
SELECT name, ticker, conference_title, end_date, t.datasetdate
FROM public.tdealogicevents de
JOIN dba.tdataset t ON t.datasetid = de.datasetid
WHERE t.isactive = TRUE
UNION ALL
SELECT name, ticker, conference_title, end_date, t.datasetdate
FROM public.tdealogic de
JOIN dba.tdataset t ON t.datasetid = de.datasetid
WHERE t.isactive = TRUE
) AS combined_dealogic
GROUP BY name, ticker, conference_title
UNION ALL
-- MeetMax part
SELECT
s.sourcename AS source,
e.company_name,
e.ticker,
e.EventID AS event_name,
e.mindate AS min_date,
e.maxdate AS max_date,
NULL::DATE AS end_date
FROM MeetMaxEvents e
LEFT JOIN public.tconferenceexception ce ON ce.conferencename = e.EventID
CROSS JOIN SourceMaxDates s
WHERE s.sourcename = 'MEETMAX'
AND ce.conferencename IS NULL
),
OverallMaxDates AS (
SELECT 'Dealogic' AS source, MAX(datasetdate) AS overall_maxdate
FROM (
SELECT t.datasetdate
FROM public.tdealogicevents de
JOIN dba.tdataset t ON t.datasetid = de.datasetid
WHERE t.isactive = TRUE
UNION ALL
SELECT t.datasetdate
FROM public.tdealogic de
JOIN dba.tdataset t ON t.datasetid = de.datasetid
WHERE t.isactive = TRUE
) AS dealogic_dates
UNION ALL
SELECT 'MEETMAX' AS source, MAX(t.datasetdate) AS overall_maxdate
FROM dba.tdataset t
JOIN dba.tdatasource ds ON ds.datasourceid = t.datasourceid
JOIN public.tmeetmaxevent mm ON mm.datasetid = t.datasetid
WHERE t.isactive = TRUE
AND UPPER(ds.sourcename) = 'MEETMAX'
)
SELECT
c.source,
c.company_name,
c.ticker,
c.event_name,
c.min_date,
c.max_date,
c.end_date as DealogicEndDate,
CASE
WHEN c.source = 'Dealogic' THEN c.min_date
WHEN c.source = 'MEETMAX'  THEN c.max_date
END AS cancellation_date,
CASE
WHEN c.source = 'Dealogic' THEN 'Cancelled'
WHEN c.source = 'MEETMAX' AND c.max_date < o.overall_maxdate THEN 'Cancelled'
ELSE 'Unknown'
END AS status
FROM CombinedEvents c
JOIN OverallMaxDates o ON c.source = o.source
WHERE
(c.source = 'Dealogic')  -- All Dealogic as Cancelled
OR (c.source = 'MEETMAX' AND c.max_date < o.overall_maxdate)  -- Only Cancelled for MeetMax
ORDER BY 
--cancellation date
CASE
WHEN c.source = 'Dealogic' THEN c.min_date
WHEN c.source = 'MEETMAX'  THEN c.max_date
END 
 DESC, c.event_name, c.ticker;
$function$

