--
-- PostgreSQL database dump
--

\restrict fi6BOMlZXJrHG2r6ZBHjGMq9OSha1hqPi8qOeqtMLdZKuweOwEAgI6jrcrcos1b

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
-- Name: tinboxconfig; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tinboxconfig (
    config_id integer NOT NULL,
    config_name character varying(255) NOT NULL,
    gmail_account character varying(255) NOT NULL,
    subject_pattern character varying(255),
    has_attachment boolean DEFAULT false,
    attachment_name_pattern character varying(255),
    local_repository_path character varying(255) NOT NULL,
    is_active boolean DEFAULT true,
    created_by character varying(255) DEFAULT CURRENT_USER,
    created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: tinboxconfig_config_id_seq; Type: SEQUENCE; Schema: dba; Owner: -
--

CREATE SEQUENCE dba.tinboxconfig_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tinboxconfig_config_id_seq; Type: SEQUENCE OWNED BY; Schema: dba; Owner: -
--

ALTER SEQUENCE dba.tinboxconfig_config_id_seq OWNED BY dba.tinboxconfig.config_id;


--
-- Name: tinboxconfig config_id; Type: DEFAULT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tinboxconfig ALTER COLUMN config_id SET DEFAULT nextval('dba.tinboxconfig_config_id_seq'::regclass);


--
-- Name: tinboxconfig tinboxconfig_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tinboxconfig
    ADD CONSTRAINT tinboxconfig_pkey PRIMARY KEY (config_id);


--
-- Name: idx_tinboxconfig_is_active; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tinboxconfig_is_active ON dba.tinboxconfig USING btree (is_active);


--
-- PostgreSQL database dump complete
--

\unrestrict fi6BOMlZXJrHG2r6ZBHjGMq9OSha1hqPi8qOeqtMLdZKuweOwEAgI6jrcrcos1b

