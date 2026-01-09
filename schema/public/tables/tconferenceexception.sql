--
-- PostgreSQL database dump
--

\restrict tRY6vBfRc4w0UBha6LhyZuSPTondJbj0IdZ1TlCtvfyZfNvl1MhU4QgAy4qpbMj

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
-- Name: tconferenceexception; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tconferenceexception (
    conferenceexceptionid integer NOT NULL,
    conferencename character varying(255) NOT NULL
);


--
-- Name: tconferenceexception_conferenceexceptionid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tconferenceexception_conferenceexceptionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tconferenceexception_conferenceexceptionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tconferenceexception_conferenceexceptionid_seq OWNED BY public.tconferenceexception.conferenceexceptionid;


--
-- Name: tconferenceexception conferenceexceptionid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tconferenceexception ALTER COLUMN conferenceexceptionid SET DEFAULT nextval('public.tconferenceexception_conferenceexceptionid_seq'::regclass);


--
-- Name: tconferenceexception tconferenceexception_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tconferenceexception
    ADD CONSTRAINT tconferenceexception_pkey PRIMARY KEY (conferenceexceptionid);


--
-- PostgreSQL database dump complete
--

\unrestrict tRY6vBfRc4w0UBha6LhyZuSPTondJbj0IdZ1TlCtvfyZfNvl1MhU4QgAy4qpbMj

