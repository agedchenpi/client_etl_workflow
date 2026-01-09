CREATE OR REPLACE PROCEDURE public.p_insert_daily_cancellations(IN p_date date DEFAULT CURRENT_DATE)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_datasetid INT;
    v_user VARCHAR := COALESCE(CURRENT_USER, 'yostfundsadmin');
    v_removed RECORD;
BEGIN
    -- Create new dataset
    v_datasetid := dba.f_dataset_iu(
        NULL,
        p_date,
        'Metadata',
        'MeetMax',
        'IncrementalCancellation',
        'Active',
        v_user
    );

    -- Insert removed events from f_get_event_changes
    FOR v_removed IN
        SELECT *
        FROM dba.f_get_event_changes(p_date)
        WHERE scenario = 'removed'
    LOOP
        INSERT INTO public.tdaily_cancellations_incremental (
            datasetid,
            source,
            company_name,
            ticker,
            event_name,
            min_date,
            max_date,
            cancellation_date,
            status
        ) VALUES (
            v_datasetid,
            'MeetMax',
            v_removed.company_name,
            v_removed.ticker,
            v_removed.eventid,
            v_removed.mindate,
            v_removed.maxdate,
            p_date,
            'Cancelled'
        );
    END LOOP;

    RAISE NOTICE 'Inserted daily cancellations with datasetid %', v_datasetid;
END;
$procedure$

