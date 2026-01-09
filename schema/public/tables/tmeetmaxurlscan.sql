--
-- PostgreSQL database dump
--

\restrict gBKDzB6izxtKSEYYvMPoytGKJbntAlFd7P1UoUc2qEjpByxl6VsXcV76vWHumWB

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
-- Name: tmeetmaxurlscan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tmeetmaxurlscan (
    tmeetmaxurlscanid integer NOT NULL,
    datasetid integer NOT NULL,
    eventid character varying(9),
    url character varying(90),
    isactivewebpage character varying(7),
    isinvalideventid character varying(7),
    statuscode character varying(7),
    title character varying(90),
    pagestatus character varying(18),
    numcompanies character varying(4)
);


--
-- Name: tmeetmaxurlscan_tmeetmaxurlscanid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tmeetmaxurlscan_tmeetmaxurlscanid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tmeetmaxurlscan_tmeetmaxurlscanid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tmeetmaxurlscan_tmeetmaxurlscanid_seq OWNED BY public.tmeetmaxurlscan.tmeetmaxurlscanid;


--
-- Name: tmeetmaxurlscan tmeetmaxurlscanid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxurlscan ALTER COLUMN tmeetmaxurlscanid SET DEFAULT nextval('public.tmeetmaxurlscan_tmeetmaxurlscanid_seq'::regclass);


--
-- Name: tmeetmaxurlscan tmeetmaxurlscan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxurlscan
    ADD CONSTRAINT tmeetmaxurlscan_pkey PRIMARY KEY (tmeetmaxurlscanid);


--
-- Name: idx_tmeetmaxurlscan_datasetid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tmeetmaxurlscan_datasetid ON public.tmeetmaxurlscan USING btree (datasetid);


--
-- Name: tmeetmaxurlscan tmeetmaxurlscan_datasetid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxurlscan
    ADD CONSTRAINT tmeetmaxurlscan_datasetid_fkey FOREIGN KEY (datasetid) REFERENCES dba.tdataset(datasetid);


--
-- PostgreSQL database dump complete
--

\unrestrict gBKDzB6izxtKSEYYvMPoytGKJbntAlFd7P1UoUc2qEjpByxl6VsXcV76vWHumWB

