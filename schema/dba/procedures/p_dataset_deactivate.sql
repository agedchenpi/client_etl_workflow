CREATE OR REPLACE PROCEDURE dba.p_dataset_deactivate(IN p_datasetid integer)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_inactive_statusid INT;
BEGIN
    -- Resolve inactive datastatusid
    SELECT datastatusid INTO v_inactive_statusid
    FROM dba.tdatastatus
    WHERE statusname = 'Inactive';
    IF v_inactive_statusid IS NULL THEN
        RAISE EXCEPTION 'Data status Inactive not found';
    END IF;

    -- Deactivate the specified dataset
    UPDATE dba.tdataset
    SET isactive = FALSE,
        effthrudate = CURRENT_TIMESTAMP,
        datastatusid = v_inactive_statusid
    WHERE datasetid = p_datasetid;

    IF NOT FOUND THEN
        RAISE NOTICE 'Dataset ID % not found or already inactive', p_datasetid;
    ELSE
        RAISE NOTICE 'Deactivated dataset ID %', p_datasetid;
    END IF;
END;
$procedure$

