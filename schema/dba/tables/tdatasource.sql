--
-- PostgreSQL database dump
--

\restrict 4a2HpsbZ8lpwdFg6oeSWM0npEQnaG1X8wC6eqG1zpdEQtSLXmyryUmd5OpZkAox

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
-- Name: tdatasource; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tdatasource (
    datasourceid integer NOT NULL,
    sourcename character varying(50) NOT NULL,
    description text,
    createddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    createdby character varying(50) DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: TABLE tdatasource; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tdatasource IS 'Stores data source definitions (e.g., MeetMax Website, SFTP Upload).';


--
-- Name: COLUMN tdatasource.datasourceid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasource.datasourceid IS 'Primary key for data source.';


--
-- Name: COLUMN tdatasource.sourcename; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasource.sourcename IS 'Unique name of the data source.';


--
-- Name: COLUMN tdatasource.description; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasource.description IS 'Optional description of the data source.';


--
-- Name: COLUMN tdatasource.createddate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasource.createddate IS 'Timestamp when the record was created.';


--
-- Name: COLUMN tdatasource.createdby; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasource.createdby IS 'User who created the record.';


--
-- Name: tdatasource_datasourceid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tdatasource_datasourceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tdatasource_datasourceid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tdatasource_datasourceid_seq OWNED BY dba.tdatasource.datasourceid;


--
-- Name: tdatasource datasourceid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatasource ALTER COLUMN datasourceid SET DEFAULT nextval('dba.tdatasource_datasourceid_seq'::regclass);


--
-- Name: tdatasource tdatasource_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatasource
    ADD CONSTRAINT tdatasource_pkey PRIMARY KEY (datasourceid);


--
-- Name: tdatasource tdatasource_sourcename_key; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatasource
    ADD CONSTRAINT tdatasource_sourcename_key UNIQUE (sourcename);


--
-- PostgreSQL database dump complete
--

\unrestrict 4a2HpsbZ8lpwdFg6oeSWM0npEQnaG1X8wC6eqG1zpdEQtSLXmyryUmd5OpZkAox

