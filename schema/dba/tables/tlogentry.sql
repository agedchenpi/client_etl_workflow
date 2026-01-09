--
-- PostgreSQL database dump
--

\restrict X2HbP4HIEsbqkaKvCkNZgOkkqegTXeQ3hpD4qOjiBbCJZ6v2ZTLEe5zsoJR2LRe

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
-- Name: tlogentry; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tlogentry (
    logid integer NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    run_uuid character varying(36) NOT NULL,
    processtype character varying(50) NOT NULL,
    stepcounter character varying(50),
    username character varying(50),
    stepruntime double precision,
    totalruntime double precision,
    message text NOT NULL
);


--
-- Name: TABLE tlogentry; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tlogentry IS 'Stores log entries for ETL processes.';


--
-- Name: COLUMN tlogentry.logid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry.logid IS 'Primary key for the log entry.';


--
-- Name: COLUMN tlogentry."timestamp"; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry."timestamp" IS 'Timestamp of the log entry.';


--
-- Name: COLUMN tlogentry.run_uuid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry.run_uuid IS 'Unique identifier for the ETL run.';


--
-- Name: COLUMN tlogentry.processtype; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry.processtype IS 'Type of process (e.g., EventProcessing, FinalSave).';


--
-- Name: COLUMN tlogentry.stepcounter; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry.stepcounter IS 'Step identifier within the process.';


--
-- Name: COLUMN tlogentry.username; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry.username IS 'User who executed the process.';


--
-- Name: COLUMN tlogentry.stepruntime; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry.stepruntime IS 'Runtime of the step in seconds.';


--
-- Name: COLUMN tlogentry.totalruntime; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry.totalruntime IS 'Total runtime of the script in seconds.';


--
-- Name: COLUMN tlogentry.message; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tlogentry.message IS 'Log message.';


--
-- Name: tlogentry_logid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tlogentry_logid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tlogentry_logid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tlogentry_logid_seq OWNED BY dba.tlogentry.logid;


--
-- Name: tlogentry logid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tlogentry ALTER COLUMN logid SET DEFAULT nextval('dba.tlogentry_logid_seq'::regclass);


--
-- Name: tlogentry tlogentry_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tlogentry
    ADD CONSTRAINT tlogentry_pkey PRIMARY KEY (logid);


--
-- Name: idx_tlogentry_run_uuid; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tlogentry_run_uuid ON dba.tlogentry USING btree (run_uuid);


--
-- Name: idx_tlogentry_timestamp; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tlogentry_timestamp ON dba.tlogentry USING btree ("timestamp");


--
-- PostgreSQL database dump complete
--

\unrestrict X2HbP4HIEsbqkaKvCkNZgOkkqegTXeQ3hpD4qOjiBbCJZ6v2ZTLEe5zsoJR2LRe

