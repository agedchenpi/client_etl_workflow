--
-- PostgreSQL database dump
--

\restrict Vww8bqXtuVXjLfniCJfgkOQMhpXRReaFhZZGHLiPcdqt4jQvHm90raXhvgjDo7h

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
-- Name: tmeetmaxevent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tmeetmaxevent (
    tmeetmaxeventid integer NOT NULL,
    datasetid integer NOT NULL,
    company_name character varying(255),
    ticker character varying(255),
    market_cap_tier character varying(255),
    analyst character varying(255),
    company_type character varying(255),
    "unnamed:_5" character varying(255),
    reps character varying(255),
    sector character varying(255),
    market_cap character varying(255),
    presentation_format character varying(255),
    "available_for_1x1s?" character varying(255),
    market_exchange character varying(255),
    start_time character varying(255),
    "just_hosting_1_on_1's" character varying(255),
    hosting_meetings character varying(255),
    "participation_days:" character varying(255),
    confirmed_participation_date character varying(255),
    presentation_type character varying(255),
    "do_you_want_1x1s_with_institutional_equity_investors?" character varying(255),
    "do_you_want_1x1s_with_private_equity_investors?" character varying(255),
    "do_you_want_1x1s_with_venture_capitalists?" character varying(255),
    "unnamed:_1" character varying(255),
    "unnamed:_2" character varying(255),
    "unnamed:_3" character varying(255),
    added character varying(255),
    "mkt_cap_($mm)" character varying(255),
    "company/organization" character varying(255),
    industry character varying(255),
    company_description character varying(4000),
    "market_cap_(usd$mm)" character varying(255),
    roth_sub_sector character varying(255),
    confirmed_date character varying(255),
    "unnamed:_0" character varying(255),
    primary_commodity character varying(255),
    stock_exchange character varying(255),
    participation_day character varying(255),
    participation_type character varying(255),
    date_added character varying(255),
    participation_date character varying(255),
    country character varying(255),
    private_biotech_day character varying(255),
    webcasting character varying(255),
    industry_type character varying(255),
    one_page_company_overview character varying(255),
    status character varying(255),
    participation_days character varying(255),
    "unnamed:_4" character varying(255),
    "do_you_want_1x1s_with_venture_capital_investors?" character varying(255),
    roth_sector character varying(255),
    sub_sector character varying(255),
    "market_cap_(us$m)" character varying(255),
    "market_cap_(eurosm)" character varying(255),
    "do_you_want_to_host_1x1_meetings?" character varying(255),
    ebitda_range character varying(255),
    cad_listing character varying(255),
    company_website character varying(255),
    "do_you_want_to_host_a_q&a_breakout_session?" character varying(255),
    "mkt_cap_(usd$m)" character varying(255),
    "1_on_1's" character varying(255),
    participation character varying(255),
    stage character varying(255),
    "do_you_want_to_participate_in_1x1_meetings?" character varying(255),
    organization_description character varying(2016),
    website character varying(255),
    "market_cap_($m)" character varying(255),
    "what_days_are_you_participating?" character varying(255),
    "market_cap_($mm)" character varying(255),
    company_ticker character varying(255),
    "available_for_1_on_1's?" character varying(255),
    presentation character varying(255),
    industry_sector character varying(255),
    "available_for_investor_meetings_(i.e._1x1s)?" character varying(255),
    "company_description_(bio)" character varying(3916),
    "will_your_company_be_attending_in_person_or_virtually?" character varying(255),
    type character varying(255),
    "privatrak_/_public" character varying(255),
    speakers character varying(255),
    setor character varying(255),
    speaker_name character varying(255),
    registered_date character varying(255),
    company_subsector character varying(292),
    "market_cap_(in_usd_$m_unless_otherwise_noted)" character varying(255),
    "country/market" character varying(255),
    "market_cap_($'m)" character varying(255),
    "meeting_date_&_time" character varying(255),
    location character varying(255),
    dinner character varying(255),
    "market_cap_(eurm)" character varying(255),
    description character varying(255),
    "market_cap_(us$_m)" character varying(255),
    company_sectors character varying(255),
    "do_you_want_b2b/bd_1x1s_with_other_healthcare_companies?" character varying(255),
    data character varying(255),
    "do_you_want_b2bs_with_other_healthcare_companies?" character varying(255),
    "virtual_3/11" character varying(255),
    "nyc_3/12" character varying(255),
    "virtual_3/12" character varying(255),
    "market_cap_(in_millions)" character varying(255),
    "do_you_want_to_meet_with_public_investors?" character varying(255),
    "do_you_want_to_meet_with_private_investors?" character varying(255),
    "unnamed:_6" character varying(255),
    "unnamed:_7" character varying(255),
    "unnamed:_8" character varying(255),
    "do_you_want_to_meet_with_private_equity_investors?" character varying(255),
    "do_you_want_to_meet_with_public_equity_investors?" character varying(255),
    "do_you_want_to_meet_with_venture_capitalists?" character varying(255),
    "virtual_3/10" character varying(255),
    "nyc_3/11" character varying(255),
    fireside_chat character varying(255),
    website_address character varying(255),
    webcast_link character varying(255),
    "do_you_want_to_present?" character varying(255),
    primary_region_focus character varying(255),
    commodity character varying(255),
    market_cap_filter character varying(255),
    attendance character varying(255),
    "therapeutic_area(s)" character varying(255)
);


--
-- Name: tmeetmaxevent_tmeetmaxeventid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tmeetmaxevent_tmeetmaxeventid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tmeetmaxevent_tmeetmaxeventid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tmeetmaxevent_tmeetmaxeventid_seq OWNED BY public.tmeetmaxevent.tmeetmaxeventid;


--
-- Name: tmeetmaxevent tmeetmaxeventid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxevent ALTER COLUMN tmeetmaxeventid SET DEFAULT nextval('public.tmeetmaxevent_tmeetmaxeventid_seq'::regclass);


--
-- Name: tmeetmaxevent tmeetmaxevent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxevent
    ADD CONSTRAINT tmeetmaxevent_pkey PRIMARY KEY (tmeetmaxeventid);


--
-- Name: tmeetmaxevent tmeetmaxevent_datasetid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmeetmaxevent
    ADD CONSTRAINT tmeetmaxevent_datasetid_fkey FOREIGN KEY (datasetid) REFERENCES dba.tdataset(datasetid);


--
-- PostgreSQL database dump complete
--

\unrestrict Vww8bqXtuVXjLfniCJfgkOQMhpXRReaFhZZGHLiPcdqt4jQvHm90raXhvgjDo7h

