--
-- PostgreSQL database dump
--

\restrict TV9d6NzLbz9BD16hRfQguc3okijFc4N3BTEgr2mS6Hyhe4bj12yFwkjZw6caqbd

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
-- Name: tcalendardays; Type: TABLE; Schema: dba; Owner: -
--

CREATE TABLE dba.tcalendardays (
    fulldate date NOT NULL,
    downame character varying(10),
    downum integer,
    isbusday boolean,
    isholiday boolean,
    previous_business_date date
);


--
-- Name: TABLE tcalendardays; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON TABLE dba.tcalendardays IS 'Stores calendar dates with business day and holiday information for ETL date calculations.';


--
-- Name: COLUMN tcalendardays.fulldate; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tcalendardays.fulldate IS 'The date (primary key).';


--
-- Name: COLUMN tcalendardays.downame; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tcalendardays.downame IS 'Day of week name (e.g., Monday).';


--
-- Name: COLUMN tcalendardays.downum; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tcalendardays.downum IS 'Day of week number (0=Sunday, 1=Monday, ..., 6=Saturday).';


--
-- Name: COLUMN tcalendardays.isbusday; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tcalendardays.isbusday IS 'True if the date is a business day (Monday-Friday), False otherwise.';


--
-- Name: COLUMN tcalendardays.isholiday; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tcalendardays.isholiday IS 'True if the date is a holiday, False otherwise.';


--
-- Name: COLUMN tcalendardays.previous_business_date; Type: COMMENT; Schema: dba; Owner: -
--

COMMENT ON COLUMN dba.tcalendardays.previous_business_date IS 'The most recent business day before this date.';


--
-- Name: tcalendardays tcalendardays_pkey; Type: CONSTRAINT; Schema: dba; Owner: -
--

ALTER TABLE ONLY dba.tcalendardays
    ADD CONSTRAINT tcalendardays_pkey PRIMARY KEY (fulldate);


--
-- Name: idx_tcalendardays_fulldate; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tcalendardays_fulldate ON dba.tcalendardays USING btree (fulldate);


--
-- Name: idx_tcalendardays_fulldate_busday; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tcalendardays_fulldate_busday ON dba.tcalendardays USING btree (fulldate DESC) WHERE ((isbusday = true) AND (isholiday = false));


--
-- Name: idx_tcalendardays_isbusday; Type: INDEX; Schema: dba; Owner: -
--

CREATE INDEX idx_tcalendardays_isbusday ON dba.tcalendardays USING btree (isbusday);


--
-- PostgreSQL database dump complete
--

\unrestrict TV9d6NzLbz9BD16hRfQguc3okijFc4N3BTEgr2mS6Hyhe4bj12yFwkjZw6caqbd

