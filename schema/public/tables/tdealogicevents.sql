--
-- PostgreSQL database dump
--

\restrict HifoH3KNUA06qdfMfxVXcUih2Y0A5rALDzlIDkz6X13WYse8qvqTka50CsCuPen

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: tdealogicevents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tdealogicevents (
    tdealogiceventsid integer NOT NULL,
    datasetid integer NOT NULL,
    ticker character varying(12),
    name character varying(43),
    conference_title character varying(115),
    start_date character varying(15),
    end_date character varying(15),
    location character varying(37),
    hosting_bank character varying(28),
    participants character varying(39),
    meeting_offerings character varying(15),
    created_at character varying(28),
    last_updated_at character varying(28),
    status character varying(12),
    notes character varying(1)
);


--
-- Name: tdealogicevents_tdealogiceventsid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tdealogicevents_tdealogiceventsid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tdealogicevents_tdealogiceventsid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tdealogicevents_tdealogiceventsid_seq OWNED BY public.tdealogicevents.tdealogiceventsid;


--
-- Name: tdealogicevents tdealogiceventsid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tdealogicevents ALTER COLUMN tdealogiceventsid SET DEFAULT nextval('public.tdealogicevents_tdealogiceventsid_seq'::regclass);


--
-- Name: tdealogicevents tdealogicevents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tdealogicevents
    ADD CONSTRAINT tdealogicevents_pkey PRIMARY KEY (tdealogiceventsid);


--
-- Name: tdealogicevents tdealogicevents_datasetid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tdealogicevents
    ADD CONSTRAINT tdealogicevents_datasetid_fkey FOREIGN KEY (datasetid) REFERENCES dba.tdataset(datasetid);


--
-- PostgreSQL database dump complete
--

\unrestrict HifoH3KNUA06qdfMfxVXcUih2Y0A5rALDzlIDkz6X13WYse8qvqTka50CsCuPen

