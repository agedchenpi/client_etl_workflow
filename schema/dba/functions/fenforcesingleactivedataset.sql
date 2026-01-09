CREATE OR REPLACE FUNCTION dba.fenforcesingleactivedataset()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
        BEGIN
            RAISE NOTICE 'Line 147: Inside fenforcesingleactivedataset function body';
            IF NEW.isactive = TRUE THEN
                UPDATE dba.tdataset
                SET isactive = FALSE,
                    effthrudate = CURRENT_TIMESTAMP,
                    datastatusid = (SELECT datastatusid FROM dba.tdatastatus WHERE statusname = 'Inactive')
                WHERE label = NEW.label
                  AND datasettypeid = NEW.datasettypeid
                  AND datasetdate = NEW.datasetdate
                  AND datasetid != NEW.datasetid
                  AND isactive = TRUE;
                RAISE NOTICE 'Line 157: Completed UPDATE in fenforcesingleactivedataset';
            END IF;
            RAISE NOTICE 'Line 159: Returning from fenforcesingleactivedataset';
            RETURN NEW;
        END;
        $function$

