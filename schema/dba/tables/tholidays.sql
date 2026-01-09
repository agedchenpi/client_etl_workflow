--
-- PostgreSQL database dump
--

\restrict 8FALHK1Fxch6f0ju7FPKocrMuU0v6nu9huRrh1G82xD2RrJueode7cGJQiGAMC0

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
-- Name: tholidays; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tholidays (
    holiday_date date NOT NULL,
    holiday_name text,
    createddate timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    createdby character varying(50) DEFAULT CURRENT_USER NOT NULL
);


--
-- Name: TABLE tholidays; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tholidays IS 'Stores holiday dates for business day calculations.';


--
-- Name: COLUMN tholidays.holiday_date; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tholidays.holiday_date IS 'The date of the holiday (primary key).';


--
-- Name: COLUMN tholidays.holiday_name; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tholidays.holiday_name IS 'Name of the holiday.';


--
-- Name: COLUMN tholidays.createddate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tholidays.createddate IS 'Timestamp when the record was created.';


--
-- Name: COLUMN tholidays.createdby; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tholidays.createdby IS 'User who created the record.';


--
-- Name: tholidays tholidays_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tholidays
    ADD CONSTRAINT tholidays_pkey PRIMARY KEY (holiday_date);


--
-- PostgreSQL database dump complete
--

\unrestrict 8FALHK1Fxch6f0ju7FPKocrMuU0v6nu9huRrh1G82xD2RrJueode7cGJQiGAMC0

