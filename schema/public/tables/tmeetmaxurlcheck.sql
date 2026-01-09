--
-- PostgreSQL database dump
--

\restrict 7RC1OhyD6ajUwznl01BkylkLlVNy7BHzWERj2jpDRWmLrpkS2eY5USWtUhMJiVt

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
-- Name: tmeetmaxurlcheck; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tmeetmaxurlcheck (
    tmeetmaxurlcheckid integer NOT NULL,
    datasetid integer NOT NULL,
    eventid character varying(9),
    url character varying(90),
    ifexists character varying(1),
    invalideventid character varying(7),
    isdownloadable character varying(1),
    downloadlink character varying(112),
    statuscode character varying(4),
    title character varying(18)
);


--
-- Name: tmeetmaxurlcheck_tmeetmaxurlcheckid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tmeetmaxurlcheck_tmeetmaxurlcheckid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tmeetmaxurlcheck_tmeetmaxurlcheckid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tmeetmaxurlcheck_tmeetmaxurlcheckid_seq OWNED BY public.tmeetmaxurlcheck.tmeetmaxurlcheckid;


--
-- Name: tmeetmaxurlcheck tmeetmaxurlcheckid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxurlcheck ALTER COLUMN tmeetmaxurlcheckid SET DEFAULT nextval('public.tmeetmaxurlcheck_tmeetmaxurlcheckid_seq'::regclass);


--
-- Name: tmeetmaxurlcheck tmeetmaxurlcheck_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxurlcheck
    ADD CONSTRAINT tmeetmaxurlcheck_pkey PRIMARY KEY (tmeetmaxurlcheckid);


--
-- Name: tmeetmaxurlcheck tmeetmaxurlcheck_datasetid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxurlcheck
    ADD CONSTRAINT tmeetmaxurlcheck_datasetid_fkey FOREIGN KEY (datasetid) REFERENCES dba.tdataset(datasetid);


--
-- PostgreSQL database dump complete
--

\unrestrict 7RC1OhyD6ajUwznl01BkylkLlVNy7BHzWERj2jpDRWmLrpkS2eY5USWtUhMJiVt

