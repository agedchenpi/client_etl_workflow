--
-- PostgreSQL database dump
--

\restrict ZLtNDmPD3iQes4N99leECNtB66vcFutMgTC4Dn2VLwRZoDMRHVFBvAoYDeQ9ZFB

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
-- Name: timportstrategy; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.timportstrategy (
    importstrategyid integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: TABLE timportstrategy; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.timportstrategy IS 'Table defining import strategies for timportconfig, specifying how to handle column mismatches during data import.';


--
-- Name: COLUMN timportstrategy.importstrategyid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportstrategy.importstrategyid IS 'Unique identifier for the import strategy.';


--
-- Name: COLUMN timportstrategy.name; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportstrategy.name IS 'Descriptive name of the import strategy (e.g., ''Import and create new columns if needed'').';


--
-- Name: timportstrategy_importstrategyid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.timportstrategy_importstrategyid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timportstrategy_importstrategyid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.timportstrategy_importstrategyid_seq OWNED BY dba.timportstrategy.importstrategyid;


--
-- Name: timportstrategy importstrategyid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.timportstrategy ALTER COLUMN importstrategyid SET DEFAULT nextval('dba.timportstrategy_importstrategyid_seq'::regclass);


--
-- Name: timportstrategy timportstrategy_name_key; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.timportstrategy
    ADD CONSTRAINT timportstrategy_name_key UNIQUE (name);


--
-- Name: timportstrategy timportstrategy_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.timportstrategy
    ADD CONSTRAINT timportstrategy_pkey PRIMARY KEY (importstrategyid);


--
-- PostgreSQL database dump complete
--

\unrestrict ZLtNDmPD3iQes4N99leECNtB66vcFutMgTC4Dn2VLwRZoDMRHVFBvAoYDeQ9ZFB

