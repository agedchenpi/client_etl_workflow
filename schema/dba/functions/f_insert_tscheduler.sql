CREATE OR REPLACE FUNCTION dba.f_insert_tscheduler(p_taskname character varying, p_taskdescription text, p_frequency character varying, p_scriptpath character varying, p_scriptargs text, p_datastatusid integer, p_createduser character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_schedulerid INT;
BEGIN
    -- Validate datastatusid exists in dba.tdatastatus
    IF NOT EXISTS (
        SELECT 1
        FROM dba.tdatastatus
        WHERE datastatusid = p_datastatusid
    ) THEN
        RAISE EXCEPTION 'Data status ID % not found in dba.tdatastatus', p_datastatusid;
    END IF;

    -- Insert new schedule
    INSERT INTO dba.tscheduler (
        taskname,
        taskdescription,
        frequency,
        scriptpath,
        scriptargs,
        datastatusid,
        createddate,
        createduser
    ) VALUES (
        p_taskname,
        p_taskdescription,
        p_frequency,
        p_scriptpath,
        p_scriptargs,
        p_datastatusid,
        CURRENT_TIMESTAMP,
        p_createduser
    ) RETURNING schedulerID INTO v_schedulerid;

    RETURN v_schedulerid;
END;
$function$

