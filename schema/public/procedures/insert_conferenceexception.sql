CREATE OR REPLACE PROCEDURE public.insert_conferenceexception(IN p_conferencename character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
INSERT INTO public.tconferenceexception (conferencename) VALUES (p_conferencename);
END;
$procedure$

