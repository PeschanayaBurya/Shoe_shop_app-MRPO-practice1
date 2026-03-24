--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2026-03-24 16:03:39

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

DROP DATABASE shoe_shop;
--
-- TOC entry 5015 (class 1262 OID 16388)
-- Name: shoe_shop; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE shoe_shop WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE shoe_shop OWNER TO postgres;

\connect shoe_shop

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
-- TOC entry 222 (class 1259 OID 16447)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    categoryid integer NOT NULL,
    categoryname character varying(100) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16446)
-- Name: categories_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_categoryid_seq OWNER TO postgres;

--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 221
-- Name: categories_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_categoryid_seq OWNED BY public.categories.categoryid;


--
-- TOC entry 224 (class 1259 OID 16456)
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manufacturers (
    manufacturerid integer NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.manufacturers OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16455)
-- Name: manufacturers_manufacturerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manufacturers_manufacturerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.manufacturers_manufacturerid_seq OWNER TO postgres;

--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 223
-- Name: manufacturers_manufacturerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manufacturers_manufacturerid_seq OWNED BY public.manufacturers.manufacturerid;


--
-- TOC entry 231 (class 1259 OID 16543)
-- Name: orderdetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderdetails (
    orderdetailid integer NOT NULL,
    orderid integer NOT NULL,
    productvendorcode character varying(20) NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT orderdetails_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.orderdetails OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16542)
-- Name: orderdetails_orderdetailid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orderdetails_orderdetailid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orderdetails_orderdetailid_seq OWNER TO postgres;

--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 230
-- Name: orderdetails_orderdetailid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orderdetails_orderdetailid_seq OWNED BY public.orderdetails.orderdetailid;


--
-- TOC entry 235 (class 1259 OID 16588)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    orderid integer NOT NULL,
    orderdate date NOT NULL,
    deliverydate date,
    pickuppointid integer,
    userid integer,
    pickupcode character varying(10) NOT NULL,
    statusid integer,
    CONSTRAINT orders_check CHECK (((deliverydate IS NULL) OR (deliverydate >= orderdate)))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16587)
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_orderid_seq OWNER TO postgres;

--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 234
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;


--
-- TOC entry 233 (class 1259 OID 16565)
-- Name: orderstatuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderstatuses (
    statusid integer NOT NULL,
    statusname character varying(50) NOT NULL,
    description character varying(200),
    sortorder integer DEFAULT 0
);


ALTER TABLE public.orderstatuses OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16564)
-- Name: orderstatuses_statusid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orderstatuses_statusid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orderstatuses_statusid_seq OWNER TO postgres;

--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 232
-- Name: orderstatuses_statusid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orderstatuses_statusid_seq OWNED BY public.orderstatuses.statusid;


--
-- TOC entry 229 (class 1259 OID 16511)
-- Name: pickuppoints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pickuppoints (
    pickuppointid integer NOT NULL,
    index character varying(10),
    city character varying(100),
    street character varying(200),
    numberhome character varying(20)
);


ALTER TABLE public.pickuppoints OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16510)
-- Name: pickuppoints_pickuppointid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pickuppoints_pickuppointid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pickuppoints_pickuppointid_seq OWNER TO postgres;

--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 228
-- Name: pickuppoints_pickuppointid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pickuppoints_pickuppointid_seq OWNED BY public.pickuppoints.pickuppointid;


--
-- TOC entry 227 (class 1259 OID 16473)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    vendorcode character varying(20) NOT NULL,
    productname character varying(200) NOT NULL,
    price numeric(10,2) NOT NULL,
    supplierid integer,
    manufacturerid integer,
    categoryid integer,
    currentdiscount integer DEFAULT 0,
    quantityinstock integer DEFAULT 0 NOT NULL,
    description text,
    photo character varying(500),
    unit character varying(50),
    CONSTRAINT products_currentdiscount_check CHECK (((currentdiscount >= 0) AND (currentdiscount <= 100))),
    CONSTRAINT products_price_check CHECK ((price > (0)::numeric)),
    CONSTRAINT products_quantityinstock_check CHECK ((quantityinstock >= 0))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16424)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    roleid integer NOT NULL,
    namerole character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16423)
