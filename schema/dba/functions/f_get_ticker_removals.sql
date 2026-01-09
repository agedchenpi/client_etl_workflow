CREATE OR REPLACE FUNCTION dba.f_get_ticker_removals(p_fulldate date DEFAULT CURRENT_DATE, p_date_offset integer DEFAULT 31)
 RETURNS TABLE(source text, ticker text, ticker_raw text, eventid character varying, company_name text, add_date date, removal_date date, url text, event_count bigint)
 LANGUAGE sql
AS $function$
WITH DateRange AS (
    SELECT
        p_fulldate - p_date_offset AS periodstartdate,
        p_fulldate AS periodenddate
),
cancellations AS (
    SELECT *
    FROM dba.f_historical_cancellations()
),
filtered AS (
    SELECT *
    FROM cancellations
    WHERE cancellation_date BETWEEN (SELECT periodstartdate FROM DateRange) AND (SELECT periodenddate FROM DateRange)
    AND LOWER(status) = 'cancelled'
    AND ticker != ''
),
RemovedTickers AS (
    SELECT
        f.source,
        f.ticker,
        f.ticker AS ticker_raw,
        f.event_name AS eventid,
        f.company_name,
        f.min_date AS add_date,
        f.cancellation_date AS removal_date,
        CASE
            WHEN f.source = 'MeetMax' THEN 'https://meetmax.com/sched/event_' || f.event_name || '/__co-list_cp.html'
            ELSE ''
        END AS url
    FROM filtered f
    LEFT JOIN public.tConferenceException ce ON f.event_name = ce.ConferenceName
    WHERE ce.ConferenceExceptionID IS NULL
),
TickerEventCounts AS (
    SELECT
        ticker,
        COUNT(DISTINCT eventid) AS event_count
    FROM RemovedTickers
    GROUP BY ticker
    HAVING COUNT(DISTINCT eventid) > 1
)
SELECT
    rt.source,
    rt.ticker,
    rt.ticker_raw,
    rt.eventid,
    rt.company_name,
    rt.add_date,
    rt.removal_date,
    rt.url,
    tec.event_count
FROM RemovedTickers rt
JOIN TickerEventCounts tec ON rt.ticker = tec.ticker
ORDER BY
    rt.source ASC, tec.event_count DESC, rt.ticker, rt.eventid, rt.removal_date;
$function$

