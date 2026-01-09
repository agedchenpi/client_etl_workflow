CREATE OR REPLACE PROCEDURE dba.pcapturetableindexstats()
 LANGUAGE plpgsql
AS $procedure$
    BEGIN
        -- Capture table stats
        INSERT INTO dba.ttableindexstats (
            snapshottime,
            schemaname,
            tablename,
            indexname,
            rowcount,
            seqscans,
            idxscans,
            inserts,
            updates,
            deletes,
            totalsize
        )
        SELECT 
            CURRENT_TIMESTAMP,
            schemaname,
            relname,
            NULL AS indexname,
            n_live_tup,
            seq_scan,
            idx_scan,
            n_tup_ins,
            n_tup_upd,
            n_tup_del,
            pg_total_relation_size(relid)
        FROM pg_stat_user_tables;
        
        -- Capture index stats
        INSERT INTO dba.ttableindexstats (
            snapshottime,
            schemaname,
            tablename,
            indexname,
            rowcount,
            seqscans,
            idxscans,
            inserts,
            updates,
            deletes,
            totalsize
        )
        SELECT 
            CURRENT_TIMESTAMP,
            s.schemaname,
            s.relname AS tablename,
            s.indexrelname AS indexname,
            NULL AS rowcount,
            NULL AS seqscans,
            s.idx_scan AS idxscans,
            NULL AS inserts,
            NULL AS updates,
            NULL AS deletes,
            pg_total_relation_size(s.indexrelid) AS totalsize
        FROM pg_stat_user_indexes s
        JOIN pg_index i ON s.indexrelid = i.indexrelid
        WHERE NOT i.indisprimary;
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO dba.tlogentry (
                runuuid,
                timestamp,
                processtype,
                stepcounter,
                username,
                stepruntime,
                totalruntime,
                message
            )
            VALUES (
                gen_random_uuid(),
                CURRENT_TIMESTAMP,
                'StatsCapture',
                'error',
                CURRENT_USER,
                NULL,
                NULL,
                'Error capturing table/index stats: ' || SQLERRM
            );
            COMMIT;
            RAISE NOTICE 'Stats capture failed: %', SQLERRM;
    END;
    $procedure$

