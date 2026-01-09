--
-- PostgreSQL database dump
--

\restrict yV6Rp26NvHhvwarN6Qp9BycWywr9I56kgRiocOABF5f9dkZI4vNSLXrtvcmhuZm

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
-- Name: tmaintenancelog; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tmaintenancelog (
    logid integer NOT NULL,
    maintenancetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    operation character varying(50) NOT NULL,
    tablename character varying(100),
    username character varying(50),
    durationseconds double precision,
    details text
);


--
-- Name: tmaintenancelog_logid_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tmaintenancelog_logid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tmaintenancelog_logid_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tmaintenancelog_logid_seq OWNED BY dba.tmaintenancelog.logid;


--
-- Name: tmaintenancelog logid; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tmaintenancelog ALTER COLUMN logid SET DEFAULT nextval('dba.tmaintenancelog_logid_seq'::regclass);


--
-- Name: tmaintenancelog tmaintenancelog_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tmaintenancelog
    ADD CONSTRAINT tmaintenancelog_pkey PRIMARY KEY (logid);


--
-- Name: idx_tmaintenancelog_maintenancetime; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tmaintenancelog_maintenancetime ON dba.tmaintenancelog USING btree (maintenancetime);


--
-- PostgreSQL database dump complete
--

\unrestrict yV6Rp26NvHhvwarN6Qp9BycWywr9I56kgRiocOABF5f9dkZI4vNSLXrtvcmhuZm

