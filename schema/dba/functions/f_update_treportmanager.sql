CREATE OR REPLACE FUNCTION dba.f_update_treportmanager(p_reportid integer, p_reportname character varying, p_reportdescription text, p_frequency character varying, p_subjectheader character varying, p_toheader text, p_hasattachment boolean, p_attachmentqueries jsonb, p_emailbodytemplate text, p_emailbodyqueries jsonb, p_datastatusid integer)
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

        -- Update the report configuration
        UPDATE dba.treportmanager
        SET reportname = p_reportname,
            reportdescription = p_reportdescription,
            frequency = p_frequency,
            Subjectheader = p_subjectheader,
            toheader = p_toheader,
            hasattachment = p_hasattachment,
            attachmentqueries = p_attachmentqueries,
            emailbodytemplate = p_emailbodytemplate,
            emailbodyqueries = p_emailbodyqueries,
            datastatusid = p_datastatusid
        WHERE reportID = p_reportid;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Report with ID % not found', p_reportid;
        END IF;
    END;
    $function$

