--
-- PostgreSQL database dump
--

\restrict 3gB37KJz4y1IEs4AemeVgbUW50ZQFttYQCPS9CM3aMPkxs3KsXccS1sMETTsm2h

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
-- Name: ttickerexceptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ttickerexceptions (
    tickerexceptionid integer NOT NULL,
    tickername character varying(255) NOT NULL
);


--
-- Name: ttickerexceptions_tickerexceptionid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ttickerexceptions_tickerexceptionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ttickerexceptions_tickerexceptionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ttickerexceptions_tickerexceptionid_seq OWNED BY public.ttickerexceptions.tickerexceptionid;


--
-- Name: ttickerexceptions tickerexceptionid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ttickerexceptions ALTER COLUMN tickerexceptionid SET DEFAULT nextval('public.ttickerexceptions_tickerexceptionid_seq'::regclass);


--
-- Name: ttickerexceptions ttickerexceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ttickerexceptions
    ADD CONSTRAINT ttickerexceptions_pkey PRIMARY KEY (tickerexceptionid);


--
-- PostgreSQL database dump complete
--

\unrestrict 3gB37KJz4y1IEs4AemeVgbUW50ZQFttYQCPS9CM3aMPkxs3KsXccS1sMETTsm2h

