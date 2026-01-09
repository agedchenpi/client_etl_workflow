--
-- PostgreSQL database dump
--

\restrict b3pqkbewXjokRxEWFZVN593t6d8fKQfgsfa9EhQNPohCsuaFk4XbPmsFbhPV6b8

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
-- Name: tdataset; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tdataset (
    datasetid integer NOT NULL,
    datasetdate date NOT NULL,
    label character varying(100) NOT NULL,
    datasettypeid integer NOT NULL,
    datasourceid integer NOT NULL,
    datastatusid integer NOT NULL,
    efffromdate timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    effthrudate timestamp without time zone DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NOT NULL,
    isactive boolean DEFAULT true NOT NULL,
    createddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    createdby character varying(50) DEFAULT CURRENT_USER NOT NULL,
    CONSTRAINT chk_eff_dates CHECK ((efffromdate <= effthrudate))
);


--
-- Name: TABLE tdataset; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tdataset IS 'Tracks metadata for dataset loads in the ETL pipeline.';


--
-- Name: COLUMN tdataset.datasetid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.datasetid IS 'Primary key for the dataset.';


--
-- Name: COLUMN tdataset.datasetdate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.datasetdate IS 'Date associated with the dataset (e.g., data reference date).';


--
-- Name: COLUMN tdataset.label; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.label IS 'Descriptive label for the dataset.';


--
-- Name: COLUMN tdataset.datasettypeid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.datasettypeid IS 'Foreign key to tdatasettype, indicating dataset type.';


--
-- Name: COLUMN tdataset.datasourceid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.datasourceid IS 'Foreign key to tdatasource, indicating data source.';


--
-- Name: COLUMN tdataset.datastatusid; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.datastatusid IS 'Foreign key to tdatastatus, indicating dataset status.';


--
-- Name: COLUMN tdataset.efffromdate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.efffromdate IS 'Effective start date, defaults to creation time.';


--
-- Name: COLUMN tdataset.effthrudate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.effthrudate IS 'Effective end date, defaults to 9999-01-01 for active records.';


--
-- Name: COLUMN tdataset.isactive; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.isactive IS 'Indicates if the dataset is active (TRUE) or inactive (FALSE).';


--
-- Name: COLUMN tdataset.createddate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.createddate IS 'Timestamp when the record was created.';


--
-- Name: COLUMN tdataset.createdby; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tdataset.createdby IS 'User who created the record.';


--
-- Name: tdataset_datasetid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tdataset_datasetid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tdataset_datasetid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tdataset_datasetid_seq OWNED BY dba.tdataset.datasetid;


--
-- Name: tdataset datasetid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdataset ALTER COLUMN datasetid SET DEFAULT nextval('dba.tdataset_datasetid_seq'::regclass);


--
-- Name: tdataset tdataset_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdataset
    ADD CONSTRAINT tdataset_pkey PRIMARY KEY (datasetid);


--
-- Name: idx_tdataset_datasetdate; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tdataset_datasetdate ON dba.tdataset USING btree (datasetdate);


--
-- Name: idx_tdataset_datasetid; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tdataset_datasetid ON dba.tdataset USING btree (datasetid, datasetdate);


--
-- Name: idx_tdataset_date_desc; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tdataset_date_desc ON dba.tdataset USING btree (datasetdate DESC) WHERE ((isactive = true) AND (datasettypeid = 2));


--
-- Name: idx_tdataset_isactive; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tdataset_isactive ON dba.tdataset USING btree (isactive);


--
-- Name: idx_tdataset_type_active_date; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tdataset_type_active_date ON dba.tdataset USING btree (datasettypeid, isactive, datasetdate);


--
-- Name: tdataset ttriggerenforcesingleactivedataset; Type: TRIGGER; Schema: dba; Owner: -
--

CREATE TRIGGER ttriggerenforcesingleactivedataset AFTER INSERT OR UPDATE OF isactive ON dba.tdataset FOR EACH ROW WHEN ((new.isactive = true)) EXECUTE FUNCTION dba.fenforcesingleactivedataset();


--
-- Name: tdataset fk_dataset_source; Type: FK CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdataset
    ADD CONSTRAINT fk_dataset_source FOREIGN KEY (datasourceid) REFERENCES dba.tdatasource(datasourceid);


--
-- Name: tdataset fk_dataset_status; Type: FK CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdataset
    ADD CONSTRAINT fk_dataset_status FOREIGN KEY (datastatusid) REFERENCES dba.tdatastatus(datastatusid);


--
-- Name: tdataset fk_dataset_type; Type: FK CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tdataset
    ADD CONSTRAINT fk_dataset_type FOREIGN KEY (datasettypeid) REFERENCES dba.tdatasettype(datasettypeid);


--
-- PostgreSQL database dump complete
--

\unrestrict b3pqkbewXjokRxEWFZVN593t6d8fKQfgsfa9EhQNPohCsuaFk4XbPmsFbhPV6b8

