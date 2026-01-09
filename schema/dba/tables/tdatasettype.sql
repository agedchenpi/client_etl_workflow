--
-- PostgreSQL database dump
--

\restrict gPXJihJ1YxvfNOsSWkR3v2BU4ZbjVqki3LxNpxkhm4e3hf3Lgdz5eQlbCK8dQNe

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
-- Name: tdatasettype; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tdatasettype (
    datasettypeid integer NOT NULL,
    typename character varying(50) NOT NULL,
    description text,
    createddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    createdby character varying(50) DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: TABLE tdatasettype; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tdatasettype IS 'Stores dataset type definitions (e.g., MeetMax, ClientUpload).';


--
-- Name: COLUMN tdatasettype.datasettypeid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasettype.datasettypeid IS 'Primary key for dataset type.';


--
-- Name: COLUMN tdatasettype.typename; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasettype.typename IS 'Unique name of the dataset type.';


--
-- Name: COLUMN tdatasettype.description; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasettype.description IS 'Optional description of the dataset type.';


--
-- Name: COLUMN tdatasettype.createddate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasettype.createddate IS 'Timestamp when the record was created.';


--
-- Name: COLUMN tdatasettype.createdby; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdatasettype.createdby IS 'User who created the record.';


--
-- Name: tdatasettype_datasettypeid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tdatasettype_datasettypeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tdatasettype_datasettypeid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tdatasettype_datasettypeid_seq OWNED BY dba.tdatasettype.datasettypeid;


--
-- Name: tdatasettype datasettypeid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatasettype ALTER COLUMN datasettypeid SET DEFAULT nextval('dba.tdatasettype_datasettypeid_seq'::regclass);


--
-- Name: tdatasettype tdatasettype_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatasettype
    ADD CONSTRAINT tdatasettype_pkey PRIMARY KEY (datasettypeid);


--
-- Name: tdatasettype tdatasettype_typename_key; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdatasettype
    ADD CONSTRAINT tdatasettype_typename_key UNIQUE (typename);


--
-- PostgreSQL database dump complete
--

\unrestrict gPXJihJ1YxvfNOsSWkR3v2BU4ZbjVqki3LxNpxkhm4e3hf3Lgdz5eQlbCK8dQNe

