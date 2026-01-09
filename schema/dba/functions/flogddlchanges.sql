CREATE OR REPLACE FUNCTION dba.flogddlchanges()
 RETURNS event_trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    r RECORD;
    changetime TIMESTAMP := CURRENT_TIMESTAMP;
BEGIN
    FOR r IN (SELECT * FROM pg_event_trigger_ddl_commands())
    LOOP
        INSERT INTO dba.tddllogs (
              eventtime
            , eventtype
            , schemaname
            , objectname
            , objecttype
            , sqlstatement
        )
        VALUES (
              changetime
            , r.command_tag
            , COALESCE(r.schema_name, 'dba') -- Handle NULL schema_name
            , r.object_identity
            , r.object_type
            , r.command_tag
        );
    END LOOP;
END;
$function$

