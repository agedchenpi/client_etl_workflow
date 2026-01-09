--
-- PostgreSQL database dump
--

\restrict W8Ps1F04mRftnAfz2p14aEYlXkeqs4FYiUKZGCiSMH3l6vWlqizkSYCU06V6iZb

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
-- Name: tddllogs; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tddllogs (
    logid integer NOT NULL,
    eventtime timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    eventtype text NOT NULL,
    schemaname text,
    objectname text,
    objecttype text NOT NULL,
    sqlstatement text NOT NULL,
    username character varying(50) DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: TABLE tddllogs; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tddllogs IS 'Logs DDL changes in the database.';


--
-- Name: COLUMN tddllogs.logid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tddllogs.logid IS 'Primary key for the log entry.';


--
-- Name: COLUMN tddllogs.eventtime; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tddllogs.eventtime IS 'Timestamp of the DDL event.';


--
-- Name: COLUMN tddllogs.eventtype; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tddllogs.eventtype IS 'Type of DDL event (e.g., CREATE, ALTER, DROP).';


--
-- Name: COLUMN tddllogs.schemaname; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tddllogs.schemaname IS 'Schema of the affected object.';


--
-- Name: COLUMN tddllogs.objectname; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tddllogs.objectname IS 'Identifier of the affected object.';


--
-- Name: COLUMN tddllogs.objecttype; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tddllogs.objecttype IS 'Type of the affected object (e.g., TABLE, FUNCTION).';


--
-- Name: COLUMN tddllogs.sqlstatement; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tddllogs.sqlstatement IS 'SQL statement tag that triggered the event.';


--
-- Name: COLUMN tddllogs.username; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tddllogs.username IS 'User who performed the DDL operation.';


--
-- Name: tddllogs_logid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tddllogs_logid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tddllogs_logid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tddllogs_logid_seq OWNED BY dba.tddllogs.logid;


--
-- Name: tddllogs logid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tddllogs ALTER COLUMN logid SET DEFAULT nextval('dba.tddllogs_logid_seq'::regclass);


--
-- Name: tddllogs tddllogs_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tddllogs
    ADD CONSTRAINT tddllogs_pkey PRIMARY KEY (logid);


--
-- PostgreSQL database dump complete
--

\unrestrict W8Ps1F04mRftnAfz2p14aEYlXkeqs4FYiUKZGCiSMH3l6vWlqizkSYCU06V6iZb

