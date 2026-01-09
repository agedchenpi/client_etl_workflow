--
-- PostgreSQL database dump
--

\restrict rl5IdqQawJj585UnGMrcl69EITPXHKfK6sDpmlpakFZaj0XMOzuDN8uTKqrrCZ9

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
-- Name: ttableindexstats; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.ttableindexstats (
    statid integer NOT NULL,
    snapshottime timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    schemaname character varying(100),
    tablename character varying(100),
    indexname character varying(100),
    rowcount bigint,
    seqscans bigint,
    idxscans bigint,
    inserts bigint,
    updates bigint,
    deletes bigint,
    totalsize bigint
);


--
-- Name: ttableindexstats_statid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.ttableindexstats_statid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ttableindexstats_statid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.ttableindexstats_statid_seq OWNED BY dba.ttableindexstats.statid;


--
-- Name: ttableindexstats statid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.ttableindexstats ALTER COLUMN statid SET DEFAULT nextval('dba.ttableindexstats_statid_seq'::regclass);


--
-- Name: ttableindexstats ttableindexstats_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.ttableindexstats
    ADD CONSTRAINT ttableindexstats_pkey PRIMARY KEY (statid);


--
-- Name: idx_ttableindexstats_snapshottime; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_ttableindexstats_snapshottime ON dba.ttableindexstats USING btree (snapshottime);


--
-- PostgreSQL database dump complete
--

\unrestrict rl5IdqQawJj585UnGMrcl69EITPXHKfK6sDpmlpakFZaj0XMOzuDN8uTKqrrCZ9

