CREATE OR REPLACE FUNCTION dba.f_insert_treportmanager(p_reportname character varying, p_reportdescription text, p_frequency character varying, p_subjectheader character varying, p_toheader text, p_hasattachment boolean, p_attachmentqueries jsonb, p_emailbodytemplate text, p_emailbodyqueries jsonb, p_datastatus integer, p_createduser character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
        DECLARE
            v_datastatusid INT;
            v_reportid INT;
        BEGIN
            -- Resolve datastatusid
            SELECT datastatusid INTO v_datastatusid 
            FROM dba.tdatastatus 
            WHERE datastatusid = p_datastatus;
            IF v_datastatusid IS NULL THEN
                RAISE EXCEPTION 'Data status % not found', p_datastatus;
            END IF;

            -- Insert new report configuration
            INSERT INTO dba.treportmanager (
                reportname,
                reportdescription,
                frequency,
                Subjectheader,
                toheader,
                hasattachment,
                attachmentqueries,
                emailbodytemplate,
                emailbodyqueries,
                datastatusid, -- Updated to datastatusid
                createddate,
                createduser
            ) VALUES (
                p_reportname,
                p_reportdescription,
                p_frequency,
                p_subjectheader,
                p_toheader,
                p_hasattachment,
                p_attachmentqueries,
                p_emailbodytemplate,
                p_emailbodyqueries,
                v_datastatusid,
                CURRENT_TIMESTAMP,
                p_createduser
            ) RETURNING reportID INTO v_reportid;

            RETURN v_reportid;
        END;
        $function$

