--
-- PostgreSQL database dump
--

\restrict j4dw1S7d9olfH3gedhixnXIERXL2ejvdCLcCL8KfT9U92luFQbvPN0ps0w6UzAg

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-04-09 17:12:46

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 220 (class 1259 OID 16470)
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16469)
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admins_id_seq OWNER TO postgres;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 219
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- TOC entry 224 (class 1259 OID 16501)
-- Name: project_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_images (
    id integer NOT NULL,
    project_id integer,
    image_path text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.project_images OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16500)
-- Name: project_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.project_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_images_id_seq OWNER TO postgres;

--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 223
-- Name: project_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.project_images_id_seq OWNED BY public.project_images.id;


--
-- TOC entry 222 (class 1259 OID 16485)
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    project_name character varying(255) NOT NULL,
    project_type character varying(50) NOT NULL,
    thumbnail character varying(500) NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    description text,
    client_name character varying(255),
    location character varying(255)
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16484)
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO postgres;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 221
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- TOC entry 4866 (class 2604 OID 16473)
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 16504)
-- Name: project_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_images ALTER COLUMN id SET DEFAULT nextval('public.project_images_id_seq'::regclass);


--
-- TOC entry 4868 (class 2604 OID 16488)
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- TOC entry 5031 (class 0 OID 16470)
-- Dependencies: 220
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, email, password, created_at) FROM stdin;
1	admin@sanmour.com	$2a$10$p0AiiGhx7oa/ONTqxtTEOO5jAn4HxtjyX.oQvGYJAY34Mlwcfcpxm	2025-12-18 12:07:19.672878
\.


