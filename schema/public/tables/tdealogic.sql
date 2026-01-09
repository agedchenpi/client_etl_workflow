--
-- PostgreSQL database dump
--

\restrict 52lQqF3wZlaRcb33JNYsdJiOE4GI6NbSNqOMJzURroV5RKnyZs99Qdug4DmkdGL

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
-- Name: tdealogic; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tdealogic (
    tdealogicid integer NOT NULL,
    datasetid integer NOT NULL,
    refdatasetdate character varying(33),
    label character varying(36),
    dealogiccanceledeventsid character varying(7),
    refdatasetid character varying(9),
    ticker character varying(16),
    name character varying(81),
    conference_title character varying(120),
    start_date character varying(15),
    end_date character varying(15),
    location character varying(51),
    hosting_bank character varying(54),
    participants character varying(39),
    meeting_offerings character varying(15),
    created_at character varying(22),
    last_updated_at character varying(27),
    status character varying(12),
    notes character varying(297)
);


--
-- Name: tdealogic_tdealogicid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tdealogic_tdealogicid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tdealogic_tdealogicid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tdealogic_tdealogicid_seq OWNED BY public.tdealogic.tdealogicid;


--
-- Name: tdealogic tdealogicid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tdealogic ALTER COLUMN tdealogicid SET DEFAULT nextval('public.tdealogic_tdealogicid_seq'::regclass);


--
-- Name: tdealogic tdealogic_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tdealogic
    ADD CONSTRAINT tdealogic_pkey PRIMARY KEY (tdealogicid);


--
-- Name: tdealogic tdealogic_datasetid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tdealogic
    ADD CONSTRAINT tdealogic_datasetid_fkey FOREIGN KEY (datasetid) REFERENCES dba.tdataset(datasetid);


--
-- PostgreSQL database dump complete
--

\unrestrict 52lQqF3wZlaRcb33JNYsdJiOE4GI6NbSNqOMJzURroV5RKnyZs99Qdug4DmkdGL