-- Name: roles_roleid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_roleid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_roleid_seq OWNER TO postgres;

--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 217
-- Name: roles_roleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_roleid_seq OWNED BY public.roles.roleid;


--
-- TOC entry 226 (class 1259 OID 16465)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    supplierid integer NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16464)
-- Name: suppliers_supplierid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_supplierid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_supplierid_seq OWNER TO postgres;

--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 225
-- Name: suppliers_supplierid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_supplierid_seq OWNED BY public.suppliers.supplierid;


--
-- TOC entry 220 (class 1259 OID 16433)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    fullname character varying(200) NOT NULL,
    login character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    roleid integer NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16432)
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_userid_seq OWNER TO postgres;

--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;


--
-- TOC entry 4788 (class 2604 OID 16450)
-- Name: categories categoryid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN categoryid SET DEFAULT nextval('public.categories_categoryid_seq'::regclass);


--
-- TOC entry 4789 (class 2604 OID 16459)
-- Name: manufacturers manufacturerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers ALTER COLUMN manufacturerid SET DEFAULT nextval('public.manufacturers_manufacturerid_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 16546)
-- Name: orderdetails orderdetailid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails ALTER COLUMN orderdetailid SET DEFAULT nextval('public.orderdetails_orderdetailid_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 16591)
-- Name: orders orderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 16568)
-- Name: orderstatuses statusid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderstatuses ALTER COLUMN statusid SET DEFAULT nextval('public.orderstatuses_statusid_seq'::regclass);


--
-- TOC entry 4793 (class 2604 OID 16514)
-- Name: pickuppoints pickuppointid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pickuppoints ALTER COLUMN pickuppointid SET DEFAULT nextval('public.pickuppoints_pickuppointid_seq'::regclass);


--
-- TOC entry 4786 (class 2604 OID 16427)
-- Name: roles roleid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN roleid SET DEFAULT nextval('public.roles_roleid_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 16468)
-- Name: suppliers supplierid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN supplierid SET DEFAULT nextval('public.suppliers_supplierid_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 16436)
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- TOC entry 4996 (class 0 OID 16447)
-- Dependencies: 222
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categories VALUES (1, 'Женская обувь');
INSERT INTO public.categories VALUES (2, 'Мужская обувь');


--
-- TOC entry 4998 (class 0 OID 16456)
-- Dependencies: 224
-- Data for Name: manufacturers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.manufacturers VALUES (1, 'Kari');
INSERT INTO public.manufacturers VALUES (2, 'Marco Tozzi');
INSERT INTO public.manufacturers VALUES (3, 'Рос');
INSERT INTO public.manufacturers VALUES (4, 'Rieker');
INSERT INTO public.manufacturers VALUES (5, 'Alessio Nesca');
INSERT INTO public.manufacturers VALUES (6, 'CROSBY');


--
-- TOC entry 5005 (class 0 OID 16543)
-- Dependencies: 231
-- Data for Name: orderdetails; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orderdetails VALUES (1, 1, 'F635R4', 2);
INSERT INTO public.orderdetails VALUES (2, 2, 'H782T5', 1);
INSERT INTO public.orderdetails VALUES (3, 2, 'G783F5', 1);
INSERT INTO public.orderdetails VALUES (4, 3, 'J384T6', 10);
INSERT INTO public.orderdetails VALUES (5, 3, 'D572U8', 10);
INSERT INTO public.orderdetails VALUES (6, 4, 'F572H7', 5);
INSERT INTO public.orderdetails VALUES (7, 4, 'D329H3', 4);
INSERT INTO public.orderdetails VALUES (8, 5, 'А112Т4', 2);
INSERT INTO public.orderdetails VALUES (9, 5, 'F635R4', 2);
INSERT INTO public.orderdetails VALUES (10, 6, 'H782T5', 1);
INSERT INTO public.orderdetails VALUES (11, 6, 'G783F5', 1);
INSERT INTO public.orderdetails VALUES (12, 7, 'J384T6', 10);
INSERT INTO public.orderdetails VALUES (13, 7, 'D572U8', 10);
INSERT INTO public.orderdetails VALUES (14, 8, 'F572H7', 5);
INSERT INTO public.orderdetails VALUES (15, 8, 'D329H3', 4);
INSERT INTO public.orderdetails VALUES (16, 9, 'B320R5', 5);
INSERT INTO public.orderdetails VALUES (17, 9, 'G432E4', 1);
INSERT INTO public.orderdetails VALUES (18, 10, 'S213E3', 5);
INSERT INTO public.orderdetails VALUES (19, 10, 'E482R4', 5);


--
-- TOC entry 5009 (class 0 OID 16588)
-- Dependencies: 235
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orders VALUES (1, '2025-02-27', '2025-04-20', 1, 4, '901', 5);
INSERT INTO public.orders VALUES (2, '2022-09-28', '2025-04-21', 11, 1, '902', 5);
INSERT INTO public.orders VALUES (3, '2025-03-21', '2025-04-22', 2, 2, '903', 5);
INSERT INTO public.orders VALUES (4, '2025-02-20', '2025-04-23', 11, 3, '904', 5);
INSERT INTO public.orders VALUES (5, '2025-03-17', '2025-04-24', 2, 4, '905', 5);
INSERT INTO public.orders VALUES (6, '2025-03-01', '2025-04-25', 15, 1, '906', 5);
INSERT INTO public.orders VALUES (7, '2025-03-02', '2025-04-26', 3, 2, '907', 5);
INSERT INTO public.orders VALUES (8, '2025-03-31', '2025-04-27', 19, 3, '908', 1);
INSERT INTO public.orders VALUES (9, '2025-04-02', '2025-04-28', 5, 4, '909', 1);
INSERT INTO public.orders VALUES (10, '2025-04-03', '2025-04-29', 19, 4, '910', 1);


--
-- TOC entry 5007 (class 0 OID 16565)
-- Dependencies: 233
-- Data for Name: orderstatuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orderstatuses VALUES (1, 'Новый', 'Заказ только создан, ожидает обработки', 1);
INSERT INTO public.orderstatuses VALUES (2, 'В обработке', 'Заказ подтвержден, собирается', 2);
INSERT INTO public.orderstatuses VALUES (3, 'Отправлен', 'Заказ передан в доставку', 3);
INSERT INTO public.orderstatuses VALUES (4, 'Доставлен', 'Заказ доставлен до пункта выдачи', 4);
INSERT INTO public.orderstatuses VALUES (5, 'Завершен', 'Заказ успешно завершен', 5);
INSERT INTO public.orderstatuses VALUES (6, 'Отменен', 'Заказ отменен', 6);


--
-- TOC entry 5003 (class 0 OID 16511)
-- Dependencies: 229
-- Data for Name: pickuppoints; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pickuppoints VALUES (1, '420151', 'Лесной', 'Вишневая', '32');
INSERT INTO public.pickuppoints VALUES (2, '125061', 'Лесной', 'Подгорная', '8');
INSERT INTO public.pickuppoints VALUES (3, '630370', 'Лесной', 'Шоссейная', '24');
INSERT INTO public.pickuppoints VALUES (4, '400562', 'Лесной', 'Зеленая', '32');
INSERT INTO public.pickuppoints VALUES (5, '614510', 'Лесной', 'Маяковского', '47');
INSERT INTO public.pickuppoints VALUES (6, '410542', 'Лесной', 'Светлая', '46');
INSERT INTO public.pickuppoints VALUES (7, '620839', 'Лесной', 'Цветочная', '8');
INSERT INTO public.pickuppoints VALUES (8, '443890', 'Лесной', 'Коммунистическая', '1');
INSERT INTO public.pickuppoints VALUES (9, '603379', 'Лесной', 'Спортивная', '46');
INSERT INTO public.pickuppoints VALUES (10, '603721', 'Лесной', 'Гоголя', '41');
INSERT INTO public.pickuppoints VALUES (11, '410172', 'Лесной', 'Северная', '13');
INSERT INTO public.pickuppoints VALUES (12, '614611', 'Лесной', 'Молодежная', '50');
INSERT INTO public.pickuppoints VALUES (13, '454311', 'Лесной', 'Новая', '19');
INSERT INTO public.pickuppoints VALUES (14, '660007', 'Лесной', 'Октябрьская', '19');
INSERT INTO public.pickuppoints VALUES (15, '603036', 'Лесной', 'Садовая', '4');
INSERT INTO public.pickuppoints VALUES (16, '394060', 'Лесной', 'Фрунзе', '43');
INSERT INTO public.pickuppoints VALUES (17, '410661', 'Лесной', 'Школьная', '50');
INSERT INTO public.pickuppoints VALUES (18, '625590', 'Лесной', 'Коммунистическая', '20');
INSERT INTO public.pickuppoints VALUES (19, '625683', 'Лесной', '8 Марта', NULL);
INSERT INTO public.pickuppoints VALUES (20, '450983', 'Лесной', 'Комсомольская', '26');
INSERT INTO public.pickuppoints VALUES (21, '394782', 'Лесной', 'Чехова', '3');
INSERT INTO public.pickuppoints VALUES (22, '603002', 'Лесной', 'Дзержинского', '28');
INSERT INTO public.pickuppoints VALUES (23, '450558', 'Лесной', 'Набережная', '30');
INSERT INTO public.pickuppoints VALUES (24, '344288', 'Лесной', 'Чехова', '1');
INSERT INTO public.pickuppoints VALUES (25, '614164', 'Лесной', 'Степная', '30');
INSERT INTO public.pickuppoints VALUES (26, '394242', 'Лесной', 'Коммунистическая', '43');
INSERT INTO public.pickuppoints VALUES (27, '660540', 'Лесной', 'Солнечная', '25');
INSERT INTO public.pickuppoints VALUES (28, '125837', 'Лесной', 'Шоссейная', '40');
INSERT INTO public.pickuppoints VALUES (29, '125703', 'Лесной', 'Партизанская', '49');
INSERT INTO public.pickuppoints VALUES (30, '625283', 'Лесной', 'Победы', '46');
INSERT INTO public.pickuppoints VALUES (31, '614753', 'Лесной', 'Полевая', '35');
INSERT INTO public.pickuppoints VALUES (32, '426030', 'Лесной', 'Маяковского', '44');
INSERT INTO public.pickuppoints VALUES (33, '450375', 'Лесной', 'Клубная', '44');
INSERT INTO public.pickuppoints VALUES (34, '625560', 'Лесной', 'Некрасова', '12');
INSERT INTO public.pickuppoints VALUES (35, '630201', 'Лесной', 'Комсомольская', '17');
INSERT INTO public.pickuppoints VALUES (36, '190949', 'Лесной', 'Мичурина', '26');


--
-- TOC entry 5001 (class 0 OID 16473)
-- Dependencies: 227
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES ('B431R5', 'Ботинки', 2700.00, 2, 4, 2, 2, 5, 'Мужские кожаные ботинки/мужские ботинки', NULL, 'шт.');
INSERT INTO public.products VALUES ('S213E3', 'Полуботинки', 2156.00, 2, 6, 2, 3, 6, '407700/01-01 Полуботинки мужские CROSBY', NULL, 'шт.');
INSERT INTO public.products VALUES ('E482R4', 'Полуботинки', 1800.00, 1, 1, 1, 2, 14, 'Полуботинки kari женские MYZ20S-149, размер 41, цвет: черный', NULL, 'шт.');
INSERT INTO public.products VALUES ('S634B5', 'Кеды', 5500.00, 2, 6, 2, 3, 0, 'Кеды Caprice мужские демисезонные, размер 42, цвет черный', NULL, 'шт.');
INSERT INTO public.products VALUES ('K345R4', 'Полуботинки', 2100.00, 2, 6, 2, 2, 3, '407700/01-02 Полуботинки мужские CROSBY', NULL, 'шт.');
INSERT INTO public.products VALUES ('O754F4', 'Туфли', 5400.00, 2, 4, 1, 4, 18, 'Туфли женские демисезонные Rieker артикул 55073-68/37', NULL, 'шт.');
INSERT INTO public.products VALUES ('G531F4', 'Ботинки', 6600.00, 1, 1, 1, 12, 9, 'Ботинки женские зимние ROMER арт. 893167-01 Черный', NULL, 'шт.');
INSERT INTO public.products VALUES ('J542F5', 'Тапочки', 500.00, 1, 1, 2, 13, 0, 'Тапочки мужские Арт.70701-55-67син р.41', NULL, 'шт.');
INSERT INTO public.products VALUES ('P764G4', 'Туфли', 6800.00, 1, 6, 1, 15, 15, 'Туфли женские, ARGO, размер 38', NULL, 'шт.');
INSERT INTO public.products VALUES ('C436G5', 'Ботинки', 10200.00, 1, 5, 1, 15, 9, 'Ботинки женские, ARGO, размер 40', NULL, 'шт.');
INSERT INTO public.products VALUES ('F427R5', 'Ботинки', 11800.00, 2, 4, 1, 15, 11, 'Ботинки на молнии с декоративной пряжкой FRAU', NULL, 'шт.');
INSERT INTO public.products VALUES ('N457T5', 'Полуботинки', 4600.00, 1, 6, 1, 3, 13, 'Полуботинки Ботинки черные зимние, мех', NULL, 'шт.');
INSERT INTO public.products VALUES ('D364R4', 'Туфли', 12400.00, 1, 1, 1, 16, 5, 'Туфли Luiza Belly женские Kate-lazo черные из натуральной замши', NULL, 'шт.');
INSERT INTO public.products VALUES ('S326R5', 'Тапочки', 9900.00, 2, 6, 2, 17, 15, 'Мужские кожаные тапочки "Профиль С.Дали" ', NULL, 'шт.');
INSERT INTO public.products VALUES ('L754R4', 'Полуботинки', 1700.00, 1, 1, 1, 2, 7, 'Полуботинки kari женские WB2020SS-26, размер 38, цвет: черный', NULL, 'шт.');
INSERT INTO public.products VALUES ('M542T5', 'Кроссовки', 2800.00, 2, 4, 2, 18, 3, 'Кроссовки мужские TOFA', NULL, 'шт.');
INSERT INTO public.products VALUES ('D268G5', 'Туфли', 4399.00, 2, 4, 1, 3, 12, 'Туфли Rieker женские демисезонные, размер 36, цвет коричневый', NULL, 'шт.');
INSERT INTO public.products VALUES ('T324F5', 'Сапоги', 4699.00, 1, 6, 1, 2, 5, 'Сапоги замша Цвет: синий', NULL, 'шт.');
INSERT INTO public.products VALUES ('K358H6', 'Тапочки', 599.00, 1, 4, 2, 20, 2, 'Тапочки мужские син р.41', NULL, 'шт.');
INSERT INTO public.products VALUES ('H535R5', 'Ботинки', 2300.00, 2, 4, 1, 2, 7, 'Женские Ботинки демисезонные', NULL, 'шт.');
INSERT INTO public.products VALUES ('А112Т4', 'Ботинки', 4990.00, 1, 1, 1, 3, 6, 'Женские Ботинки демисезонные kari', '1.jpg', 'шт.');
INSERT INTO public.products VALUES ('F635R4', 'Ботинки', 3244.00, 2, 2, 1, 2, 13, 'Ботинки Marco Tozzi женские демисезонные, размер 39, цвет бежевый', '2.jpg', 'шт.');
INSERT INTO public.products VALUES ('H782T5', 'Туфли', 4499.00, 1, 1, 2, 4, 5, 'Туфли kari мужские классика MYZ21AW-450A, размер 43, цвет: черный', '3.jpg', 'шт.');
INSERT INTO public.products VALUES ('G783F5', 'Ботинки', 5900.00, 1, 3, 2, 2, 8, 'Мужские ботинки Рос-Обувь кожаные с натуральным мехом', '4.jpg', 'шт.');
INSERT INTO public.products VALUES ('J384T6', 'Ботинки', 3800.00, 2, 4, 2, 2, 16, 'B3430/14 Полуботинки мужские Rieker', '5.jpg', 'шт.');
INSERT INTO public.products VALUES ('D572U8', 'Кроссовки', 4100.00, 2, 3, 2, 3, 6, '129615-4 Кроссовки мужские', '6.jpg', 'шт.');
INSERT INTO public.products VALUES ('F572H7', 'Туфли', 2700.00, 1, 2, 1, 2, 14, 'Туфли Marco Tozzi женские летние, размер 39, цвет черный', '7.jpg', 'шт.');
INSERT INTO public.products VALUES ('D329H3', 'Полуботинки', 1890.00, 2, 5, 1, 4, 4, 'Полуботинки Alessio Nesca женские 3-30797-47, размер 37, цвет: бордовый', '8.jpg', 'шт.');
INSERT INTO public.products VALUES ('B320R5', 'Туфли', 4300.00, 1, 4, 1, 2, 6, 'Туфли Rieker женские демисезонные, размер 41, цвет коричневый', '9.jpg', 'шт.');
INSERT INTO public.products VALUES ('G432E4', 'Туфли', 2800.00, 1, 1, 1, 3, 15, 'Туфли kari женские TR-YR-413017, размер 37, цвет: черный', '10.jpg', 'шт.');


--
-- TOC entry 4992 (class 0 OID 16424)
-- Dependencies: 218
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES (1, 'Администратор');
INSERT INTO public.roles VALUES (2, 'Менеджер');
INSERT INTO public.roles VALUES (3, 'Авторизированный клиент');


--
-- TOC entry 5000 (class 0 OID 16465)
-- Dependencies: 226
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.suppliers VALUES (1, 'Kari');
INSERT INTO public.suppliers VALUES (2, 'Обувь для вас');


--
-- TOC entry 4994 (class 0 OID 16433)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (1, 'Никифорова Весения Николаевна', '94d5ous@gmail.com', 'uzWC67', 1);
INSERT INTO public.users VALUES (2, 'Сазонов Руслан Германович', 'uth4iz@mail.com', '2L6KZG', 1);
INSERT INTO public.users VALUES (3, 'Одинцов Серафим Артёмович', 'yzls62@outlook.com', 'JlFRCZ', 1);
INSERT INTO public.users VALUES (4, 'Степанов Михаил Артёмович', '1diph5e@tutanota.com', '8ntwUp', 2);
INSERT INTO public.users VALUES (5, 'Ворсин Петр Евгеньевич', 'tjde7c@yahoo.com', 'YOyhfR', 2);
INSERT INTO public.users VALUES (6, 'Старикова Елена Павловна', 'wpmrc3do@tutanota.com', 'RSbvHv', 2);
INSERT INTO public.users VALUES (7, 'Михайлюк Анна Вячеславовна', '5d4zbu@tutanota.com', 'rwVDh9', 3);
INSERT INTO public.users VALUES (8, 'Ситдикова Елена Анатольевна', 'ptec8ym@yahoo.com', 'LdNyos', 3);
INSERT INTO public.users VALUES (9, 'Ворсин Петр Евгеньевич', '1qz4kw@mail.com', 'gynQMT', 3);
INSERT INTO public.users VALUES (10, 'Старикова Елена Павловна', '4np6se@mail.com', 'AtnDjr', 3);


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 221
-- Name: categories_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_categoryid_seq', 2, true);


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 223
-- Name: manufacturers_manufacturerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manufacturers_manufacturerid_seq', 6, true);


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 230
-- Name: orderdetails_orderdetailid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orderdetails_orderdetailid_seq', 19, true);


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 234
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 10, true);


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 232
-- Name: orderstatuses_statusid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orderstatuses_statusid_seq', 6, true);


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 228
-- Name: pickuppoints_pickuppointid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pickuppoints_pickuppointid_seq', 36, true);


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 217
-- Name: roles_roleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_roleid_seq', 3, true);


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 225
-- Name: suppliers_supplierid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_supplierid_seq', 2, true);


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_userid_seq', 10, true);


--
-- TOC entry 4812 (class 2606 OID 16454)
-- Name: categories categories_categoryname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_categoryname_key UNIQUE (categoryname);


--
-- TOC entry 4814 (class 2606 OID 16452)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (categoryid);


--
-- TOC entry 4816 (class 2606 OID 16463)
-- Name: manufacturers manufacturers_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_name_key UNIQUE (name);


--
-- TOC entry 4818 (class 2606 OID 16461)
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (manufacturerid);


--
-- TOC entry 4828 (class 2606 OID 16551)
-- Name: orderdetails orderdetails_orderid_productvendorcode_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT orderdetails_orderid_productvendorcode_key UNIQUE (orderid, productvendorcode);


--
-- TOC entry 4830 (class 2606 OID 16549)
-- Name: orderdetails orderdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT orderdetails_pkey PRIMARY KEY (orderdetailid);


--
-- TOC entry 4836 (class 2606 OID 16594)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- TOC entry 4832 (class 2606 OID 16571)
-- Name: orderstatuses orderstatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderstatuses
    ADD CONSTRAINT orderstatuses_pkey PRIMARY KEY (statusid);


--
-- TOC entry 4834 (class 2606 OID 16573)
-- Name: orderstatuses orderstatuses_statusname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderstatuses
    ADD CONSTRAINT orderstatuses_statusname_key UNIQUE (statusname);


--
-- TOC entry 4826 (class 2606 OID 16516)
-- Name: pickuppoints pickuppoints_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pickuppoints
    ADD CONSTRAINT pickuppoints_pkey PRIMARY KEY (pickuppointid);


--
-- TOC entry 4824 (class 2606 OID 16485)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (vendorcode);


--
-- TOC entry 4804 (class 2606 OID 16431)
-- Name: roles roles_namerole_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_namerole_key UNIQUE (namerole);


--
-- TOC entry 4806 (class 2606 OID 16429)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (roleid);


--
-- TOC entry 4820 (class 2606 OID 16472)
-- Name: suppliers suppliers_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_name_key UNIQUE (name);


--
-- TOC entry 4822 (class 2606 OID 16470)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplierid);


--
-- TOC entry 4808 (class 2606 OID 16440)
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- TOC entry 4810 (class 2606 OID 16438)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- TOC entry 4841 (class 2606 OID 16610)
-- Name: orderdetails fk_orderdetails_orders; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT fk_orderdetails_orders FOREIGN KEY (orderid) REFERENCES public.orders(orderid) ON DELETE CASCADE;


--
-- TOC entry 4842 (class 2606 OID 16557)
-- Name: orderdetails orderdetails_productvendorcode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT orderdetails_productvendorcode_fkey FOREIGN KEY (productvendorcode) REFERENCES public.products(vendorcode) ON DELETE RESTRICT;


--
-- TOC entry 4843 (class 2606 OID 16595)
-- Name: orders orders_pickuppointid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pickuppointid_fkey FOREIGN KEY (pickuppointid) REFERENCES public.pickuppoints(pickuppointid) ON DELETE RESTRICT;


--
-- TOC entry 4844 (class 2606 OID 16605)
-- Name: orders orders_statusid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_statusid_fkey FOREIGN KEY (statusid) REFERENCES public.orderstatuses(statusid) ON DELETE RESTRICT;


--
-- TOC entry 4845 (class 2606 OID 16600)
-- Name: orders orders_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(userid) ON DELETE RESTRICT;


--
-- TOC entry 4838 (class 2606 OID 16496)
-- Name: products products_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.categories(categoryid) ON DELETE SET NULL;


--
-- TOC entry 4839 (class 2606 OID 16491)
-- Name: products products_manufacturerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_manufacturerid_fkey FOREIGN KEY (manufacturerid) REFERENCES public.manufacturers(manufacturerid) ON DELETE SET NULL;


--
-- TOC entry 4840 (class 2606 OID 16486)
-- Name: products products_supplierid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES public.suppliers(supplierid) ON DELETE SET NULL;


--
-- TOC entry 4837 (class 2606 OID 16441)
-- Name: users users_roleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_roleid_fkey FOREIGN KEY (roleid) REFERENCES public.roles(roleid) ON DELETE RESTRICT;


-- Completed on 2026-03-24 16:03:40

--
-- PostgreSQL database dump complete
--

