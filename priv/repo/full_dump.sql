--
-- PostgreSQL database dump
--

-- Dumped from database version 14.6 (Homebrew)
-- Dumped by pg_dump version 14.6 (Homebrew)

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

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: albums; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.albums (
    id bigint NOT NULL,
    name character varying(255),
    genre character varying(255),
    year character varying(255),
    release_date date,
    is_owned boolean DEFAULT false NOT NULL,
    path character varying(255),
    image_url character varying(255),
    artist_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: albums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.albums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: albums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.albums_id_seq OWNED BY public.albums.id;


--
-- Name: artists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artists (
    id bigint NOT NULL,
    name character varying(255),
    path character varying(255),
    image_url character varying(255),
    checked_at timestamp without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    icon character varying(255),
    subject character varying(255),
    body text,
    url text,
    type character varying(255),
    seen_at timestamp without time zone,
    album_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    hashed_password character varying(255) NOT NULL,
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_tokens_id_seq OWNED BY public.users_tokens.id;


--
-- Name: albums id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums ALTER COLUMN id SET DEFAULT nextval('public.albums_id_seq'::regclass);


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens ALTER COLUMN id SET DEFAULT nextval('public.users_tokens_id_seq'::regclass);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_tokens users_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_pkey PRIMARY KEY (id);


--
-- Name: albums_artist_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX albums_artist_id_index ON public.albums USING btree (artist_id);


--
-- Name: albums_artist_id_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX albums_artist_id_name_index ON public.albums USING btree (artist_id, name);


--
-- Name: artists_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX artists_name_index ON public.artists USING btree (name);


--
-- Name: notifications_album_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_album_id_index ON public.notifications USING btree (album_id);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_tokens_context_token_index ON public.users_tokens USING btree (context, token);


--
-- Name: users_tokens_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_tokens_user_id_index ON public.users_tokens USING btree (user_id);


--
-- Name: albums albums_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: notifications notifications_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id);


--
-- Name: users_tokens users_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20230112070014);
INSERT INTO public."schema_migrations" (version) VALUES (20230113070010);
INSERT INTO public."schema_migrations" (version) VALUES (20230113212925);
INSERT INTO public."schema_migrations" (version) VALUES (20230117084126);

--
-- Inject initial demo data from my machine. I know this is bad practice but this may quickly seed Fly.io
--

--
-- Artists
--

