CREATE OR REPLACE FUNCTION dba.f_update_tscheduler(p_schedulerid integer, p_taskname character varying, p_taskdescription text, p_frequency character varying, p_scriptpath character varying, p_scriptargs text, p_datastatusid integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Validate datastatusid exists in dba.tdatastatus
    IF NOT EXISTS (
        SELECT 1
        FROM dba.tdatastatus
        WHERE datastatusid = p_datastatusid
    ) THEN
        RAISE EXCEPTION 'Data status ID % not found in dba.tdatastatus', p_datastatusid;
    END IF;

    -- Update the schedule
    UPDATE dba.tscheduler
    SET taskname = p_taskname,
        taskdescription = p_taskdescription,
        frequency = p_frequency,
        scriptpath = p_scriptpath,
        scriptargs = p_scriptargs,
        datastatusid = p_datastatusid
    WHERE schedulerID = p_schedulerid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Schedule with ID % not found', p_schedulerid;
    END IF;
END;
$function$

