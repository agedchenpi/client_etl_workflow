CREATE OR REPLACE PROCEDURE dba.prunmaintenancevacuumanalyze()
 LANGUAGE plpgsql
AS $procedure$
    DECLARE
        starttime TIMESTAMP;
        endtime TIMESTAMP;
        tablerec RECORD;
    BEGIN
        starttime := CURRENT_TIMESTAMP;
        -- Run VACUUM ANALYZE on all tables
        FOR tablerec IN (
            SELECT format('%I.%I', nspname, relname) AS tablename
            FROM pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            WHERE c.relkind = 'r' AND n.nspname NOT IN ('pg_catalog', 'information_schema')
        ) LOOP
            EXECUTE 'VACUUM ANALYZE ' || quote_ident(tablerec.tablename);
        END LOOP;
        endtime := CURRENT_TIMESTAMP;

        -- Log the operation
        INSERT INTO dba.tmaintenancelog (
            maintenancetime,
            operation,
            tablename,
            username,
            durationseconds,
            details
        )
        VALUES (
            starttime,
            'VACUUM ANALYZE',
            NULL,
            CURRENT_USER,
            EXTRACT(EPOCH FROM (endtime - starttime)),
            'Database-wide VACUUM ANALYZE'
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO dba.tmaintenancelog (
                maintenancetime,
                operation,
                tablename,
                username,
                durationseconds,
                details
            )
            VALUES (
                starttime,
                'VACUUM ANALYZE',
                NULL,
                CURRENT_USER,
                NULL,
                'Error: ' || SQLERRM
            );
            COMMIT;
            RAISE NOTICE 'Maintenance failed: %', SQLERRM;
    END;
    $procedure$