--
-- TOC entry 5035 (class 0 OID 16501)
-- Dependencies: 224
-- Data for Name: project_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_images (id, project_id, image_path, created_at) FROM stdin;
40	27	uploads\\1773207224191553300_CAm-01_VIew-HI.webp	2026-03-11 11:03:44.2011
41	27	uploads\\1773207224200921300_CAm-02_VIew-HI.webp	2026-03-11 11:03:44.21315
42	27	uploads\\1773207224213592300_CAm-03_VIew-HI.webp	2026-03-11 11:03:44.217744
43	27	uploads\\1773207224217572800_CAm-04_View-HI.webp	2026-03-11 11:03:44.222497
44	27	uploads\\1773207224222468300_CAm-05_VIew-HI.webp	2026-03-11 11:03:44.228314
45	28	uploads\\1773207589479903200_CAM 01.webp	2026-03-11 11:09:49.499825
46	28	uploads\\1773207589500422600_CAM 02.webp	2026-03-11 11:09:49.505862
47	28	uploads\\1773207589505797400_CAM 04.webp	2026-03-11 11:09:49.511117
48	28	uploads\\1773207589511085500_CAM 05.webp	2026-03-11 11:09:49.516708
49	28	uploads\\1773207589517183200_CAM 06.webp	2026-03-11 11:09:49.522646
50	28	uploads\\1773207589522604800_CAM 07.webp	2026-03-11 11:09:49.528122
51	28	uploads\\1773207589527925700_CAM 09.webp	2026-03-11 11:09:49.533301
52	28	uploads\\1773207589533778800_CAM 13.webp	2026-03-11 11:09:49.54091
53	28	uploads\\1773207589540648000_CAM 14.webp	2026-03-11 11:09:49.546499
54	29	uploads\\1773208936830883900_01 SIDE VIEW.webp	2026-03-11 11:32:16.835705
55	29	uploads\\1773208936836912800_02 FRONT VIEW.webp	2026-03-11 11:32:16.840509
56	29	uploads\\1773208936840580400_04 CORNER VIEW NIGHT.webp	2026-03-11 11:32:16.844404
57	29	uploads\\1773208936844487200_06 BIRD VIEW.webp	2026-03-11 11:32:16.850432
58	29	uploads\\1773208936850920500_07 SKY VIEW.webp	2026-03-11 11:32:16.85496
59	30	uploads\\1773209084148347700_02 FRONT VIEW NIGHT.webp	2026-03-11 11:34:44.156337
60	30	uploads\\1773209084159193800_03 SIDE VIEW.webp	2026-03-11 11:34:44.16665
61	30	uploads\\1773209084166643500_04 BIRD VIEW.webp	2026-03-11 11:34:44.172051
62	30	uploads\\1773209084172028500_05 SKY VIEW.webp	2026-03-11 11:34:44.175415
63	30	uploads\\1773209084175452000_06 GATE VIEW EVENING.webp	2026-03-11 11:34:44.177911
64	30	uploads\\1773209084178119000_07 BALCONY VIEW.webp	2026-03-11 11:34:44.181588
65	30	uploads\\1773209084181324400_08 GARDEN TOP VIEW.webp	2026-03-11 11:34:44.185547
66	31	uploads\\1773209335477156800_01 SIDE VIEW NIGHT.webp	2026-03-11 11:38:55.480686
67	31	uploads\\1773209335480861300_02 SIDE VIEW.webp	2026-03-11 11:38:55.484383
68	31	uploads\\1773209335484692800_03 FRONT VIEW.webp	2026-03-11 11:38:55.486473
69	31	uploads\\1773209335486322000_04 BACK VIEW.webp	2026-03-11 11:38:55.488235
70	31	uploads\\1773209335488487000_09 GATE VIEW.webp	2026-03-11 11:38:55.490849
71	31	uploads\\1773209335490623600_10 BIRD VIEW.webp	2026-03-11 11:38:55.49431
72	32	uploads\\1773210341010856400_01 SIDE VIEW.webp	2026-03-11 11:55:41.020394
73	32	uploads\\1773210341022287400_02 FRONT VIEW.webp	2026-03-11 11:55:41.027601
74	32	uploads\\1773210341027507900_03 SIDE VIEW NIGHT.webp	2026-03-11 11:55:41.032542
75	32	uploads\\1773210341032596000_04 GATE VIEW.webp	2026-03-11 11:55:41.036703
76	32	uploads\\1773210341036111400_05 GARDEN TOP VIEW.webp	2026-03-11 11:55:41.041266
77	32	uploads\\1773210341041525400_06 BACK VIEW.webp	2026-03-11 11:55:41.04434
78	32	uploads\\1773210341044614200_09 GARDEN VIEW.webp	2026-03-11 11:55:41.048521
79	32	uploads\\1773210341046842700_10 GARDEN VIEW.webp	2026-03-11 11:55:41.053108
80	32	uploads\\1773210341051665500_12 BIRD VIEW.webp	2026-03-11 11:55:41.058197
81	32	uploads\\1773210341058253900_13 GATE VIEW.webp	2026-03-11 11:55:41.062216
82	33	uploads\\1773210507886645300_01 SIDE VIEW.webp	2026-03-11 11:58:27.889613
83	33	uploads\\1773210507895175100_02 SIDE VIEW.webp	2026-03-11 11:58:27.899428
84	33	uploads\\1773210507900488300_03 FRONT VIEW.webp	2026-03-11 11:58:27.903946
85	33	uploads\\1773210507904191600_04 GATE VIEW.webp	2026-03-11 11:58:27.907205
86	33	uploads\\1773210507907317800_05 GATE CROSS VIEW.webp	2026-03-11 11:58:27.909997
87	33	uploads\\1773210507910011800_06 BACK VIEW.webp	2026-03-11 11:58:27.913009
88	33	uploads\\1773210507911127400_07 SKY VIEW.webp	2026-03-11 11:58:27.917592
89	33	uploads\\1773210507917616100_08 BIRD VIEW.webp	2026-03-11 11:58:27.92139
90	33	uploads\\1773210507921925500_BLOCK-A-102-TYPE-01.webp	2026-03-11 11:58:27.925795
91	33	uploads\\1773210507926262100_GARDEN VIEW 01.webp	2026-03-11 11:58:27.931107
92	33	uploads\\1773210507930653100_GARDEN VIEW 02.webp	2026-03-11 11:58:27.936011
93	34	uploads\\1773210712155489600_Fv_Bird Eye View.webp	2026-03-11 12:01:52.157823
94	34	uploads\\1773210712163126500_Fv_Estate Row Corner View.webp	2026-03-11 12:01:52.165414
95	34	uploads\\1773210712165918500_Fv_Estate Row Front View.webp	2026-03-11 12:01:52.167419
96	34	uploads\\1773210712167718200_Fv_Gate Corner View Night.webp	2026-03-11 12:01:52.169283
97	34	uploads\\1773210712169067100_Fv_Street View NIght.webp	2026-03-11 12:01:52.171198
98	35	uploads\\1773210864253682400_Kalrav_Arcade_Corner view.webp	2026-03-11 12:04:24.257724
99	35	uploads\\1773210864266013700_Kalrav_Arcade_Front view.webp	2026-03-11 12:04:24.268907
100	35	uploads\\1773210864269955800_Kalrav_Arcade_Night view.webp	2026-03-11 12:04:24.273968
101	35	uploads\\1773210864275155800_KALRAV_ARCADE_TOP_VIEW.webp	2026-03-11 12:04:24.27937
102	36	uploads\\1773210996417638300_01 SIDE VIEW DAY.webp	2026-03-11 12:06:36.424581
103	36	uploads\\1773210996429989400_02 FRONT VIEW DAY.webp	2026-03-11 12:06:36.436532
104	36	uploads\\1773210996436263600_03 SIDE VIEW NIGHT.webp	2026-03-11 12:06:36.440211
105	36	uploads\\1773210996440412000_05 SIDE VIEW EVENING.webp	2026-03-11 12:06:36.443849
106	36	uploads\\1773210996443870200_06 SKY VIEW.webp	2026-03-11 12:06:36.449919
107	36	uploads\\1773210996450137400_08 BIRD VIEW.webp	2026-03-11 12:06:36.454169
108	36	uploads\\1773210996454353900_FOYER.webp	2026-03-11 12:06:36.457959
109	37	uploads\\1773211163405108800_Swetayan arcade_bird eye view.webp	2026-03-11 12:09:23.408507
110	37	uploads\\1773211163414040800_Swetayan arcade_corner night view.webp	2026-03-11 12:09:23.416379
111	37	uploads\\1773211163416306000_Swetayan arcade_corner view.webp	2026-03-11 12:09:23.418456
112	37	uploads\\1773211163418488700_Swetayan arcade_front view.webp	2026-03-11 12:09:23.420159
113	38	uploads\\1773211425418756800_CAM-01.webp	2026-03-11 12:13:45.427432
114	38	uploads\\1773211425430382500_CAM-01_WHITHOUT LOGO.webp	2026-03-11 12:13:45.438263
115	38	uploads\\1773211425438307000_CAM-2.webp	2026-03-11 12:13:45.44354
116	38	uploads\\1773211425442495800_CAM-3.webp	2026-03-11 12:13:45.448262
117	38	uploads\\1773211425447758200_CAM-8.webp	2026-03-11 12:13:45.452672
118	38	uploads\\1773211425451503800_CAM-9.webp	2026-03-11 12:13:45.456985
119	38	uploads\\1773211425456729600_CAM-10.webp	2026-03-11 12:13:45.4612
120	38	uploads\\1773211425461477700_CAM-11.webp	2026-03-11 12:13:45.464356
121	38	uploads\\1773211425464201300_CAM-12.webp	2026-03-11 12:13:45.46942
122	38	uploads\\1773211425468381100_CAM-12_WHITHOUT LOGO.webp	2026-03-11 12:13:45.474139
123	38	uploads\\1773211425473231300_CAM-14.webp	2026-03-11 12:13:45.478017
124	38	uploads\\1773211425478174500_CAM-15.webp	2026-03-11 12:13:45.482323
125	38	uploads\\1773211425482210500_CAM-16.webp	2026-03-11 12:13:45.485206
126	38	uploads\\1773211425485367000_CAM-17.webp	2026-03-11 12:13:45.487589
127	38	uploads\\1773211425487445300_CAM-19.webp	2026-03-11 12:13:45.491612
128	38	uploads\\1773211425491430600_CAM-20.webp	2026-03-11 12:13:45.494667
129	38	uploads\\1773211425494681300_CAM-21-1.webp	2026-03-11 12:13:45.496893
130	38	uploads\\1773211425496958200_CAM-22.webp	2026-03-11 12:13:45.499266
131	38	uploads\\1773211425499111100_F_BEDROOM 01_CAM-01.webp	2026-03-11 12:13:45.500987
132	38	uploads\\1773211425501000700_F_BEDROOM 01_CAM-02.webp	2026-03-11 12:13:45.502566
133	38	uploads\\1773211425502416700_F_BEDROOM 02_CAM-01.webp	2026-03-11 12:13:45.503828
134	38	uploads\\1773211425503917900_G_BEDROOM-CAM-01.webp	2026-03-11 12:13:45.505559
135	38	uploads\\1773211425505508900_LIVING ROOM CAM-01.webp	2026-03-11 12:13:45.509113
136	38	uploads\\1773211425509050400_LIVING ROOM CAM-02.webp	2026-03-11 12:13:45.514324
137	38	uploads\\1773211425514349700_LIVING ROOM CAM-03.webp	2026-03-11 12:13:45.519644
138	38	uploads\\1773211425519664600_POOJA ROOM.webp	2026-03-11 12:13:45.524292
139	38	uploads\\1773211425524305500_STUDY ROOM.webp	2026-03-11 12:13:45.528568
140	39	uploads\\1773211629865310800_Fv_Badminton Top View.webp	2026-03-11 12:17:09.869272
141	39	uploads\\1773211629870813300_Fv_Bird Eye View.webp	2026-03-11 12:17:09.875419
142	39	uploads\\1773211629875950500_Fv_Children Play Area Top View.webp	2026-03-11 12:17:09.879401
143	39	uploads\\1773211629879326400_Fv_Gate View R2.webp	2026-03-11 12:17:09.88314
144	39	uploads\\1773211629883591000_Fv_Gym.webp	2026-03-11 12:17:09.886899
145	39	uploads\\1773211629887019900_Fv_Indoor Game R1.webp	2026-03-11 12:17:09.890801
146	39	uploads\\1773211629890683400_Fv_Morden Bunglow Corner View.webp	2026-03-11 12:17:09.894855
147	39	uploads\\1773211629894908500_Fv_Morden Bunglow Front View.webp	2026-03-11 12:17:09.898793
148	39	uploads\\1773211629898866600_Fv_Morden Club Top View.webp	2026-03-11 12:17:09.905779
149	39	uploads\\1773211629901295100_Fv_Traditional Bunglow Corner Night View.webp	2026-03-11 12:17:09.911639
150	39	uploads\\1773211629911679100_Fv_Traditional Bunglow Front View.webp	2026-03-11 12:17:09.916622
151	39	uploads\\1773211629916692100_Fv_Traditional Bunglow Street View R1.webp	2026-03-11 12:17:09.92141
152	39	uploads\\1773211629921486800_Fv_Traditional Club Swiming Poolv view R1.webp	2026-03-11 12:17:09.926069
153	39	uploads\\1773211629926131500_Fv_Traditional Club Top View R1.webp	2026-03-11 12:17:09.929662
154	40	uploads\\1773211763205909500_Cam 01.webp	2026-03-11 12:19:23.208016
155	40	uploads\\1773211763213129200_Cam 02.webp	2026-03-11 12:19:23.215256
156	40	uploads\\1773211763215055800_Cam 03.webp	2026-03-11 12:19:23.217739
157	40	uploads\\1773211763217571500_Cam 06.webp	2026-03-11 12:19:23.21989
158	40	uploads\\1773211763219498400_Cam 07.webp	2026-03-11 12:19:23.221898
159	40	uploads\\1773211763221714400_Cam 09.webp	2026-03-11 12:19:23.225949
160	40	uploads\\1773211763227037000_Cam 09A.webp	2026-03-11 12:19:23.230145
161	40	uploads\\1773211763230156800_Cam 10.webp	2026-03-11 12:19:23.233582
162	41	uploads\\1773211908836227800_CAm-01_01_VIew-HI.webp	2026-03-11 12:21:48.84104
163	41	uploads\\1773211908846518600_CAm-02_VIew-HI.webp	2026-03-11 12:21:48.848223
164	41	uploads\\1773211908847933100_CAm-03_VIew-HI.webp	2026-03-11 12:21:48.849863
165	41	uploads\\1773211908849578900_CAm-04_VIew-HI.webp	2026-03-11 12:21:48.852606
166	41	uploads\\1773211908852838100_CAm-05_VIew-HI.webp	2026-03-11 12:21:48.854369
167	41	uploads\\1773211908854057900_CAm-06_VIew-HI.webp	2026-03-11 12:21:48.855967
168	41	uploads\\1773211908856098900_CAm-07_VIew-HI.webp	2026-03-11 12:21:48.857233
169	42	uploads\\1773212028957147300_Swetayan_ved_02_balcony view.webp	2026-03-11 12:23:48.959584
170	42	uploads\\1773212028959743400_Swetayan_ved_02_corner day view.webp	2026-03-11 12:23:48.962671
171	42	uploads\\1773212028962903300_Swetayan_ved_02_front view.webp	2026-03-11 12:23:48.96431
172	42	uploads\\1773212028964392300_Swetayan_ved_02_garden view.webp	2026-03-11 12:23:48.966035
173	42	uploads\\1773212028965928900_Swetayan_ved_02_gazebo view.webp	2026-03-11 12:23:48.96781
174	42	uploads\\1773212028967567400_Swetayan_ved_02_night view.webp	2026-03-11 12:23:48.969421
175	43	uploads\\1773212176350614100_Bird Eye View.webp	2026-03-11 12:26:16.353001
176	43	uploads\\1773212176354917100_Fv_Club House Back View Cam-10 - Sun Set.webp	2026-03-11 12:26:16.360601
177	43	uploads\\1773212176360902000_Fv_Club House Front View Cam-09 Day -1.webp	2026-03-11 12:26:16.365874
178	43	uploads\\1773212176366883600_Fv_Club House Front View Cam-09 dusk.webp	2026-03-11 12:26:16.371614
179	43	uploads\\1773212176371140300_Fv_Club House Top View Cam-03.webp	2026-03-11 12:26:16.379106
180	43	uploads\\1773212176377066300_Fv_Club House Top View Cam-004.webp	2026-03-11 12:26:16.38265
181	43	uploads\\1773212176382602700_Fv_Units Corner View.webp	2026-03-11 12:26:16.386756
182	43	uploads\\1773212176386909000_Fv_Units Gazebo Camera-07.webp	2026-03-11 12:26:16.390546
183	43	uploads\\1773212176390970500_Fv_Units Gazebo-2 Cam-15-1.webp	2026-03-11 12:26:16.395189
184	43	uploads\\1773212176394382300_Fv_Units Maze Garden Top View  Cam-16.webp	2026-03-11 12:26:16.398359
185	43	uploads\\1773212176398660600_Fv_Units Street View -3 Cam-12 Night.webp	2026-03-11 12:26:16.402532
186	43	uploads\\1773212176401030900_Fv_Units Street View.webp	2026-03-11 12:26:16.40851
187	43	uploads\\1773212176408520300_Fv_Units Street View-2 Cam-08 Day.webp	2026-03-11 12:26:16.412962
188	43	uploads\\1773212176412138200_FV_Units Street View-2 Cam-08 Evening.webp	2026-03-11 12:26:16.416562
189	43	uploads\\1773212176417187500_Fv_Units Street View-3 Day.webp	2026-03-11 12:26:16.420776
190	43	uploads\\1773212176417187500_GATE VIEW.webp	2026-03-11 12:26:16.425307
191	43	uploads\\1773212176425316400_R1_Gate View_night.webp	2026-03-11 12:26:16.42885
192	44	uploads\\1773212384828081000_Swetayan sharnam bird eye view.webp	2026-03-11 12:29:44.830326
193	44	uploads\\1773212384846348600_Swetayan sharnam club view.webp	2026-03-11 12:29:44.855219
194	44	uploads\\1773212384855538300_Swetayan sharnam entry gate view.webp	2026-03-11 12:29:44.860614
195	44	uploads\\1773212384859823800_Swetayan sharnam Gazebo Garden view.webp	2026-03-11 12:29:44.865699
196	44	uploads\\1773212384866222300_Swetayan Sharnam_corner night view (1).webp	2026-03-11 12:29:44.86918
197	44	uploads\\1773212384870682100_Swetayan sharnam_front night view.webp	2026-03-11 12:29:44.875796
198	44	uploads\\1773212384876290300_Swetayan sharnam_garden top view.webp	2026-03-11 12:29:44.879591
199	44	uploads\\1773212384879887200_Swetayan Sharnam_garden view.webp	2026-03-11 12:29:44.885091
200	44	uploads\\1773212384885058800_Swetayan sharnam_living room type 2.webp	2026-03-11 12:29:44.890243
201	44	uploads\\1773212384890194900_Swetayan sharnam_living room view.webp	2026-03-11 12:29:44.894189
202	44	uploads\\1773212384894196100_Swetayan sharnam_master bed room view.webp	2026-03-11 12:29:44.900536
203	44	uploads\\1773212384900967100_Swetayan sharnam_street view.webp	2026-03-11 12:29:44.905968
204	44	uploads\\1773212384904877100_TYPE_01_FFLOOR.webp	2026-03-11 12:29:44.909345
205	44	uploads\\1773212384909316400_TYPE_02_GFLOOR.webp	2026-03-11 12:29:44.911367
206	44	uploads\\1773212384909849000_TYPE_02_SFLOOR.webp	2026-03-11 12:29:44.916383
\.


