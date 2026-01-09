--
-- PostgreSQL database dump
--

\restrict ewMJGJWQfdC5yS2K5E259JW7cjQs2Al63oMsVtEKi2X9NOHqv0vXwWOxM2K8SDV

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
-- Name: thistorical_cancellations_snapshot; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thistorical_cancellations_snapshot (
    id integer NOT NULL,
    source character varying(50),
    company_name character varying(255),
    ticker character varying(50),
    event_name character varying(255),
    min_date date,
    max_date date,
    cancellation_date date,
    status character varying(50),
    snapshot_date date DEFAULT '2025-11-14'::date
);


--
-- Name: thistorical_cancellations_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.thistorical_cancellations_snapshot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: thistorical_cancellations_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.thistorical_cancellations_snapshot_id_seq OWNED BY public.thistorical_cancellations_snapshot.id;


--
-- Name: thistorical_cancellations_snapshot id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thistorical_cancellations_snapshot ALTER COLUMN id SET DEFAULT nextval('public.thistorical_cancellations_snapshot_id_seq'::regclass);


--
-- Name: thistorical_cancellations_snapshot thistorical_cancellations_snapshot_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thistorical_cancellations_snapshot
    ADD CONSTRAINT thistorical_cancellations_snapshot_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict ewMJGJWQfdC5yS2K5E259JW7cjQs2Al63oMsVtEKi2X9NOHqv0vXwWOxM2K8SDV

