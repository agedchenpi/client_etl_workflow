CREATE OR REPLACE PROCEDURE public.insert_tickerexception(IN p_tickername character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
INSERT INTO public.ttickerexceptions (tickername) VALUES (p_tickername);
END;
$procedure$

