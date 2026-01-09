--
-- PostgreSQL database dump
--

\restrict TbfPddv50gzZySlUFouashzouUlljGqeqPEBBnCetp13zmw5pwlHOZhkR3YJf68

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
-- Name: tscheduler; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tscheduler (
    schedulerid integer NOT NULL,
    taskname character varying(255) NOT NULL,
    taskdescription text,
    frequency character varying(50) NOT NULL,
    scriptpath character varying(255) NOT NULL,
    scriptargs text,
    datastatusid integer,
    createddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    createduser character varying(100)
);


--
-- Name: TABLE tscheduler; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tscheduler IS 'Stores scheduling information for ETL tasks.';


--
-- Name: COLUMN tscheduler.schedulerid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.schedulerid IS 'Primary key for the schedule.';


--
-- Name: COLUMN tscheduler.taskname; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.taskname IS 'Unique name of the task (e.g., "daily_download").';


--
-- Name: COLUMN tscheduler.taskdescription; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.taskdescription IS 'Description of the task.';


--
-- Name: COLUMN tscheduler.frequency; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.frequency IS 'Cron expression defining the task schedule (e.g., "0 0 * * *").';


--
-- Name: COLUMN tscheduler.scriptpath; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.scriptpath IS 'Path to the script to execute (e.g., "/path/to/script.py").';


--
-- Name: COLUMN tscheduler.scriptargs; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.scriptargs IS 'Optional arguments for the script (e.g., "arg1 arg2").';


--
-- Name: COLUMN tscheduler.datastatusid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.datastatusid IS 'Foreign key to dba.tdatastatus, indicating task status (e.g., active, inactive).';


--
-- Name: COLUMN tscheduler.createddate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.createddate IS 'Timestamp when the record was created.';


--
-- Name: COLUMN tscheduler.createduser; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tscheduler.createduser IS 'User who created the record.';


--
-- Name: tscheduler_schedulerid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tscheduler_schedulerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tscheduler_schedulerid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tscheduler_schedulerid_seq OWNED BY dba.tscheduler.schedulerid;


--
-- Name: tscheduler schedulerid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tscheduler ALTER COLUMN schedulerid SET DEFAULT nextval('dba.tscheduler_schedulerid_seq'::regclass);


--
-- Name: tscheduler tscheduler_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tscheduler
    ADD CONSTRAINT tscheduler_pkey PRIMARY KEY (schedulerid);


--
-- Name: tscheduler uk_taskname; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tscheduler
    ADD CONSTRAINT uk_taskname UNIQUE (taskname);


--
-- Name: tscheduler tscheduler_datastatusid_fkey; Type: FK CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tscheduler
    ADD CONSTRAINT tscheduler_datastatusid_fkey FOREIGN KEY (datastatusid) REFERENCES dba.tdatastatus(datastatusid);


--
-- PostgreSQL database dump complete
--

\unrestrict TbfPddv50gzZySlUFouashzouUlljGqeqPEBBnCetp13zmw5pwlHOZhkR3YJf68

