CREATE OR REPLACE FUNCTION dba.f_historical_cancellations()
 RETURNS TABLE(source character varying, company_name character varying, ticker character varying, event_name character varying, min_date date, max_date date, cancellation_date date, status character varying, record_date date)
 LANGUAGE plpgsql
AS $function$
BEGIN
RETURN QUERY
WITH
snapshot_base AS (
    SELECT
        t.source,
        t.company_name,
        t.ticker,
        t.event_name,
        t.min_date,
        t.max_date,
        t.cancellation_date,
        t.status,
        t.snapshot_date AS record_date
    FROM public.thistorical_cancellations_snapshot t
),
snapshot_split AS (
    SELECT
        snapshot_base.source,
        snapshot_base.company_name,
        match[1]::character varying AS ticker,
        snapshot_base.event_name,
        snapshot_base.min_date,
        snapshot_base.max_date,
        snapshot_base.cancellation_date,
        snapshot_base.status,
        snapshot_base.record_date
    FROM snapshot_base
    CROSS JOIN LATERAL regexp_matches(snapshot_base.ticker, '(\d+|[A-Za-z]+)', 'g') AS match
    WHERE match[1] != ''
    AND match[1] NOT IN (SELECT tickername FROM public.ttickerexceptions)
),
incremental_base AS (
    SELECT
        dci.source,
        dci.company_name,
        dci.ticker,
        dci.event_name,
        dci.min_date,
        dci.max_date,
        dci.cancellation_date,
        dci.status,
        dci.incremental_date AS record_date
    FROM public.tdaily_cancellations_incremental dci
    JOIN dba.tdataset ds ON ds.datasetid = dci.datasetid
    WHERE ds.datasetdate >= '2025-11-12' AND ds.isactive = true
),
incremental_split AS (
    SELECT
        incremental_base.source,
        incremental_base.company_name,
        match[1]::character varying AS ticker,
        incremental_base.event_name,
        incremental_base.min_date,
        incremental_base.max_date,
        incremental_base.cancellation_date,
        incremental_base.status,
        incremental_base.record_date
    FROM incremental_base
    CROSS JOIN LATERAL regexp_matches(incremental_base.ticker, '(\d+|[A-Za-z]+)', 'g') AS match
    WHERE match[1] != ''
    AND match[1] NOT IN (SELECT UPPER(tickername) FROM public.ttickerexceptions)
),
dealogic_base AS (
    SELECT
        'Dealogic' AS source,
        t.name AS company_name,
        t.ticker,
        t.conference_title AS event_name,
        t.start_date::date AS min_date,
        t.end_date::date AS max_date,
        MIN(ds.datasetdate)::date AS cancellation_date,
        'cancelled' AS status,
        CURRENT_DATE AS record_date
    FROM
        dba.tdataset ds
    JOIN
        public.tdealogicevents t ON t.datasetid = ds.datasetid
    GROUP BY
        t.name,
        t.ticker,
        t.conference_title,
        t.start_date,
        t.end_date
),
dealogic_split AS (
    SELECT
        dealogic_base.source,
        dealogic_base.company_name,
        match[1]::character varying AS ticker,
        dealogic_base.event_name,
        dealogic_base.min_date,
        dealogic_base.max_date,
        dealogic_base.cancellation_date,
        dealogic_base.status,
        dealogic_base.record_date
    FROM dealogic_base
    CROSS JOIN LATERAL regexp_matches(dealogic_base.ticker, '(\d+|[A-Za-z]+)', 'g') AS match
    WHERE match[1] != ''
    AND match[1] NOT IN (SELECT UPPER(tickername) FROM public.ttickerexceptions)
),
unioned AS (
    SELECT * FROM snapshot_split
    UNION ALL
    SELECT * FROM incremental_split
    UNION ALL
    SELECT * FROM dealogic_split
)
SELECT *
FROM unioned
ORDER BY cancellation_date DESC;
END;
$function$

