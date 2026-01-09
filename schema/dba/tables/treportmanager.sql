--
-- PostgreSQL database dump
--

\restrict T56JxEjsnm7ttzfDp3rw0mgYoLGeVCLftf9R5JBpfZIuuyzSWomPhLYBEZvjYiI

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
-- Name: treportmanager; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.treportmanager (
    reportid integer NOT NULL,
    reportname character varying(255) NOT NULL,
    reportdescription text,
    frequency character varying(50) NOT NULL,
    subjectheader character varying(255) NOT NULL,
    toheader text NOT NULL,
    hasattachment boolean DEFAULT false,
    attachmentqueries jsonb,
    emailbodytemplate text,
    emailbodyqueries jsonb,
    datastatusid integer,
    createddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    createduser character varying(100)
);


--
-- Name: TABLE treportmanager; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.treportmanager IS 'Stores configurations for automated email reports.';


--
-- Name: COLUMN treportmanager.reportid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.reportid IS 'Primary key for the report configuration.';


--
-- Name: COLUMN treportmanager.reportname; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.reportname IS 'Name of the report.';


--
-- Name: COLUMN treportmanager.reportdescription; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.reportdescription IS 'Description of the report.';


--
-- Name: COLUMN treportmanager.frequency; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.frequency IS 'Cron expression defining the report schedule (e.g., "0 8 * * *").';


--
-- Name: COLUMN treportmanager.subjectheader; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.subjectheader IS 'Email subject header.';


--
-- Name: COLUMN treportmanager.toheader; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.toheader IS 'Comma-separated list of recipient email addresses.';


--
-- Name: COLUMN treportmanager.hasattachment; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.hasattachment IS 'Flag indicating if the report includes attachments.';


--
-- Name: COLUMN treportmanager.attachmentqueries; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.attachmentqueries IS 'JSONB array of attachment queries (e.g., [{"name": "file.csv", "query": "SELECT * FROM table"}]).';


--
-- Name: COLUMN treportmanager.emailbodytemplate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.emailbodytemplate IS 'HTML template for the email body with placeholders (e.g., "Here is your report: {{grid1}}").';


--
-- Name: COLUMN treportmanager.emailbodyqueries; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.emailbodyqueries IS 'JSONB mapping of placeholders to SQL queries (e.g., {"grid1": "SELECT * FROM table"}).';


--
-- Name: COLUMN treportmanager.datastatusid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.datastatusid IS 'Foreign key to dba.tdatastatus, indicating report status (e.g., active, inactive).';


--
-- Name: COLUMN treportmanager.createddate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.createddate IS 'Timestamp when the record was created.';


--
-- Name: COLUMN treportmanager.createduser; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.treportmanager.createduser IS 'User who created the record.';


--
-- Name: treportmanager_reportid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.treportmanager_reportid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: treportmanager_reportid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.treportmanager_reportid_seq OWNED BY dba.treportmanager.reportid;


--
-- Name: treportmanager reportid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.treportmanager ALTER COLUMN reportid SET DEFAULT nextval('dba.treportmanager_reportid_seq'::regclass);


--
-- Name: treportmanager treportmanager_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.treportmanager
    ADD CONSTRAINT treportmanager_pkey PRIMARY KEY (reportid);


--
-- Name: treportmanager treportmanager_datastatusid_fkey; Type: FK CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.treportmanager
    ADD CONSTRAINT treportmanager_datastatusid_fkey FOREIGN KEY (datastatusid) REFERENCES dba.tdatastatus(datastatusid);


--
-- PostgreSQL database dump complete
--

\unrestrict T56JxEjsnm7ttzfDp3rw0mgYoLGeVCLftf9R5JBpfZIuuyzSWomPhLYBEZvjYiI