INSERT INTO public."artists" ("id", "name", "path", "image_url", "checked_at", "inserted_at", "updated_at") VALUES
(1, '3 Body Problem', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/3 Body Problem', NULL, NULL, '2023-01-17 20:42:14', '2023-01-17 20:42:14'),
(2, '5 Of 6', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/5 of 6', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(3, 'A_rival', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/A_Rival', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(4, 'Abigail Williams', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Abigail Williams', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(9, 'Acquire A Capella', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Acquire A Capella', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(10, 'Affiance', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Affiance', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(11, 'After The Burial', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/After The Burial', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(13, 'Alec Holowka', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Alec Holowka', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(14, 'Animals As Leaders', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Animals as Leaders', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(19, 'Atreyu', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Soundtrack/Underworld Evolution', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(27, 'August Burns Red', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/August Burns Red', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(30, 'Avatar', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avatar', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(31, 'Avenged Sevenfold', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avenged Sevenfold', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(37, 'Baroness', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(45, 'Baroness/unpersons', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness_Unpersons', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(46, 'Ben Landis', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ben Landis', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(47, 'Between The Buried And Me', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Between the Buried and Me', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(50, 'Blindside', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blindside', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(55, 'Blink-182', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blink-182', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(61, 'Born Of Osiris', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Born of Osiris', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(64, 'Lamb Of God', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(65, 'C-jeff', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/C-jeff', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(66, 'C418', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/C418', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(69, 'Caligula''s Horse', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Caligula''s Horse', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(70, 'Chemical Brothers, The', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chemical Brothers, the', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(72, 'Chevelle', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(80, 'Chimaira', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chimaira', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(81, 'Chuck Ragan', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chuck Ragan', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(82, 'Coheed And Cambria', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Coheed and Cambria', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(86, 'Between The Buried, Me', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Compilations/Automata II', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(87, 'Jars Of Clay', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(88, 'Crossfader Chris', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Crossfade', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(89, 'Dain Saint', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Dain Saint', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(90, 'Danny Baranowsky', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Danny Baranowsky', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(91, 'David Saulesco', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/David Saulesco', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(92, 'Death Before Dishonor', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Death Before Dishonor', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(93, 'Deftones', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(101, 'Demon Hunter', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Demon Hunter', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(102, 'Despised Icon', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Despised Icon', NULL, NULL, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(106, 'Disasterpeace', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tim O''Brien/Traveler', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(109, 'Eirik Suhrke', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Eirik Suhrke', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(110, 'Eminem', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Eminem', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(111, 'Fair To Midland', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Fair to Midland', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(113, 'Faith No More', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Faith No More', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(116, 'The Devil Wears Prada', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Devil Wears Prada', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(117, 'Filter', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Filter', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(121, 'Flyleaf', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Flyleaf', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(122, 'Francisco Cerda', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Francisco Cerda', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(123, 'Tsukasa Saitoh', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/FromSoftware/ELDEN RING ORIGINAL SOUNDTRACK', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(124, 'George & Jonathan', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/George & Jonathan', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(126, 'Glass Cloud', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Glass Cloud', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(128, 'Module', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/God Module', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(129, 'Gojira', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Gojira', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(134, 'Hans Zimmer', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Hans Zimmer', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(135, 'He Is Legend', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/He Is Legend', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(138, 'Hyperduck Soundworks', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/HyperDuck SoundWorks', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(140, 'Ill Nino', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Nino', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(147, 'Ill Niño', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Niño', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(148, 'Inverse Phase', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Inverse Phase', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(149, 'Jack White', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jack White', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(150, 'Jake Kaufman', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jake Kaufman', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(167, 'Jessica Curry', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jessica Curry', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(168, 'Chris Quilala', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jesus Culture/Awakening_ Live From Chicago (Live)', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(169, 'Jesus Culture', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jesus Culture', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(170, 'Chris Quilala/jesus Culture', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jesus Culture/Your Love Never Fails Disc 1', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(171, 'Jim Guthrie', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jim Guthrie', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(173, 'Flashygoodness', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jim Noir/Tower of Love', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(174, 'Josh Whelchel', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Josh Whelchel', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(178, 'Kan R. Gao, Feat. Laura Shigihara', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Kan R. Gao, feat. Laura Shigihara', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(179, 'Kendrick Lamar', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Kendrick Lamar', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(180, 'Kid Cudi', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Kid Cudi', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(181, 'Killswitch Engage', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Killswitch Engage', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(183, 'Korn', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(203, 'In The Nursery', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/anosou/Cobalt EP', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(204, 'Mastodon', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mastodon', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(207, 'Matisyahu', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Matisyahu', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(209, 'Meshuggah', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Meshuggah', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(210, 'Monuments', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Monuments', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(213, 'Mudvayne', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mudvayne', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(218, 'Nonpoint', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Nonpoint', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(220, 'The Ocean', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Ocean', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(221, 'The Octopus Project', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Original Soundtrack/Amadeus_ Music from the Original Soundtrack of the Film, Vol. 2', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(222, 'Pantera', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Pantera', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(227, 'Parkway Drive', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(235, 'Periphery', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(241, 'Peter Hollens & Lindsey Stirling', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Peter Hollens & Lindsey Stirling', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(242, 'Zircon', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/zircon', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(243, 'Cronos/probot', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Probot/Probot', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(244, 'Protest The Hero', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Protest The Hero', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(249, 'Puscifer', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Puscifer', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(251, 'Rage Against The Machine', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rage Against the Machine', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(255, 'Ravens & Wolves', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ravens & Wolves', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(256, 'Rings Of Saturn', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rings of Saturn', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(261, 'Rob Lach', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rob Lach', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(262, 'Romain Gauthier', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Romain Gauthier', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(263, 'Russian Circles', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Russian Circles', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(269, 'Scattle', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Scattle', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(270, 'Serj Tankian', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Serj Tankian', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(272, 'Sevendust', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sevendust', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(275, 'Skotein', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Skotein', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(276, 'Slipknot', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Slipknot', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(280, 'Souleye', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/SoulEye', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(281, 'Soundgarden', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Soundgarden', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(283, 'Staind', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Staind', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(290, 'Coda', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sticky Fingaz/A Day in the Life_ The Soundtrack Disc 1', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(291, 'Switched', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Switched', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(293, 'Sylosis', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sylosis', NULL, NULL, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(298, 'System Of A Down', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/System Of A Down', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(303, 'Taproot', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Taproot', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(306, 'Tenacious D', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tenacious D', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(307, 'Tesseract', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/TesseracT', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(310, 'The Dear Hunter', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Dear Hunter', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(324, 'The Safety Fire', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Safety Fire', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(325, 'The Tony Danza Tapdance Extravaganza', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Tony Danza Tapdance Extravaganza', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(327, 'These Arms Are Snakes', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/These Arms Are Snakes', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(329, 'Times Of Grace', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Times Of Grace', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(330, 'Tomáš Dvořák', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tomáš Dvořák', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(331, 'Tool', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tool', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(337, 'Trivium', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Unknown/Trivium', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(342, 'Blue Swede', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Various Artists/Guardians Of The Galaxy (Awesome Mix Vol. 1)', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(343, 'Veil Of Maya', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Veil Of Maya', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(344, 'Vildhjarta', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Vildhjarta', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(346, 'Volumes', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Volumes', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(349, 'Wilbert Roget, Ii', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Wilbert Roget, II', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(350, 'Will Reagan & United Pursuit', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Will Reagan & United Pursuit', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(351, 'Within The Ruins', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Within The Ruins', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(358, '"Weird Al" Yankovic', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/_Weird Al_ Yankovic', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(359, 'Anosou', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/anosou', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(361, 'Big Giant Circles', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/big giant circles', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(363, 'Db Soundworks', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/dB soundworks', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(364, 'Mc Chris', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/mc chris', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(365, 'Virt, Freaky Dna And Norrin Radd', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/virt, Freaky DNA and Norrin Radd', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(366, 'Yogurtbox', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/yogurtbox', NULL, NULL, '2023-01-17 20:42:17', '2023-01-17 20:42:17');

--
-- Albums
--

INSERT INTO public."albums" ("id", "name", "genre", "year", "release_date", "is_owned", "path", "image_url", "artist_id", "inserted_at", "updated_at") VALUES
(1, 'Tiny & Big: Music To Cut Rocks By', '(24)', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/3 Body Problem/Tiny & Big_ Music To Cut Rocks By', NULL, 1, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(2, 'Songs for the Cure ''10', NULL, '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/5 of 6/Songs for the Cure ''10', NULL, 2, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(3, '8-Bit Pimp', 'Electronica', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/A_Rival/8-Bit Pimp', NULL, 3, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(4, 'Becoming', 'Black Metal', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Abigail Williams/Becoming', NULL, 4, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(5, 'Gallow Hill', '(9)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Abigail Williams/Gallow Hill', NULL, 4, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(6, 'In the Shadow of 1000 Suns', '(9)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Abigail Williams/In the Shadow of 1000 Suns', NULL, 4, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(7, 'Legend', '(9)', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Abigail Williams/Legend', NULL, 4, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(8, 'Walk Beyond the Dark', 'Black Metal', '2019-11-15', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Abigail Williams/Walk Beyond the Dark', NULL, 4, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(9, 'Joypad Powerup', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Acquire A Capella/Joypad Powerup', NULL, 9, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(10, 'Blackout', 'Melodic Metalcore', '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Affiance/Blackout', NULL, 10, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(11, 'Dig Deep', NULL, '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/After The Burial/Dig Deep', NULL, 11, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(12, 'Wolves Within', 'Prog. Metalcore', '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/After The Burial/Wolves Within', NULL, 11, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(13, 'Aquaria: Original Soundtrack', NULL, '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Alec Holowka/Aquaria_ Original Soundtrack', NULL, 13, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(14, 'Animals As Leaders', 'Progressive Metal', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Animals as Leaders/Animals As Leaders', NULL, 14, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(15, 'Parrhesia', 'post-rock, prog-rock', '2022', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Animals as Leaders/Parrhesia', NULL, 14, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(16, 'The Joy of Motion', 'Progressive Metal', '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Animals as Leaders/The Joy of Motion', NULL, 14, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(17, 'The Madness of Many', 'Progressive Metal', '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Animals as Leaders/The Madness of Many', NULL, 14, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(18, 'Weightless', 'Metal', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Animals as Leaders/Weightless', NULL, 14, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(19, 'A Death-Grip On Yesterday [Instrumental]', 'Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Atreyu/A Death-Grip On Yesterday [Instrumental]', NULL, 19, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(20, 'A Death-Grip On Yesterday', 'Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Atreyu/A Death-Grip On Yesterday', NULL, 19, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(21, 'Baptize', 'Rock', '2021', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Atreyu/Baptize', NULL, 19, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(22, 'Congregation Of The Damned', 'Metal', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Atreyu/Congregation Of The Damned', NULL, 19, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(23, 'Fractures In The Facade Of Your Porcelain Beauty [EP]', 'Alternative & Punk', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Atreyu/Fractures In The Facade Of Your Porcelain Beauty [EP]', NULL, 19, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(24, 'Lead Sails Paper Anchor 2.0', NULL, '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Atreyu/Lead Sails Paper Anchor 2.0', NULL, 19, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(25, 'The Curse [Instrumental]', 'Hardcore Punk', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Atreyu/The Curse [Instrumental]', NULL, 19, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(26, 'The Curse', 'Metal', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Atreyu/The Curse', NULL, 19, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(27, 'Constellations', '(9)', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/August Burns Red/Constellations', NULL, 27, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(28, 'Leveler', '(9)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/August Burns Red/Leveler', NULL, 27, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(29, 'Messengers', '(9)', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/August Burns Red/Messengers', NULL, 27, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(30, 'Hail the Apocalypse', 'Metal', '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avatar/Hail the Apocalypse', NULL, 30, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(31, 'Avenged Sevenfold', 'Metal', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avenged Sevenfold/Avenged Sevenfold', NULL, 31, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(32, 'City of Evil', 'Heavy Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avenged Sevenfold/City of Evil', NULL, 31, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(33, 'Nightmare', 'Heavy Metal', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avenged Sevenfold/Nightmare', NULL, 31, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(34, 'Sounding the Seventh Trumpet', 'Metal', '2001', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avenged Sevenfold/Sounding the Seventh Trumpet', NULL, 31, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(35, 'The Stage (Deluxe Edition)', NULL, '2017', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avenged Sevenfold/The Stage (Deluxe Edition)', NULL, 31, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(36, 'Waking the Fallen', 'Hardcore', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Avenged Sevenfold/Waking the Fallen', NULL, 31, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(37, 'Blue Record', '(9)', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness/Blue Record', NULL, 37, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(38, 'First and Second', '(9)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness/First and Second', NULL, 37, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(39, 'First', '(17)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness/First', NULL, 37, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(40, 'Green', 'Metal', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness/Green', NULL, 37, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(41, 'Live at Roadburn', '(12)', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness/Live at Roadburn', NULL, 37, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(42, 'Red Album', '(9)', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness/Red Album', NULL, 37, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(43, 'Second', '(17)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness/Second', NULL, 37, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(44, 'Yellow', 'Metal', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness/Yellow', NULL, 37, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(45, 'A Grey Sigh in a Flower Husk', '(17)', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Baroness_Unpersons/A Grey Sigh in a Flower Husk', NULL, 45, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(46, 'Adventures in Pixels', NULL, '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ben Landis/Adventures in Pixels', NULL, 46, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(47, 'Automata I', 'Metal', '2018', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Between the Buried and Me/Automata I', NULL, 47, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(48, 'Colors II', 'Pop, Rock', '2021', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Between the Buried and Me/Colors II', NULL, 47, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(49, 'Coma Ecliptic', NULL, '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Between the Buried and Me/Coma Ecliptic', NULL, 47, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(50, 'A Thought Crushed My Mind', 'Post-Hardcore', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blindside/A Thought Crushed My Mind', NULL, 50, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(51, 'About a Burning Fire', 'Post-Hardcore', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blindside/About a Burning Fire', NULL, 50, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(52, 'Silence', 'Post-Hardcore', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blindside/Silence', NULL, 50, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(53, 'The Great Depression', 'Post-Hardcore', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blindside/The Great Depression', NULL, 50, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(54, 'With Shivering Hearts We Wait', 'Post-Hardcore', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blindside/With Shivering Hearts We Wait', NULL, 50, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(55, 'Blink-182', 'Punk Rock', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blink-182/Blink-182', NULL, 55, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(56, 'Cheshire Cat', 'Punk Rock', '1995', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blink-182/Cheshire Cat', NULL, 55, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(57, 'Dude Ranch', 'Punk Rock', '1997', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blink-182/Dude Ranch', NULL, 55, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(58, 'Enema of the State', 'Punk Rock', '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blink-182/Enema of the State', NULL, 55, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(59, 'Neighborhoods [Deluxe Edition]', 'Punk Rock', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blink-182/Neighborhoods [Deluxe Edition]', NULL, 55, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(60, 'Take Off Your Pants And Jacket', 'Punk Rock', '2001', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Blink-182/Take Off Your Pants And Jacket', NULL, 55, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(61, 'Soul Sphere', 'Progressive metalcore', '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Born of Osiris/Soul Sphere', NULL, 61, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(62, 'The Discovery', 'Metal', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Born of Osiris/The Discovery', NULL, 61, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(63, 'Tomorrow We Die ∆live', 'Deathcore', '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Born of Osiris/Tomorrow We Die ∆live', NULL, 61, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(64, 'Burn The Priest', '(9)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Burn the Priest/Burn The Priest', NULL, 64, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(65, 'Preschtale', NULL, '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/C-jeff/Preschtale', NULL, 65, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(66, '72 Minutes Of Fame', 'Unknown Genre', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/C418/72 Minutes Of Fame', NULL, 66, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(67, 'Minecraft - Volume Alpha', 'Unknown Genre', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/C418/Minecraft - Volume Alpha', NULL, 66, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(68, 'circle', 'Unknown Genre', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/C418/circle', NULL, 66, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(69, 'The Tide, The Thief & River''s End', NULL, '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Caligula''s Horse/The Tide, The Thief & River''s End', NULL, 69, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(70, 'Come With Us (XDUSTCD5, 7243 8 11682 2 6)', 'Electronic', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chemical Brothers, the/Come With Us (XDUSTCD5, 7243 8 11682 2 6)', NULL, 70, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(71, 'Dig Your Own Hole (XDUSTCD2, 7243 8 42950 2 8)', 'Electronic', '1997', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chemical Brothers, the/Dig Your Own Hole (XDUSTCD2, 7243 8 42950 2 8)', NULL, 70, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(72, 'Hats Off To The Bull', '(17)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle/Hats Off To The Bull', NULL, 72, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(73, 'Point #1', 'Rock', '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle/Point #1', NULL, 72, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(74, 'Sci-Fi Crimes', 'Rock', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle/Sci-Fi Crimes', NULL, 72, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(75, 'Stray Arrows - A Collection Of Favorites', 'Alternative', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle/Stray Arrows - A Collection Of Favorites', NULL, 72, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(76, 'The North Corridor', 'Alt.Metal', '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle/The North Corridor', NULL, 72, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(77, 'This Type Of Thinking (Could Do Us In)', 'Hard Rock', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle/This Type Of Thinking (Could Do Us In)', NULL, 72, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(78, 'Vena Sera', '(17)', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle/Vena Sera', NULL, 72, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(79, 'Wonder What''s Next', 'Rock', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chevelle/Wonder What''s Next', NULL, 72, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(80, 'Resurrection', 'Metalcore', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chimaira/Resurrection', NULL, 80, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(81, 'The Flame In The Flood', NULL, '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Chuck Ragan/The Flame In The Flood', NULL, 81, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(82, 'Good Apollo I''m Burning Star I', '(92)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Coheed and Cambria/Good Apollo I''m Burning Star I', NULL, 82, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(83, 'In Keeping Secrets of Silent Earth: 3 Disc 1', '(92)', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Coheed and Cambria/In Keeping Secrets of Silent Earth_ 3 Disc 1', NULL, 82, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(84, 'No World For Tomorrow', '(92)', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Coheed and Cambria/No World For Tomorrow', NULL, 82, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(85, 'The Second Stage Turbine Blade', '(20)', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Coheed and Cambria/The Second Stage Turbine Blade', NULL, 82, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(86, 'Automata II', NULL, '2018', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Compilations/Automata II', NULL, 86, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(87, 'Miscellaneous', '(24)', '1998', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Compilations/Miscellaneous', NULL, 87, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(88, 'Crossfade', '(17)', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Crossfade/Crossfade', NULL, 88, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(89, 'Indie-Mashup EP: Sharing is Caring', NULL, '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Dain Saint/Indie-Mashup EP_ Sharing is Caring', NULL, 89, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(90, 'Super Meat Boy! Digital Special Edition Soundtrack', '(12)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Danny Baranowsky/Super Meat Boy! Digital Special Edition Soundtrack', NULL, 90, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(91, 'Eternal Daughter Original Soundtrack', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/David Saulesco/Eternal Daughter Original Soundtrack', NULL, 91, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(92, 'True Till Death', '(20)', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Death Before Dishonor/True Till Death', NULL, 92, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(93, 'Adrenaline', NULL, '1995', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones/Adrenaline', NULL, 93, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(94, 'Around The Fur', NULL, '1997', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones/Around The Fur', NULL, 93, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(95, 'B-Sides & Rarities', 'Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones/B-Sides & Rarities', NULL, 93, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(96, 'Deftones', 'Rock', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones/Deftones', NULL, 93, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(97, 'Diamond Eyes', 'Rock', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones/Diamond Eyes (Leaked Dub)', NULL, 93, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(98, 'Gore', 'Rock', '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones/Gore', NULL, 93, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(99, 'Koi No Yokan', 'Rock', '2012-11-09T08:00:00Z', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones/Koi No Yokan', NULL, 93, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(100, 'White Pony (Black Box)', 'Rock', '2000', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Deftones/White Pony (Black Box)', NULL, 93, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(101, 'Extremist', 'Metal', '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Demon Hunter/Extremist', NULL, 101, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(102, 'Consumed By Your Poison', '(9)Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Despised Icon/Consumed By Your Poison', NULL, 102, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(103, 'Day of Mourning', 'Rock', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Despised Icon/Day of Mourning', NULL, 102, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(104, 'The Healing Process', 'Grindcore', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Despised Icon/The Healing Process', NULL, 102, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(105, 'The Ills Of Modern Man', 'Death Metal/Metalcore', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Despised Icon/The Ills Of Modern Man', NULL, 102, '2023-01-17 20:42:15', '2023-01-17 20:42:15'),
(106, 'Cat Astro Phi (Soundtrack)', NULL, '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Disasterpeace/Cat Astro Phi (Soundtrack)', NULL, 106, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(107, 'Shoot Many Robots', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Disasterpeace/Shoot Many Robots', NULL, 106, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(108, 'Songs for the Cure ''11: Remedy', '(12)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Disasterpeace/Songs for the Cure ''11_ Remedy', NULL, 106, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(109, 'Spelunky', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Eirik Suhrke/Spelunky', NULL, 109, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(110, 'The Marshall Mathers LP2', 'Contemporary Hip Hop', '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Eminem/The Marshall Mathers LP2', NULL, 110, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(111, 'Arrows & Anchors', 'Progressive Rock', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Fair to Midland/Arrows & Anchors', NULL, 111, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(112, 'Fables From A Mayfly: What I Tell You Three Times Is True', 'Progressive Rock', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Fair to Midland/Fables From A Mayfly_ What I Tell You Three Times Is True', NULL, 111, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(113, 'Angel Dust', 'Rock', '1992', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Faith No More/Angel Dust', NULL, 113, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(114, 'Easy - Songs To Make Love To', 'Alternative', '1993', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Faith No More/Easy - Songs To Make Love To', NULL, 113, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(115, 'The Real Thing', 'Rock', '1989', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Faith No More/The Real Thing', NULL, 113, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(116, 'With Roots Above And Branches Below', 'Metalcore', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ferret Music/With Roots Above And Branches Below', NULL, 116, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(117, 'Remixes for the Damned', '(17)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Filter/Remixes for the Damned', NULL, 117, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(118, 'Short Bus', '(9)', '1995', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Filter/Short Bus', NULL, 117, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(119, 'The Amalgamut', '(9)', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Filter/The Amalgamut', NULL, 117, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(120, 'Title of Record', '(9)', '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Filter/Title of Record', NULL, 117, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(121, 'Memento Mori (Deluxe Version)', 'Post-grunge', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Flyleaf/Memento Mori (Deluxe Version)', NULL, 121, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(122, 'Jamestown Soundtrack', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Francisco Cerda/Jamestown Soundtrack', NULL, 122, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(123, 'ELDEN RING ORIGINAL SOUNDTRACK', NULL, '2022', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/FromSoftware/ELDEN RING ORIGINAL SOUNDTRACK', NULL, 123, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(124, 'Beautiful Lifestyle', '(12)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/George & Jonathan/Beautiful Lifestyle', NULL, 124, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(125, 'The Best Music', NULL, '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/George & Jonathan/The Best Music', NULL, 124, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(126, 'Perfect War Forever EP', '(9)', '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Glass Cloud/Perfect War Forever EP', NULL, 126, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(127, 'The Royal Thousand', 'Mainstream Metal', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Glass Cloud/The Royal Thousand', NULL, 126, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(128, 'Viscera', '(9)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/God Module/Viscera', NULL, 128, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(129, 'From Mars to Sirius', '(9)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Gojira/From Mars to Sirius', NULL, 129, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(130, 'L''Enfant Sauvage [Special Edition] Disc 1', '(9)', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Gojira/L''Enfant Sauvage [Special Edition] Disc 1', NULL, 129, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(131, 'Magma', 'Metal', '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Gojira/Magma', NULL, 129, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(132, 'Terra Incognita', '(9)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Gojira/Terra Incognita', NULL, 129, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(133, 'The Way of All Flesh', '(9)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Gojira/The Way of All Flesh', NULL, 129, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(134, 'Inception (OST)', 'Soundtrack', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Hans Zimmer/Inception (OST)', NULL, 134, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(135, '91025', '(17)', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/He Is Legend/91025', NULL, 135, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(136, 'I Am Hollywood', '(17)', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/He Is Legend/I Am Hollywood', NULL, 135, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(137, 'Suck out the Poison', '(9)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/He Is Legend/Suck out the Poison', NULL, 135, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(138, 'A.R.E.S: Extinction Agenda', 'Unknown Genre', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/HyperDuck SoundWorks/A.R.E.S_ Extinction Agenda', NULL, 138, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(139, 'Undead On Arrival', '(12)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/HyperDuck SoundWorks/Undead On Arrival', NULL, 138, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(140, 'Confession', 'Nu Metal', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Nino/Confession', NULL, 140, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(141, 'Enigma', 'Nu Metal', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Nino/Enigma', NULL, 140, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(142, 'Ill Nino [EP]', 'Nu Metal', '2000', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Nino/Ill Nino [EP]', NULL, 140, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(143, 'One Nation Underground', 'Nu Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Nino/One Nation Underground', NULL, 140, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(144, 'Revolution Revolucion', 'Nu Metal', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Nino/Revolution Revolucion', NULL, 140, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(145, 'The Under Cover Sessions', 'Nu Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Nino/The Under Cover Sessions', NULL, 140, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(146, 'Till Death, La Familia', 'Nu-Metal', '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Nino/Till Death, La Familia', NULL, 140, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(147, 'Epidemia', 'Nu Metal', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ill Niño/Epidemia', NULL, 147, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(148, 'Shuttle Scuttle OST', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Inverse Phase/Shuttle Scuttle OST', NULL, 148, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(149, 'Blunderbuss', '(20)', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jack White/Blunderbuss', NULL, 149, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(150, 'Mighty Milky Way / Mighty Flip Champs OST', 'Unknown Genre', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jake Kaufman/Mighty Milky Way _ Mighty Flip Champs OST', NULL, 150, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(151, 'Mighty Switch Force OST', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jake Kaufman/Mighty Switch Force OST', NULL, 150, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(152, 'Crazy Times (Single)', 'Religious', '1998', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Crazy Times (Single)', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(153, 'Drummer Boy', 'Religious', '1995', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Drummer Boy', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(154, 'Frail', 'Religious', '1995', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Frail', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(155, 'Furthermore: From the Studio/From the Stage Disc 1', 'Religious', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Furthermore_ From the Studio_From the Stage Disc 1', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(156, 'Furthermore: From the Studio/From the Stage Disc 2', 'Religious', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Furthermore_ From the Studio_From the Stage Disc 2', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(157, 'Good Monsters', 'Religious', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Good Monsters', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(158, 'If I Left the Zoo', 'Religious', '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/If I Left the Zoo', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(159, 'Jars of Clay', 'Religious', '1995', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Jars of Clay', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(160, 'Much Afraid', 'Religious', '1997', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Much Afraid', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(161, 'Redemption Songs', 'Religious', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Redemption Songs', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(162, 'Roots & Wings EP', '(17)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Roots & Wings EP', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(163, 'The Eleventh Hour', 'Religious', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/The Eleventh Hour', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(164, 'The Long Fall Back to Earth', 'Religious', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/The Long Fall Back to Earth', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(165, 'The White Elephant Sessions', 'Religious', '2000', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/The White Elephant Sessions', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(166, 'Who We Are Instead', 'Religious', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jars of Clay/Who We Are Instead', NULL, 87, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(167, 'Dear Esther', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jessica Curry/Dear Esther', NULL, 167, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(168, 'Awakening: Live From Chicago (Live)', 'Religious', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jesus Culture/Awakening_ Live From Chicago (Live)', NULL, 168, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(169, 'Consumed Disc 1', 'Religious', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jesus Culture/Consumed Disc 1', NULL, 169, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(170, 'Your Love Never Fails Disc 1', 'Religious', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jesus Culture/Your Love Never Fails Disc 1', NULL, 170, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(171, 'Indie Game: The Movie: The Soundtrack', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jim Guthrie/Indie Game_ The Movie_ The Soundtrack', NULL, 171, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(172, 'Sword & Sworcery LP - The Ballad of the Space Babies', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jim Guthrie/Sword & Sworcery LP - The Ballad of the Space Babies', NULL, 171, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(173, 'Tower of Love', 'Electronica', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Jim Noir/Tower of Love', NULL, 173, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(174, 'Jottobots', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Josh Whelchel/Jottobots', NULL, 174, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(175, 'Ravenmark: Scourge of Estellion (Original Soundtrack)', '(12)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Josh Whelchel/Ravenmark_ Scourge of Estellion (Original Soundtrack)', NULL, 174, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(176, 'Songs for the Cure ''11: Reiki', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Josh Whelchel/Songs for the Cure ''11_ Reiki', NULL, 174, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(177, 'Wind-up Knight Soundtrack', 'Unknown Genre', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Josh Whelchel/Wind-up Knight Soundtrack', NULL, 174, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(178, 'To the Moon <OST>', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Kan R. Gao, feat. Laura Shigihara/To the Moon _OST_', NULL, 178, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(179, 'Mr. Morale & The Big Steppers', 'Rap/Hip Hop', '2022', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Kendrick Lamar/Mr. Morale & The Big Steppers', NULL, 179, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(180, 'Man On The Moon: The End Of Day', 'Contemporary Hip Hop', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Kid Cudi/Man On The Moon_ The End Of Day', NULL, 180, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(181, 'As Daylight Dies', '(9)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Killswitch Engage/As Daylight Dies', NULL, 181, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(182, 'Incarnate', 'Metalcore', '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Killswitch Engage/Incarnate', NULL, 181, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(183, 'All Mixed Up: Issues [2CD Limited Edition] [Bonus Disk]', 'Nu Metal', '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/All Mixed Up_ Issues [2CD Limited Edition] [Bonus Disk]', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(184, 'Follow The Leader', 'Nu Metal', '1998', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/Follow The Leader', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(185, 'Issues [2CD Limited Edition]', 'Nu Metal', '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/Issues [2CD Limited Edition]', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(186, 'KoRn', 'Nu Metal', '1994', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/KoRn', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(187, 'Korn III: Remember Who You Are', 'Alternative', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/Korn III_ Remember Who You Are', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(188, 'Life Is Peachy', 'Nu Metal', '1996', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/Life Is Peachy', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(189, 'See You On The Other Side [2CD Limited Edition] [Bonus Disc]', 'Alternative Metal/Experimental Rock/Nu Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/See You On The Other Side [2CD Limited Edition] [Bonus Disc]', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(190, 'See You On The Other Side [2CD Limited Edition]', 'Alternative Metal/Experimental Rock/Nu Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/See You On The Other Side [2CD Limited Edition]', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(191, 'Take A Look In The Mirror', 'Alternative Metal/Nu Metal', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/Take A Look In The Mirror', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(192, 'The Paradigm Shift', NULL, '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/The Paradigm Shift', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(193, 'Untitled', 'Alternative Metal/Experimental Rock/Nu Metal', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/Untitled', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(194, 'Untouchables [Limited Edition]', 'Alternative Metal/Nu Metal', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/KoRn/Untouchables [Limited Edition]', NULL, 183, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(195, 'As The Palaces Burn', 'Metal', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God/As The Palaces Burn', NULL, 64, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(196, 'Ashes Of The Wake', 'Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God/Ashes Of The Wake', NULL, 64, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(197, 'Killadelphia', 'Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God/Killadelphia', NULL, 64, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(198, 'New American Gospel', 'Metal', '2000', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God/New American Gospel', NULL, 64, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(199, 'Resolution', '(9)', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God/Resolution', NULL, 64, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(200, 'Sacrament', 'Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God/Sacrament', NULL, 64, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(201, 'VII : Sturm und Drang', 'Metal', '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God/VII _ Sturm und Drang', NULL, 64, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(202, 'Wrath', 'Thrash/Groove Metal', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Lamb of God/Wrath', NULL, 64, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(203, 'Cobalt', '(3)', '1997', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Les Jumeaux/Cobalt', NULL, 203, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(204, 'Blood Mountain', '(9)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mastodon/Blood Mountain', NULL, 204, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(205, 'Crack the Skye', '(9)', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mastodon/Crack the Skye', NULL, 204, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(206, 'The Hunter', '(9)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mastodon/The Hunter', NULL, 204, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(207, 'No Place to Be Disc 1', '(16)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Matisyahu/No Place to Be Disc 1', NULL, 207, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(208, 'Youth', 'Rap & Hip-Hop', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Matisyahu/Youth', NULL, 207, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(209, 'The Violent Sleep of Reason', 'Metal', '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Meshuggah/The Violent Sleep of Reason', NULL, 209, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(210, 'Gnosis', '(9)Metal', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Monuments/Gnosis', NULL, 210, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(211, 'In Stasis', 'Metal', '2022', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Monuments/In Stasis', NULL, 210, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(212, 'The Amanuensis', NULL, '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Monuments/The Amanuensis', NULL, 210, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(213, 'L.D. 50', '(9)', '2000', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mudvayne/L.D. 50', NULL, 213, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(214, 'Lost and Found', '(9)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mudvayne/Lost and Found', NULL, 213, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(215, 'Mudvayne', 'Metal/Hard Rock', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mudvayne/Mudvayne', NULL, 213, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(216, 'The End of All Things to Come', '(9)', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mudvayne/The End of All Things to Come', NULL, 213, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(217, 'The New Game', '(9)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Mudvayne/The New Game', NULL, 213, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(218, 'Miracle', 'Hard Rock', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Nonpoint/Miracle', NULL, 218, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(219, 'The Poison Red', '(9)Metal', '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Nonpoint/The Poison Red', NULL, 218, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(220, 'Precambrian', 'Experimental', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ocean/Precambrian', NULL, 220, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(221, 'Amadeus: Music from the Original Soundtrack of the Film, Vol. 2', '(24)', '1990', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Original Soundtrack/Amadeus_ Music from the Original Soundtrack of the Film, Vol. 2', NULL, 221, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(222, 'Cowboys From Hell', 'Metal', '1990', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Pantera/Cowboys From Hell', NULL, 222, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(223, 'Far Beyond Driven', 'Metal', '1994', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Pantera/Far Beyond Driven', NULL, 222, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(224, 'Reinventing The Steel', 'Metal', '2000', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Pantera/Reinventing The Steel', NULL, 222, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(225, 'The Great Southern Trendkill', 'Metal', '1996', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Pantera/The Great Southern Trendkill', NULL, 222, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(226, 'Vulgar Display of Power', 'Metal', '1992', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Pantera/Vulgar Display of Power', NULL, 222, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(227, 'Atlas', 'Hardcore', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive/Atlas', NULL, 227, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(228, 'Deep Blue', '(9)', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive/Deep Blue', NULL, 227, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(229, 'Don''t Close Your Eyes', '(9)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive/Don''t Close Your Eyes', NULL, 227, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(230, 'Horizons', '(9)', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive/Horizons', NULL, 227, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(231, 'Ire', NULL, '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive/Ire', NULL, 227, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(232, 'Killing with a Smile', '(9)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive/Killing with a Smile', NULL, 227, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(233, 'Reverence', 'Rock', '2018', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive/Reverence', NULL, 227, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(234, 'What We Built', 'Metalcore', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Parkway Drive/What We Built', NULL, 227, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(235, 'Juggernaut: Alpha', 'Progressive Metal / Math Metal / Djent', '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Juggernaut_ Alpha', NULL, 235, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(236, 'Juggernaut: Omega', 'Progressive Metal / Math Metal / Djent', '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Juggernaut_ Omega', NULL, 235, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(237, 'Periphery II', 'Progressive Metal / Math Metal / Djent', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Periphery II', NULL, 235, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(238, 'Periphery III: Select Difficulty', NULL, '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Periphery III_ Select Difficulty', NULL, 235, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(239, 'Periphery IV: HAIL STAN', 'Metal', '2019', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Periphery IV_ HAIL STAN', NULL, 235, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(240, 'Periphery', 'Progressive Metal / Math Metal / Djent', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Periphery/Periphery', NULL, 235, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(241, 'Skyrim Main Theme', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Peter Hollens & Lindsey Stirling/Skyrim Main Theme', NULL, 241, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(242, 'We''re Not Robots', 'Religious', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Praising with a Purpose/We''re Not Robots', NULL, 242, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(243, 'Probot', '(9)', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Probot/Probot', NULL, 243, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(244, 'Fortress', 'Hardcore Metal', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Protest The Hero/Fortress', NULL, 244, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(245, 'Pacific Myth', 'Progressive Metal', '2016', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Protest The Hero/Pacific Myth', NULL, 244, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(246, 'Palimpsest', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Protest The Hero/Palimpsest', NULL, 244, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(247, 'Scurrilous', '(9)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Protest The Hero/Scurrilous', NULL, 244, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(248, 'Volition', 'Progressive Metal', '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Protest The Hero/Volition', NULL, 244, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(249, 'V Is for Vagina', '(52)', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Puscifer/V Is for Vagina', NULL, 249, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(250, 'V Is for Viagra: The Remixes', '(52)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Puscifer/V Is for Viagra_ The Remixes', NULL, 249, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(251, 'Evil Empire', 'Rock', '1996', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rage Against the Machine/Evil Empire', NULL, 251, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(252, 'Rage Against the Machine', 'Rock', '1992', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rage Against the Machine/Rage Against the Machine', NULL, 251, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(253, 'Renegades', 'Rock', '2000', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rage Against the Machine/Renegades', NULL, 251, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(254, 'The Battle of Los Angeles', 'Rock', '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rage Against the Machine/The Battle of Los Angeles', NULL, 251, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(255, 'Ravens & Wolves Ep', 'Rock', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Ravens & Wolves/Ravens & Wolves Ep', NULL, 255, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(256, 'Dingir', 'Technical Deathcore', '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rings of Saturn/Dingir', NULL, 256, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(257, 'Embryonic Anomaly Remake', '(9)', '2021', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rings of Saturn/Embryonic Anomaly Remake', NULL, 256, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(258, 'Embryonic Anomaly', 'Technical Death Metal', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rings of Saturn/Embryonic Anomaly', NULL, 256, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(259, 'Lugal Ki En', 'Technical Death Metal / Deathcore', '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rings of Saturn/Lugal Ki En', NULL, 256, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(260, 'Ultu Ulla', 'Metal', '2017', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rings of Saturn/Ultu Ulla', NULL, 256, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(261, 'POP: Methodology Experiment One OST', 'Electronic', NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Rob Lach/POP_ Methodology Experiment One OST', NULL, 261, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(262, 'SQUIDS - OST', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Romain Gauthier/SQUIDS - OST', NULL, 262, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(263, 'Enter', '(17)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Russian Circles/Enter', NULL, 263, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(264, 'Geneva', '(20)', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Russian Circles/Geneva', NULL, 263, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(265, 'Live Brudenell Social Club Leeds UK', '(17)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Russian Circles/Live Brudenell Social Club Leeds UK', NULL, 263, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(266, 'Russian Circles [EP]', '(17)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Russian Circles/Russian Circles [EP]', NULL, 263, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(267, 'Station', '(17)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Russian Circles/Station', NULL, 263, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(268, 'These Arms Are Snakes + Russian Circles [Split Vinyl]', '(17)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Russian Circles/These Arms Are Snakes + Russian Circles [Split Vinyl]', NULL, 263, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(269, 'Hotline Miami: The Takedown EP', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Scattle/Hotline Miami_ The Takedown EP', NULL, 269, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(270, 'Harakiri', 'Rock', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Serj Tankian/Harakiri', NULL, 270, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(271, 'Imperfect Harmonies', 'Rock', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Serj Tankian/Imperfect Harmonies', NULL, 270, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(272, 'All I See Is War', 'Alternative Metal', '2018', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sevendust/All I See Is War', NULL, 272, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(273, 'Blood & Stone (Deluxe)', NULL, '2020/2021', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sevendust/Blood & Stone (Deluxe)', NULL, 272, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(274, 'Kill The Flaw', 'Rock', '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sevendust/Kill The Flaw', NULL, 272, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(275, 'Kanto Symphony EP', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Skotein/Kanto Symphony EP', NULL, 275, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(276, 'All Hope Is Gone [Special Edition]', 'Metal', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Slipknot/All Hope Is Gone [Special Edition]', NULL, 276, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(277, 'Iowa', 'Metal', '2001', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Slipknot/Iowa', NULL, 276, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(278, 'Slipknot', 'Metal', '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Slipknot/Slipknot', NULL, 276, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(279, 'Vol. 3: (The Subliminal Verses)', 'Metal', '2004', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Slipknot/Vol. 3_ (The Subliminal Verses)', NULL, 276, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(280, 'PPPPPP - The VVVVVV Soundtrack', '(52)', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/SoulEye/PPPPPP - The VVVVVV Soundtrack', NULL, 280, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(281, 'King Animal', '(17)', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Soundgarden/King Animal', NULL, 281, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(282, 'Underworld Evolution', 'Soundtrack', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Soundtrack/Underworld Evolution', NULL, 19, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(283, '14 Shades Of Grey', 'Rock', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Staind/14 Shades Of Grey', NULL, 283, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(284, 'Break the Cycle', 'Rock', '2001', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Staind/Break the Cycle', NULL, 283, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(285, 'Chapter V', 'Rock', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Staind/Chapter V', NULL, 283, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(286, 'Dysfunction (Japanese)', NULL, '1999', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Staind/Dysfunction (Japanese)', NULL, 283, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(287, 'Staind [Deluxe Edition]', 'Hard Rock', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Staind/Staind [Deluxe Edition]', NULL, 283, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(288, 'The Illusion of Progress', 'Rock', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Staind/The Illusion of Progress', NULL, 283, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(289, 'Tormented', 'Alternative', '1996', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Staind/Tormented', NULL, 283, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(290, 'A Day in the Life: The Soundtrack Disc 1', 'Rap & Hip-Hop', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sticky Fingaz/A Day in the Life_ The Soundtrack Disc 1', NULL, 290, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(291, 'Ghosts In The Machine', '(9)', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Switched/Ghosts In The Machine', NULL, 291, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(292, 'Subject to Change', '(9)', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Switched/Subject to Change', NULL, 291, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(293, 'Casting Shadows', 'Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sylosis/Casting Shadows', NULL, 293, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(294, 'Edge Of The Earth', 'Metal', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sylosis/Edge Of The Earth', NULL, 293, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(295, 'Slings And Arrows (CDS)', 'Melodic Thrash Metal; Progressive Thrash Metal; Melodic Metalcore', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sylosis/Slings And Arrows (CDS)', NULL, 293, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(296, 'The Supreme Oppressor', 'Metal', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Sylosis/The Supreme Oppressor', NULL, 293, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(297, 'Hypnotize', 'Nu-Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/System Of A Down/Hypnotize', NULL, 298, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(298, 'Mezmerize', 'Nu-Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/System Of A Down/Mezmerize', NULL, 298, '2023-01-17 20:42:16', '2023-01-17 20:42:16'),
(299, 'Steal This Album!', 'Nu-Metal', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/System Of A Down/Steal This Album!', NULL, 298, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(300, 'System Of A Down', 'Nu-Metal', '1998', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/System Of A Down/System Of A Down', NULL, 298, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(301, 'Toxicity', 'Nu-Metal', '2001', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/System Of A Down/Toxicity', NULL, 298, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(302, 'Blue-Sky Research', '(9)', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Taproot/Blue-Sky Research', NULL, 303, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(303, 'Our Long Road Home', '(9)', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Taproot/Our Long Road Home', NULL, 303, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(304, 'Welcome', '(9)', '2002', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Taproot/Welcome', NULL, 303, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(305, 'Rize of the Fenix', '(57)', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tenacious D/Rize of the Fenix', NULL, 306, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(306, 'Concealing Fate (EP)', '(9)', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/TesseracT/Concealing Fate (EP)', NULL, 307, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(307, 'One', 'Progressive Metal', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/TesseracT/One', NULL, 307, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(308, 'Perspective (EP)', 'Metal', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/TesseracT/Perspective (EP)', NULL, 307, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(309, 'Act III: Life and Death', 'Alternative Rock,Prog Rock,Experimental,Rock', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Dear Hunter/Act III_ Life and Death', NULL, 310, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(310, 'Act II: The Meaning of, & All Things Regarding Ms. Leading', 'Rock', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Dear Hunter/Act II_ The Meaning of, & All Things Regarding Ms. Leading', NULL, 310, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(311, 'Act IV: Rebirth in Reprise', 'Rock', '2015', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Dear Hunter/Act IV_ Rebirth in Reprise', NULL, 310, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(312, 'Act I: The Lake South, The River North', 'Alternative', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Dear Hunter/Act I_ The Lake South, The River North', NULL, 310, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(313, 'Migrant', NULL, '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Dear Hunter/Migrant', NULL, 310, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(314, 'The Color Spectrum', 'Progressive Rock', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Dear Hunter/The Color Spectrum', NULL, 310, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(315, 'The Indigo Child', 'Progressive Rock', '2021', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Dear Hunter/The Indigo Child', NULL, 310, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(316, 'Dead Throne', 'Religious', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Devil Wears Prada/Dead Throne', NULL, 116, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(317, 'Dear Love: A Beautiful Discord', 'Religious', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Devil Wears Prada/Dear Love_ A Beautiful Discord', NULL, 116, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(318, 'Plagues', 'Religious', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Devil Wears Prada/Plagues', NULL, 116, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(319, 'Aeolian', 'Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Ocean/Aeolian', NULL, 220, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(320, 'Anthropocentric', 'Metal', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Ocean/Anthropocentric', NULL, 220, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(321, 'Fluxion', 'Metal', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Ocean/Fluxion', NULL, 220, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(322, 'Heliocentric', 'Metal', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Ocean/Heliocentric', NULL, 220, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(323, 'Grind The Ocean', 'Pop Rock. Metal', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Safety Fire/Grind The Ocean', NULL, 324, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(324, 'Danza 4: The Alpha- The Omega', 'Experimental', '2012', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Tony Danza Tapdance Extravaganza/Danza 4_ The Alpha- The Omega', NULL, 325, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(325, 'Danza III: The Series Of Unfortunate Events', 'Experimental/Grindcore/Technical', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/The Tony Danza Tapdance Extravaganza/Danza III_ The Series Of Unfortunate Events', NULL, 325, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(326, 'Russian Circles/These Arms are Snakes', 'Post Rock', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/These Arms Are Snakes/Russian Circles_These Arms are Snakes', NULL, 327, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(327, 'Traveler', '(2)', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tim O''Brien/Traveler', NULL, 106, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(328, 'The Hymn Of A Broken Man', '(9)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Times Of Grace/The Hymn Of A Broken Man', NULL, 329, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(329, 'Machinarium Soundtrack', 'Electronica', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tomáš Dvořák/Machinarium Soundtrack', NULL, 330, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(330, '10,000 Days', 'Rock', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tool/10,000 Days', NULL, 331, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(331, 'Fear Inoculum', NULL, '2019', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tool/Fear Inoculum', NULL, 331, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(332, 'Lateralus', 'Alternative Metal', '2001', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tool/Lateralus', NULL, 331, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(333, 'Opiate', 'Progressive Rock', '1992', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tool/Opiate', NULL, 331, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(334, 'Undertow', 'Heavy Metal', '1993', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tool/Undertow', NULL, 331, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(335, 'Ænima', 'Metal', '1996', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Tool/Ænima', NULL, 331, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(336, 'Ascendancy (Re-Release)', 'Heavy Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Trivium/Ascendancy (Re-Release)', NULL, 337, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(337, 'Ember to Inferno (Re-Release)', 'Heavy Metal', '2005', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Trivium/Ember to Inferno (Re-Release)', NULL, 337, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(338, 'Shogun (Special Edition)', 'Heavy Metal', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Trivium/Shogun (Special Edition)', NULL, 337, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(339, 'The Crusade', 'Heavy Metal', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Trivium/The Crusade', NULL, 337, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(340, 'Trivium', 'Heavy Metal', '2003', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Unknown/Trivium', NULL, 337, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(341, 'Guardians Of The Galaxy (Awesome Mix Vol. 1)', 'Soundtracks', '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Various Artists/Guardians Of The Galaxy (Awesome Mix Vol. 1)', NULL, 342, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(342, 'False Idol', 'Metal', '2017', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Veil Of Maya/False Idol', NULL, 343, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(343, 'Masstaden', 'Progressive Metal / Math Metal / Djent', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Vildhjarta/Masstaden', NULL, 344, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(344, 'Thousands of Evils EP', NULL, '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Vildhjarta/Thousands of Evils EP', NULL, 344, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(345, 'No Sleep', NULL, '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Volumes/No Sleep', NULL, 346, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(346, 'The Concept of Dreaming', 'Metal', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Volumes/The Concept of Dreaming', NULL, 346, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(347, 'VIA', 'Metal', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Volumes/VIA', NULL, 346, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(348, 'Songs for the Cure ''11: Esuna', NULL, '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Wilbert Roget, II/Songs for the Cure ''11_ Esuna', NULL, 349, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(349, 'Live At the Banks House', 'Christian Rock', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Will Reagan & United Pursuit/Live At the Banks House', NULL, 350, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(350, 'Creature', 'Metalcore', '2009', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Within The Ruins/Creature', NULL, 351, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(351, 'Driven By Fear', 'Metalcore', '2006', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Within The Ruins/Driven By Fear', NULL, 351, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(352, 'Elite', 'Metalcore', '2013', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Within The Ruins/Elite', NULL, 351, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(353, 'Empires', 'Metalcore', '2008', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Within The Ruins/Empires', NULL, 351, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(354, 'Invade', 'Metalcore', '2010', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Within The Ruins/Invade', NULL, 351, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(355, 'Omen', 'Metalcore', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Within The Ruins/Omen', NULL, 351, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(356, 'Phenomena', 'Metalcore', '2014', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/Within The Ruins/Phenomena', NULL, 351, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(357, 'Alpocalypse', 'Comedy', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/_Weird Al_ Yankovic/Alpocalypse', NULL, 358, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(358, 'Cardboard Box Assembler Origin', 'Unknown Genre', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/anosou/Cardboard Box Assembler Origin', NULL, 359, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(359, 'Cobalt EP', '(3)', '1997', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/anosou/Cobalt EP', NULL, 203, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(360, 'Contingency', 'Unknown Genre', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/big giant circles/Contingency', NULL, 361, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(361, 'Impostor Nostalgia', '(12)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/big giant circles/Impostor Nostalgia', NULL, 361, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(362, 'The Binding of Isaac', '(12)', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/dB soundworks/The Binding of Isaac', NULL, 363, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(363, 'race wars', 'Rap', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/mc chris/race wars', NULL, 364, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(364, 'Retro City Rampage', NULL, NULL, NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/virt, Freaky DNA and Norrin Radd/Retro City Rampage', NULL, 365, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(365, 'Tree of Knowledge ～知恵の樹～', 'Unknown Genre', '2011', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/yogurtbox/Tree of Knowledge ～知恵の樹～', NULL, 366, '2023-01-17 20:42:17', '2023-01-17 20:42:17'),
(366, 'Antigravity', 'Electronica', '2007', NULL, 't', '/Users/jbrayton/Music/iTunes/iTunes Media/Music/zircon/Antigravity', NULL, 242, '2023-01-17 20:42:17', '2023-01-17 20:42:17');

--
-- Notifications
--

INSERT INTO public."notifications" ("id", "icon", "subject", "body", "url", "type", "seen_at", "album_id", "inserted_at", "updated_at") VALUES
(1, NULL, 'This is a new album_not_owned notification', NULL, NULL, 'album_not_owned', NULL, NULL, '2023-01-19 18:18:58', '2023-01-19 18:18:58'),
(2, NULL, 'This is a new album_new_release notification', NULL, NULL, 'album_new_release', NULL, NULL, '2023-01-19 18:18:58', '2023-01-19 18:18:58'),
(3, NULL, 'This is a new album_upcoming_release notification', NULL, NULL, 'album_upcoming_release', NULL, NULL, '2023-01-19 18:18:58', '2023-01-19 18:18:58'),
(4, NULL, 'This is a new album_not_owned notification', NULL, NULL, 'album_not_owned', NULL, NULL, '2023-01-19 18:19:01', '2023-01-19 18:19:01'),
(5, NULL, 'This is a new album_new_release notification', NULL, NULL, 'album_new_release', NULL, NULL, '2023-01-19 18:19:01', '2023-01-19 18:19:01'),
(6, NULL, 'This is a new album_upcoming_release notification', NULL, NULL, 'album_upcoming_release', NULL, NULL, '2023-01-19 18:19:01', '2023-01-19 18:19:01'),
(7, NULL, 'This is a new album_not_owned notification', NULL, NULL, 'album_not_owned', NULL, NULL, '2023-01-19 18:19:04', '2023-01-19 18:19:04'),
(8, NULL, 'This is a new album_new_release notification', NULL, NULL, 'album_new_release', NULL, NULL, '2023-01-19 18:19:04', '2023-01-19 18:19:04'),
(9, NULL, 'This is a new album_upcoming_release notification', NULL, NULL, 'album_upcoming_release', NULL, NULL, '2023-01-19 18:19:04', '2023-01-19 18:19:04');