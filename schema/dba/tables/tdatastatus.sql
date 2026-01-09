--
-- PostgreSQL database dump
--

\restrict 5YsfBUGEZgIZceMsiaMJAgzJcwiDDvlKUw4jqQ64fYED4k4cef7cHOXRjrHSLuv

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
-- Name: tdatastatus; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tdatastatus (
    datastatusid integer NOT NULL,
    statusname character varying(50) NOT NULL,
    description text,
    createddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    createdby character varying(50) DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: TABLE tdatastatus; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tdatastatus IS 'Stores status codes for datasets (e.g., Active, Inactive, Deleted).';


--
-- Name: COLUMN tdatastatus.datastatusid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatastatus.datastatusid IS 'Primary key for status.';


--
-- Name: COLUMN tdatastatus.statusname; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatastatus.statusname IS 'Unique name of the status.';


--
-- Name: COLUMN tdatastatus.description; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatastatus.description IS 'Optional description of the status.';


--
-- Name: COLUMN tdatastatus.createddate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatastatus.createddate IS 'Timestamp when the record was created.';


--
-- Name: COLUMN tdatastatus.createdby; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatastatus.createdby IS 'User who created the record.';


--
-- Name: tdatastatus_datastatusid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tdatastatus_datastatusid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tdatastatus_datastatusid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tdatastatus_datastatusid_seq OWNED BY dba.tdatastatus.datastatusid;


--
-- Name: tdatastatus datastatusid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatastatus ALTER COLUMN datastatusid SET DEFAULT nextval('dba.tdatastatus_datastatusid_seq'::regclass);


--
-- Name: tdatastatus tdatastatus_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatastatus
    ADD CONSTRAINT tdatastatus_pkey PRIMARY KEY (datastatusid);


--
-- Name: tdatastatus tdatastatus_statusname_key; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatastatus
    ADD CONSTRAINT tdatastatus_statusname_key UNIQUE (statusname);


--
-- PostgreSQL database dump complete
--

\unrestrict 5YsfBUGEZgIZceMsiaMJAgzJcwiDDvlKUw4jqQ64fYED4k4cef7cHOXRjrHSLuv

