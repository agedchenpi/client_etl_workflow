--
-- PostgreSQL database dump
--

\restrict 5f2YbKJrEDKape2aPoLVhcm16EzvjDMtoLpBlbJo0wEIFrWdMvFtcJx1vau9Qub

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
-- Name: tmeetmaxeventdata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tmeetmaxeventdata (
    tmeetmaxeventdataid integer NOT NULL,
    datasetid integer NOT NULL,
    company_name character varying(109),
    tickers character varying(19)
);


--
-- Name: tmeetmaxeventdata_tmeetmaxeventdataid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tmeetmaxeventdata_tmeetmaxeventdataid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tmeetmaxeventdata_tmeetmaxeventdataid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tmeetmaxeventdata_tmeetmaxeventdataid_seq OWNED BY public.tmeetmaxeventdata.tmeetmaxeventdataid;


--
-- Name: tmeetmaxeventdata tmeetmaxeventdataid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxeventdata ALTER COLUMN tmeetmaxeventdataid SET DEFAULT nextval('public.tmeetmaxeventdata_tmeetmaxeventdataid_seq'::regclass);


--
-- Name: tmeetmaxeventdata tmeetmaxeventdata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxeventdata
    ADD CONSTRAINT tmeetmaxeventdata_pkey PRIMARY KEY (tmeetmaxeventdataid);


--
-- Name: idx_tmeetmaxeventdata_datasetid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tmeetmaxeventdata_datasetid ON public.tmeetmaxeventdata USING btree (datasetid);


--
-- Name: tmeetmaxeventdata tmeetmaxeventdata_datasetid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxeventdata
    ADD CONSTRAINT tmeetmaxeventdata_datasetid_fkey FOREIGN KEY (datasetid) REFERENCES dba.tdataset(datasetid);


--
-- PostgreSQL database dump complete
--

\unrestrict 5f2YbKJrEDKape2aPoLVhcm16EzvjDMtoLpBlbJo0wEIFrWdMvFtcJx1vau9Qub

