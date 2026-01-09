--
-- PostgreSQL database dump
--

\restrict ARTTlywBkUlCdCNKOoD1OMOEr0E24N4cTI3l4fV2MsLsc3D31q2o0mfuqX1pnk6

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
-- Name: timportconfig; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.timportconfig (
    config_id integer NOT NULL,
    config_name character varying(100) NOT NULL,
    datasource character varying(100) NOT NULL,
    datasettype character varying(100) NOT NULL,
    source_directory character varying(255) NOT NULL,
    archive_directory character varying(255) NOT NULL,
    file_pattern character varying(255) NOT NULL,
    file_type character varying(10) NOT NULL,
    metadata_label_source character varying(50) NOT NULL,
    metadata_label_location character varying(255),
    dateconfig character varying(50) NOT NULL,
    datelocation character varying(255),
    dateformat character varying(50),
    delimiter character varying(10),
    target_table character varying(100) NOT NULL,
    importstrategyid integer DEFAULT 1 NOT NULL,
    is_active bit(1) DEFAULT '1'::"bit",
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_modified_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT timportconfig_dateconfig_check CHECK (((dateconfig)::text = ANY ((ARRAY['filename'::character varying, 'file_content'::character varying, 'static'::character varying])::text[]))),
    CONSTRAINT timportconfig_file_type_check CHECK (((file_type)::text = ANY ((ARRAY['CSV'::character varying, 'XLS'::character varying, 'XLSX'::character varying])::text[]))),
    CONSTRAINT timportconfig_metadata_label_source_check CHECK (((metadata_label_source)::text = ANY ((ARRAY['filename'::character varying, 'file_content'::character varying, 'static'::character varying])::text[]))),
    CONSTRAINT valid_date CHECK (((((dateconfig)::text = 'filename'::text) AND ((datelocation)::text ~ '^[0-9]+$'::text) AND (delimiter IS NOT NULL) AND (dateformat IS NOT NULL)) OR (((dateconfig)::text = 'file_content'::text) AND ((datelocation)::text ~ '^[a-zA-Z0-9_]+$'::text) AND (dateformat IS NOT NULL)) OR (((dateconfig)::text = 'static'::text) AND (dateformat IS NOT NULL)))),
    CONSTRAINT valid_directories CHECK ((((source_directory)::text <> (archive_directory)::text) AND ((source_directory)::text ~ '^/.*[^/]$'::text) AND ((archive_directory)::text ~ '^/.*[^/]$'::text)))
);


--
-- Name: TABLE timportconfig; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.timportconfig IS 'Configuration table for importing flat files (CSV, XLS, XLSX) into the database, specifying file patterns, directories, metadata, date extraction rules, delimiter, date format, data source/type descriptions, and import strategy.';


--
-- Name: COLUMN timportconfig.config_id; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.config_id IS 'Unique identifier for the configuration.';


--
-- Name: COLUMN timportconfig.config_name; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.config_name IS 'Descriptive name of the configuration.';


--
-- Name: COLUMN timportconfig.datasource; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.datasource IS 'Descriptive name of the data source (e.g., ''MeetMax'').';


--
-- Name: COLUMN timportconfig.datasettype; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.datasettype IS 'Descriptive name of the dataset type (e.g., ''MetaData'').';


--
-- Name: COLUMN timportconfig.source_directory; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.source_directory IS 'Absolute path to the directory containing input files.';


--
-- Name: COLUMN timportconfig.archive_directory; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.archive_directory IS 'Absolute path to the directory where files are archived after processing.';


--
-- Name: COLUMN timportconfig.file_pattern; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.file_pattern IS 'Pattern to match files (glob or regex, e.g., "*.csv" or "\d{8}T\d{6}_.*\.csv").';


--
-- Name: COLUMN timportconfig.file_type; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.file_type IS 'Type of file to process (CSV, XLS, XLSX).';


--
-- Name: COLUMN timportconfig.metadata_label_source; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.metadata_label_source IS 'Source of the metadata label (filename, file_content, or static user-defined value).';


--
-- Name: COLUMN timportconfig.metadata_label_location; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.metadata_label_location IS 'Location details for metadata extraction (position index for filename, column name for file_content, user-defined value for static).';


--
-- Name: COLUMN timportconfig.dateconfig; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.dateconfig IS 'Source of date metadata (filename, file_content, or static date value).';


--
-- Name: COLUMN timportconfig.datelocation; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.datelocation IS 'Location details for date extraction (position index for filename, column name for file_content, fixed date for static).';


--
-- Name: COLUMN timportconfig.dateformat; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.dateformat IS 'Format of the date (e.g., ''yyyyMMddTHHmmss'' for ''20250520T214109'', ''yyyy-MM-dd'' for ''2025-05-16'').';


--
-- Name: COLUMN timportconfig.delimiter; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.delimiter IS 'Delimiter used for parsing filenames (e.g., ''_'', NULL if not applicable).';


--
-- Name: COLUMN timportconfig.target_table; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.target_table IS 'Target database table for the imported data.';


--
-- Name: COLUMN timportconfig.importstrategyid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.importstrategyid IS 'Foreign key to importstrategy table, defining how to handle column mismatches (e.g., add new columns, ignore, or fail).';


--
-- Name: COLUMN timportconfig.is_active; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.is_active IS 'Flag indicating whether the configuration is active (1 = active, 0 = inactive).';


--
-- Name: COLUMN timportconfig.created_at; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.created_at IS 'Timestamp when the configuration was created.';


--
-- Name: COLUMN timportconfig.last_modified_at; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.timportconfig.last_modified_at IS 'Timestamp when the configuration was last modified.';


--
-- Name: timportconfig_config_id_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.timportconfig_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timportconfig_config_id_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.timportconfig_config_id_seq OWNED BY dba.timportconfig.config_id;


--
-- Name: timportconfig config_id; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.timportconfig ALTER COLUMN config_id SET DEFAULT nextval('dba.timportconfig_config_id_seq'::regclass);


--
-- Name: timportconfig timportconfig_config_name_key; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.timportconfig
    ADD CONSTRAINT timportconfig_config_name_key UNIQUE (config_name);


--
-- Name: timportconfig timportconfig_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.timportconfig
    ADD CONSTRAINT timportconfig_pkey PRIMARY KEY (config_id);


--
-- Name: timportconfig fk_importstrategyid; Type: FK CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.timportconfig
    ADD CONSTRAINT fk_importstrategyid FOREIGN KEY (importstrategyid) REFERENCES dba.timportstrategy(importstrategyid);


--
-- PostgreSQL database dump complete
--

\unrestrict ARTTlywBkUlCdCNKOoD1OMOEr0E24N4cTI3l4fV2MsLsc3D31q2o0mfuqX1pnk6