--
-- TOC entry 5033 (class 0 OID 16485)
-- Dependencies: 222
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, project_name, project_type, thumbnail, status, created_at, description, client_name, location) FROM stdin;
31	KAVYAM	residential	uploads\\1773209296941746300_03 FRONT VIEW.webp	active	2026-03-11 11:38:16.954418	This residential project was designed with a focus on modern living, functionality, and natural light. The layout emphasizes open spaces, seamless indoor–outdoor connectivity, and efficient use of available area. Neutral color palettes and contemporary materials were selected to create a calm and elegant atmosphere.\r\n\r\nSpecial attention was given to ventilation, sustainability, and privacy, ensuring comfort for daily living while maintaining aesthetic appeal. The design reflects a balance between modern architecture and practical requirements.		AMARAIWADI
32	SHIVAM SKY	residential	uploads\\1773210283239196900_02 FRONT VIEW.webp	active	2026-03-11 11:54:43.24326	This residential project was designed with a focus on modern living, functionality, and natural light. The layout emphasizes open spaces, seamless indoor–outdoor connectivity, and efficient use of available area. Neutral color palettes and contemporary materials were selected to create a calm and elegant atmosphere.\r\n\r\nSpecial attention was given to ventilation, sustainability, and privacy, ensuring comfort for daily living while maintaining aesthetic appeal. The design reflects a balance between modern architecture and practical requirements.		LAMBHA
34	HIRABHAI METAL MARKET	commercial	uploads\\1773210682484566700_Fv_Estate Row Front View.webp	active	2026-03-11 12:01:22.490573	This commercial building was planned to support efficient workflow and a professional environment. The design incorporates clean lines, spacious interiors, and flexible layouts suitable for multiple business needs.		RAKHIYAL
35	KALRAV ARCADE	commercial	uploads\\1773210827749563600_Kalrav_Arcade_Front view.webp	active	2026-03-11 12:03:47.753423	This commercial building was planned to support efficient workflow and a professional environment. The design incorporates clean lines, spacious interiors, and flexible layouts suitable for multiple business needs.		KASHINDRA
36	R CAPITAL	commercial	uploads\\1773210957046727300_02 FRONT VIEW DAY.webp	active	2026-03-11 12:05:57.048653	This commercial building was planned to support efficient workflow and a professional environment. The design incorporates clean lines, spacious interiors, and flexible layouts suitable for multiple business needs.		JASHODA NAGAR
33	VIVANTA 36	residential	uploads\\1773210474817044200_03 FRONT VIEW.webp	active	2026-03-11 11:57:54.819159	This residential project was designed with a focus on modern living, functionality, and natural light. The layout emphasizes open spaces, seamless indoor–outdoor connectivity, and efficient use of available area. Neutral color palettes and contemporary materials were selected to create a calm and elegant atmosphere.\r\n\r\nSpecial attention was given to ventilation, sustainability, and privacy, ensuring comfort for daily living while maintaining aesthetic appeal. The design reflects a balance between modern architecture and practical requirements.	AR BUILDERS	RAMOL
27	ANKUR SCHOOL	school	uploads\\1773207109949324000_CAm-01_VIew-HI.webp	active	2026-03-11 11:01:49.961176	A student-friendly school design that encourages learning through light-filled classrooms, open spaces, and interactive environments.		NEW MANINAGAR
28	AARAMBH SCHOOL	school	uploads\\1773207539222667000_CAM 01.webp	active	2026-03-11 11:08:59.230121	A student-friendly school design that encourages learning through light-filled classrooms, open spaces, and interactive environments.		GHUMA
29	AMBUJA APARTMENT	residential	uploads\\1773208908025892600_01 SIDE VIEW.webp	active	2026-03-11 11:31:48.032163	This residential project was designed with a focus on modern living, functionality, and natural light. The layout emphasizes open spaces, seamless indoor–outdoor connectivity, and efficient use of available area. Neutral color palettes and contemporary materials were selected to create a calm and elegant atmosphere.		MANINAGAR
30	BAGH ONE-72	residential	uploads\\1773209043724476400_02 FRONT VIEW NIGHT.webp	active	2026-03-11 11:34:03.729231	This residential project was designed with a focus on modern living, functionality, and natural light. The layout emphasizes open spaces, seamless indoor–outdoor connectivity, and efficient use of available area. Neutral color palettes and contemporary materials were selected to create a calm and elegant atmosphere.		HATHIJAN
37	SWETAYAM ARCADE	commercial	uploads\\1773211131018758300_Swetayan arcade_front view.webp	active	2026-03-11 12:08:51.026027	This commercial building was planned to support efficient workflow and a professional environment. The design incorporates clean lines, spacious interiors, and flexible layouts suitable for multiple business needs.		KASHINDRA
38	SWARA	interior	uploads\\1773211361475825500_CAM-01.webp	active	2026-03-11 12:12:41.478864	The interior design project focuses on creating a warm, stylish, and functional space tailored to the client’s lifestyle. A harmonious blend of textures, lighting, and materials was used to enhance the overall experience of the space.		NAROL
39	COLIN NIKETAM	villa	uploads\\1773211589006313700_Fv_Morden Bunglow Front View.webp	active	2026-03-11 12:16:29.013173	his independent bungalow/villa is designed to offer a perfect balance of luxury, comfort, and privacy. The planning emphasizes spacious interiors, abundant natural light, and seamless indoor–outdoor connectivity. Large openings and thoughtfully positioned windows enhance ventilation while creating a strong visual connection with the surrounding landscape.		BECHRAJI
40	SHREE SHANTI VILLA	villa	uploads\\1773211734146241600_Cam 02.webp	active	2026-03-11 12:18:54.150016	his independent bungalow/villa is designed to offer a perfect balance of luxury, comfort, and privacy. The planning emphasizes spacious interiors, abundant natural light, and seamless indoor–outdoor connectivity. Large openings and thoughtfully positioned windows enhance ventilation while creating a strong visual connection with the surrounding landscape.		LAMBHA
41	SHREEJI IND.PARK	villa	uploads\\1773211878322696700_CAm-02_VIew-HI.webp	active	2026-03-11 12:21:18.324747	his independent bungalow/villa is designed to offer a perfect balance of luxury, comfort, and privacy. The planning emphasizes spacious interiors, abundant natural light, and seamless indoor–outdoor connectivity. Large openings and thoughtfully positioned windows enhance ventilation while creating a strong visual connection with the surrounding landscape.		DHAMATVAN
42	SWETAYAN VED	villa	uploads\\1773211991155292000_Swetayan_ved_02_front view.webp	active	2026-03-11 12:23:11.15773	his independent bungalow/villa is designed to offer a perfect balance of luxury, comfort, and privacy. The planning emphasizes spacious interiors, abundant natural light, and seamless indoor–outdoor connectivity. Large openings and thoughtfully positioned windows enhance ventilation while creating a strong visual connection with the surrounding landscape.		BHAT
43	SATTVA VANAM	villa	uploads\\1773212131726211800_Fv_Club House Front View Cam-09 Day -1.webp	active	2026-03-11 12:25:31.728799	his independent bungalow/villa is designed to offer a perfect balance of luxury, comfort, and privacy. The planning emphasizes spacious interiors, abundant natural light, and seamless indoor–outdoor connectivity. Large openings and thoughtfully positioned windows enhance ventilation while creating a strong visual connection with the surrounding landscape.		WANTHVADI
44	SWETAYAN SHARNAM	villa	uploads\\1773212334246333100_Swetayan sharnam_front night view.webp	active	2026-03-11 12:28:54.253207	his independent bungalow/villa is designed to offer a perfect balance of luxury, comfort, and privacy. The planning emphasizes spacious interiors, abundant natural light, and seamless indoor–outdoor connectivity. Large openings and thoughtfully positioned windows enhance ventilation while creating a strong visual connection with the surrounding landscape.		KASHINDRA
\.


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 219
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, true);


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 223
-- Name: project_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.project_images_id_seq', 206, true);


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 221
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projects_id_seq', 44, true);


--
-- TOC entry 4874 (class 2606 OID 16483)
-- Name: admins admins_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- TOC entry 4876 (class 2606 OID 16481)
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 16511)
-- Name: project_images project_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_images
    ADD CONSTRAINT project_images_pkey PRIMARY KEY (id);


--
-- TOC entry 4879 (class 2606 OID 16498)
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 1259 OID 16499)
-- Name: idx_projects_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projects_type ON public.projects USING btree (project_type);


--
-- TOC entry 4882 (class 2606 OID 16512)
-- Name: project_images project_images_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_images
    ADD CONSTRAINT project_images_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


-- Completed on 2026-04-09 17:12:46

--
-- PostgreSQL database dump complete
--

\unrestrict j4dw1S7d9olfH3gedhixnXIERXL2ejvdCLcCL8KfT9U92luFQbvPN0ps0w6UzAg

