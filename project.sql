/*Сайт https://www.volkswagen.ru/ru/models.html
База данных создана для подразделения Volkswagen, которое занимается производством и продажей автомобилей в России. 
В спроектированной БД хранится вся информация о модельном ряде, автомобилях в наличии и автомобилях с пробегом, сервисном обслуживании.*/ 


DROP DATABASE IF EXISTS volkswagen;
CREATE DATABASE volkswagen;
USE volkswagen;

DROP TABLE IF EXISTS cars;
CREATE TABLE cars (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    vin CHAR (17) UNIQUE, -- XW8ZZZ5NLG003388 уникальный код транспортного средства, состоящий из 17 знаков
    pts BIGINT (15) UNSIGNED UNIQUE -- 164251369851452 длина номера электронного ПТС 15 цифр от 0 до 9
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	car_id BIGINT UNSIGNED NOT NULL UNIQUE,
	model VARCHAR(100),
	date_of_production DATE,
	category ENUM ('new', 'used'), -- новая /с пробегом
	color VARCHAR(100),
	body_type ENUM ('HATCHBACK', 'SEDAN', 'SUVs', 'COMPACTS', 'OTHER'), -- седан / внедорожник / коммерческое авто
	price BIGINT UNSIGNED NOT NULL,
	transmission ENUM ('automatic', 'manual', 'robot'),
	engine ENUM ('petrol', 'diesel'),
	engine_volume BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE NOW()
);

ALTER TABLE profiles ADD CONSTRAINT fk_profiles_car_id
    FOREIGN KEY (car_id) REFERENCES cars(id)
    ON UPDATE CASCADE 
    ON DELETE RESTRICT;
   
DROP TABLE IF EXISTS dealers;
CREATE TABLE dealers(  
	dealer_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	dealer_name VARCHAR(50) NOT NULL UNIQUE,
	dealer_showroom_adress VARCHAR(100) NOT NULL,
	dealer_phone BIGINT UNSIGNED,
	dealer_email VARCHAR(100)
);

DROP TABLE IF EXISTS cars_dealers;
CREATE TABLE cars_dealers (
	car_id BIGINT UNSIGNED NOT NULL,
	dealer_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (car_id, dealer_id), 
    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (dealer_id) REFERENCES dealers(dealer_id)
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
	id SERIAL,
	name varchar(255) DEFAULT NULL,
    car_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (car_id) REFERENCES cars(id),
  	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- 'image', 'text', 'video'
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS news;
CREATE TABLE news(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    car_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS gallery;
CREATE TABLE gallery (
	id SERIAL,
	album_id BIGINT unsigned NULL,
	media_id BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES news(id)
);

DROP TABLE IF EXISTS services;
CREATE TABLE services (
	id SERIAL,
	service_name varchar(255) DEFAULT NULL, -- BASIC SERVICES / BODY REPAIR
    car_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (car_id) REFERENCES cars(id),
  	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS cars_services;
CREATE TABLE cars_services(
	car_id BIGINT UNSIGNED NOT NULL,
	service_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  
	PRIMARY KEY (car_id, service_id), 
    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);

DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
	id SERIAL,
	car_id BIGINT UNSIGNED DEFAULT NULL,
	firstname VARCHAR(50),
    lastname VARCHAR(50), 
    email VARCHAR(120),
    phone BIGINT UNSIGNED, 
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_clients_firstname (firstname),
    INDEX idx_clients_lastname (lastname),
    FOREIGN KEY (car_id) REFERENCES cars(id),
  	PRIMARY KEY (id)
 );

DROP TABLE IF EXISTS cars_clients;
CREATE TABLE cars_clients (
	car_id BIGINT UNSIGNED NOT NULL,
	client_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  
    PRIMARY KEY (car_id, client_id), 
    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

DROP TABLE IF EXISTS features;
CREATE TABLE features (
	id SERIAL,
	feature_name varchar(255) DEFAULT NULL, 
    car_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (car_id) REFERENCES cars(id),
  	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS cars_features;
CREATE TABLE cars_features (
	car_id BIGINT UNSIGNED NOT NULL,
	feature_id BIGINT UNSIGNED NOT NULL,
	
  	PRIMARY KEY (car_id, feature_id), 
    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (feature_id) REFERENCES features(id)
);

INSERT INTO cars (id, vin, pts)
VALUES
('1','XW8ZZZ5NLG003381', '164251369851452'),
('2','XW8ZZZ1NLG003381', '164251869851452'),
('3','XW8ZZZ8NLG003381', '164251369851453'),
('4','XW8ZZZ5NLG001381', '164251369861452'),
('5','XW8ZZZ5NLG002381', '164251369853452'),
('6','XW8ZZZ5NLG002391', '164251369853402'),
('7','XW8ZZZ5NLG002382', '164251369853752'),
('8','XW8ZZZ5NLG002383', '164251369852452'),
('9','XW8ZZZ5NLG000381', '164251369850052'),
('10','XW8ZZZ5NLG100381', '164751369857452'),
('11','XW8ZZZ5NLG000281', '164251369057452'),
('12','XW8ZZZ5NLG010381', '164251369867452'),
('13','XW8ZZZ5NLG000331', '164251389888452'),
('14','XW8ZZZ5NLG009321', '164251569850452'),
('15','XW8ZZZ5NLG100501', '164251379856452'),
('16','XW8ZZZ5NLG001401', '164351969851452'),
('17','XW8ZZZ5NLG008802', '164251389853452'),
('18','XW8ZZZ5NLG000321', '164251369857452'),
('19','XW8ZZZ5NLG090311', '164251319854452'),
('20','XW8ZZZ5NLG040302', '165251369857452'),
('21','XW8ZZZ5NLG100305', '164281369850452'),
('22','XW8ZZZ5NLG020301', '164251669851452'),
('23','XW8ZZZ5NLG050301', '164251660858452'),
('24','XW8ZZZ5NLG020311', '164251669855652'),
('25','XW8ZZZ5NLG090312', '164251669855952'),
('26','XW8ZZZ5NLG120308', '164251869855452'),
('27','XW8ZZZ5NLG020501', '164251669885452'),
('28','XW8ZZZ5NLG050307', '164251660855452')
;

INSERT INTO features (id, feature_name , car_id)
VALUES
('1', 'Heated Front Seats','2'),
('2', 'Adaptive Cruise Control', '1'),
('3', 'Bluetooth Connection', '3'),
('4', 'Premium Sound System', '9'),
('5', 'Navigation System', '5'),
('6', 'WiFi Hotspot', '6'),
('7', 'Smart Device Integration', '8'),
('8', 'Satellite Radio', '2'),
('9', 'Steering Wheel Audio Controls', '1'),
('10', 'Multi-Zone A/C7', '5'),
('11', 'Back-Up Camera10', '6'),
('12', 'Automatic Parking', '7'),
('13', 'Stability Control', '8'),
('14', 'Brake Assist', '2'),
('15', 'Blind Spot Monitor', '7'),
('16', 'Lane Departure Warning', '3'),
('17', 'Cross-Traffic Alert', '8'),
('18', 'Lane Keeping Assist', '9'),
('19', 'Cloth Seats', '1'),
('20', 'Leather Seats', '2'),
('21', 'Power Driver Seat', '4'),
('22', 'Seat Memory', '6'),
('23', 'Hands-Free Liftgate', '2'),
('24', 'Sun/Moonroof', '9'),
('25', 'Panoramic Roof', '5')
;

INSERT INTO services (id, service_name, car_id)
VALUES
('1', 'body repair', '9'),
('2', 'body repair', '3'),
('3', 'basic services', '5'),
('4', 'basic services', '2'),
('5', 'basic services', '8'),
('6', 'body repair', '4'),
('7', 'basic services', '1'),
('8', 'body repair', '2'),
('9', 'basic services', '5'),
('10', 'body repair', '7'),
('11', 'basic services', '9')
;

INSERT INTO cars_services (car_id, service_id, created_at, updated_at)
VALUES
('9', '1', '2016-02-26 10:34:10', '2016-02-26 10:34:10'),
('3', '2', '2018-02-26 10:34:10', '2018-02-26 10:34:10'),
('5', '3', '2016-02-26 10:34:10', '2016-02-26 10:34:10'),
('2', '4', '2016-02-26 10:34:10', '2016-02-26 10:34:10'),
('8', '5', '2019-02-26 10:34:10', '2019-02-26 10:34:10'),
('4', '6', '2016-02-26 10:34:10', '2016-02-26 10:34:10'),
('1', '7', '2016-02-26 10:34:10', '2016-02-26 10:34:10'),
('2', '8', '2016-02-26 10:34:10', '2016-02-26 10:34:10'),
('5', '9', '2016-02-26 10:34:10', '2016-02-26 10:34:10'),
('7', '10', '2016-02-26 10:34:10', '2016-02-26 10:34:10'),
('9', '11', '2016-02-26 10:34:10', '2016-02-26 10:34:10')
;

INSERT INTO profiles (car_id, model, date_of_production, category, color, body_type, price, transmission, engine, engine_volume, created_at, updated_at)
VALUES
('1', 'polo', '2008-08-26', 'used', 'DarkGray', 'SEDAN', '875000', 'manual', 'petrol', '1591', '2020-01-08 13:45:23', '2020-04-05 21:48:44'),
('2', 'jetta', '2020-01-28', 'new', 'SkyBlue', 'SEDAN', '1800900', 'robot', 'petrol', '1999', '2020-02-04 22:37:56', '2020-04-20 05:05:08'),
('3', 'golf', '2019-01-31', 'used', 'PeachPuff', 'OTHER', '985000', 'manual', 'petrol', '1591', '2020-03-11 12:50:29', '2020-07-15 15:47:52'),
('4', 'passat', '2020-04-02', 'new', 'LightSalmon', 'SEDAN', '2199900', 'manual', 'petrol', '2199', '2020-01-09 08:41:04', '1920-04-28 14:20:20'),
('5', 'teramont', '2019-08-28', 'used', 'Fuchsia', 'SUVs', '1500000', 'automatic', 'diesel', '1999', '2019-12-10 19:42:38', '2020-03-05 16:40:31'),
('6', 'tiguan', '2020-03-27', 'new', 'MediumVioletRed', 'SUVs', '1700000', 'robot', 'diesel', '2351', '2020-12-14 16:52:21', '2020-04-08 00:54:53'),
('7', 'touareg', '2020-11-20', 'new', 'LightSeaGreen', 'OTHER', '45360000', 'automatic', 'diesel', '1999', '2020-10-02 13:54:14', '2020-10-18 22:21:17'),
('8', 'caddy', '2015-11-19', 'used', 'Green', 'SUVs', '1150000', 'manual', 'petrol', '1591', '2015-03-02 21:57:07', '2015-11-18 07:16:23'),
('9', 'amarok', '2008-08-04', 'used', 'DimGray', 'SUVs', '890000', 'automatic', 'diesel', '1596', '2015-07-04 15:18:53', '2015-02-04 01:15:34'),
('10', 'multivan', '2020-07-30', 'new', 'Tomato', 'OTHER', '3706000', 'automatic', 'diesel', '1999', '2020-11-27 21:29:57', '2020-06-14 00:14:41'),
('11', 'california', '2020-10-17', 'new', 'DarkCyan', 'OTHER', '4415000', 'robot', 'diesel', '1591', '2020-05-10 17:10:35', '2020-07-02 08:59:20'),
('12', 'caravelle', '2020-11-25', 'new', 'DarkRed', 'OTHER', '3006000', 'robot', 'diesel', '1999', '2020-09-21 12:30:08', '2020-05-07 00:35:28'),
('13', 'caddy', '2006-05-08', 'used', 'White', 'COMPACTS', '750000', 'automatic', 'diesel', '1356', '2007-03-13 05:21:34', '2001-09-16 08:13:43'),
('14', 'transporter', '2020-04-10', 'new', 'YellowGreen', 'SEDAN', '2491000', 'automatic', 'petrol', '1999', '2020-06-11 00:58:56', '2020-05-06 08:17:25'),
('15', 'crafter', '2020-04-21', 'new', 'OrangeRed', 'COMPACTS', '2624000', 'robot', 'diesel', '1999', '2020-07-01 09:59:12', '2020-04-19 02:01:39'),
('16', 'caddy', '2020-11-27', 'new', 'NavajoWhite', 'SUVs', '1547000', 'manual', 'petrol', '1591', '2020-06-02 17:20:47', '2020-05-06 03:34:52'),
('17', 'touring', '2020-12-29', 'new', 'Maroon', 'COMPACTS', '3860000', 'automatic', 'petrol', '1999', '2020-09-22 03:55:15', '2020-06-11 14:37:28'),
('18', 'polo', '2020-11-16', 'new', 'Gold', 'SEDAN', '1043820', 'manual', 'petrol', '1591', '2020-01-31 18:58:46', '2020-04-07 10:36:47'),
('19', 'jetta', '2020-11-23', 'new', 'LightGoldenRodYellow', 'SEDAN', '1900000', 'automatic', 'diesel', '1999', '2020-02-24 04:29:37', '2020-08-27 15:52:40'),
('20', 'jetta', '2018-01-15', 'used', 'DarkRed', 'OTHER', '988000', 'manual', 'diesel', '1999', '2020-02-27 14:22:12', '2020-08-10 22:02:39'),
('21', 'tiguan', '2015-09-30', 'used', 'DarkGoldenRod', 'OTHER', '950000', 'automatic', 'diesel', '1999', '2020-07-23 02:12:50', '2020-10-07 08:18:50'),
('22', 'tiguan', '2020-03-12', 'new', 'SkyBlue', 'OTHER', '1718750', 'manual', 'petrol', '1999', '2020-03-20 19:46:57', '2020-04-22 03:12:52'),
('23', 'touareg', '2020-07-11', 'new', 'DarkViolet', 'OTHER', '4500000', 'manual', 'petrol', '1999', '2020-01-27 03:06:42', '2020-05-03 15:13:58'),
('24', 'tiguan', '2018-02-27', 'used', 'Snow', 'OTHER', '1430000', 'robot', 'petrol', '1999', '2020-09-20 13:03:37', '2020-09-30 00:26:50'),
('25', 'tiguan', '2019-03-24', 'used', 'LightYellow', 'OTHER', '1500000', 'manual', 'petrol', '1999', '2019-03-02 12:39:59', '2019-03-18 17:23:57'),
('26', 'touareg', '2020-05-09', 'new', 'HotPink', 'OTHER', '5000000', 'automatic', 'diesel', '1999', '2020-08-12 11:04:28', '2020-02-19 20:33:32'),
('27', 'tiguan', '2019-12-22', 'used', 'DeepPink', 'OTHER', '3500000', 'manual', 'petrol', '1999', '1983-07-11 11:05:23', '2018-08-04 07:21:09'),
('28', 'touareg', '2020-02-21', 'new', 'DeepPink', 'OTHER', '5300000', 'robot', 'petrol', '1999', '2020-05-03 05:20:53', '2020-07-30 01:38:06')
;

INSERT INTO dealers (dealer_id, dealer_name, dealer_showroom_adress, dealer_phone, dealer_email)
VALUES
('1', 'ROLF', 'Central', '4959856325', 'rolf@example.org'),
('2', 'ASC', 'East', '4952145896', 'asc@example.org'),
('3', 'MAJOR', 'MOSCOW', '4998563296', 'major@example.org'),
('4', 'AVTOMIR', 'MOSCOW', '4998569632', 'avtomir@example.org'),
('5', 'FAVORIT', 'South', '4957859632', 'favorit@example.net'),
('6', 'AVTOGERMES', 'Port', '4859658963', 'avtogermes@example.com'),
('7', 'SERVIS+', 'Port', '4958963263', 'servis@example.com'),
('8', 'AVILON', 'East', '4958745236', 'avilon@example.net'),
('9', 'AVTORUS', 'West', '49579412', 'avtorus@example.org'),
('10', 'AVTODOM', 'Port', '4956321693', 'avtodom@example.org'),
('11', 'GERMANIKA', 'New', '4956989632', 'germanika@example.org')
;

INSERT INTO cars_dealers (car_id, dealer_id)
VALUES 
('1', '1'),
('2', '2'),
('3', '2'),
('4', '5'),
('5', '1'),
('6', '2'),
('7', '5'),
('8', '1'),
('9', '6'),
('10', '1'),
('11', '10'),
('12', '11'),
('13', '1'),
('14', '2'),
('15', '2'),
('16', '5'),
('17', '1'),
('18', '2'),
('19', '5'),
('20', '1'),
('21', '6'),
('22', '1'),
('23', '10'),
('24', '11'),
('25', '1'),
('26', '6'),
('27', '1'),
('28', '10')
;

INSERT INTO clients (id, car_id, firstname, lastname, email, phone, created_at, updated_at)
VALUES
('1', '1', 'Abigayle', 'Bogisich', 'beer.devonte@example.net', '89152563698', '2012-05-22 13:09:36', '2016-01-18 19:00:29'),
('2', '2', 'Selena', 'Stoltenberg', 'kirlin.winston@example.org', '89152369856', '2020-06-26 17:03:41', '2020-11-24 03:30:18'),
('3', '3', 'Waylon', 'Stiedemann', 'breitenberg.albert@example.org', '89197859632', '2020-03-31 14:17:24', '2020-04-11 15:26:10'),
('4', '4', 'Travon', 'Kunde', 'jonathon.hansen@example.org', '81997458963', '2020-07-19 06:29:11', '2020-02-01 00:57:45'),
('5', '5', 'Kathleen', 'Olson', 'jennings37@example.com', '89152369874', '2020-03-23 08:33:59', '2020-01-26 22:18:34'),
('6', '6', 'Patience', 'Goodwin', 'gaylord.amaya@example.org', '89152369658', '2004-11-14 12:08:24', '2020-02-28 01:14:54'),
('7', '7', 'Tomas', 'Spinka', 'mcglynn.clinton@example.com', '89145874126', '2019-02-24 16:46:09', '2020-12-31 20:30:26'),
('8', '8', 'Melany', 'Huel', 'pacocha.estelle@example.org', '89182369636', '2001-03-13 06:16:30', '2020-08-19 18:37:05'),
('9', '9', 'Halie', 'Marquardt', 'simeon10@example.com', '89147459621', '2020-02-02 08:16:00', '2020-05-15 23:24:59'),
('10', '10', 'Fae', 'Padberg', 'koch.kimberly@example.org', '89141023698', '2003-09-20 09:18:05', '2020-05-14 20:56:19'),
('11', '11', 'Kaley', 'Denesik', 'yfunk@example.com', '87459632012', '2014-02-01 19:23:45', '2020-02-20 16:54:58')
;

INSERT INTO cars_clients (car_id, client_id, created_at, updated_at)
VALUES
('1', '1', '2020-02-21 02:23:22', '2020-11-21 15:57:37'),
('2', '2', '2020-02-25 02:23:22', '2020-11-25 15:57:37'),
('3', '3', '2020-02-27 02:23:22', '2020-02-27 15:57:37'),
('4', '4', '2020-11-21 02:23:22', '2020-11-21 15:57:37'),
('5', '5', '2020-02-21 02:23:22', '2020-11-21 15:57:37'),
('6', '6', '2020-02-05 02:23:22', '2020-11-21 15:57:37'),
('7', '7', '2020-02-08 02:23:22', '2020-11-21 15:57:37'),
('8', '8', '2020-02-10 02:23:22', '2020-11-21 15:57:37'),
('9', '9', '2020-02-10 02:23:22', '2020-11-10 15:57:37'),
('10', '10', '2020-02-18 02:23:22', '2020-11-18 15:57:37'),
('11', '11', '2020-02-15 02:23:22', '2020-11-15 15:57:37')
;

INSERT INTO cars_features (car_id, feature_id)
VALUES 
('1', '6'),
('2', '10'),
('3', '2'),
('4', '3'),
('5', '7'),
('6', '4'),
('7', '5'),
('8', '3'),
('9', '9'),
('10', '15'),
('11', '25'),
('12', '21'),
('13', '19'),
('14', '17'),
('15', '2'),
('16', '3')
;

INSERT INTO photo_albums (id, name, car_id) 
VALUES 
('1', 'beatae', '1'),
('2', 'facere', '2'),
('3', 'odit', '3'),
('4', 'id', '4'),
('5', 'voluptatibus', '5'),
('6', 'sed', '6'),
('7', 'dolorem', '7'),
('8', 'sed', '8'),
('9', 'repudiandae', '9'),
('10', 'quis', '10'),
('11', 'pariatur', '11'),
('12', 'quaerat', '12'),
('13', 'autem', '13'),
('14', 'velit', '14'),
('15', 'sed', '15'),
('16', 'omnis', '16'),
('17', 'cumque', '17')
;

INSERT INTO media_types (id, name, created_at, updated_at) 
VALUES 
('1', 'image', '2020-12-03 04:18:13', '2020-12-03 05:16:28'),
('2', 'text', '2020-12-03 04:18:13', '2020-12-03 05:16:28'),
('3', 'text', '2020-12-03 04:18:13', '2020-12-03 05:16:28')
;

INSERT INTO news (id, media_type_id, car_id, body, filename, created_at, updated_at)
VALUES
('1', '1', '1', 'Вот уже 40 лет Volkswagen Polo верой и правдой служат своим владельцам...', 'jpeg', '2020-12-03 04:18:13', '2020-12-03 05:16:28'),
('2', '1', '2', 'Создайте себе идеальную атмосферу', 'jpeg', '2021-01-03 04:18:13', '2021-01-03 05:16:28'),
('3', '1', '3', 'Тепло с первой минуты', 'jpeg', '2020-11-03 04:18:13', '2020-11-03 05:16:28')
;

INSERT INTO gallery (id, album_id, media_id)
VALUES
('1', '2', '1'),
('2', '3', '2'),
('3', '1', '3')
;

/* Количество автомобилей на складе по маркам */

SELECT 
    COUNT(*) as amount,
    model,
	date_of_production
FROM profiles 
GROUP BY model 
ORDER BY amount DESC;

SELECT 
	dealers.dealer_name AS dealer,
	dealers.dealer_showroom_adress AS car_showroom,
	profiles.price,
	cars_clients.car_id
	 
FROM cars_clients
JOIN dealers ON  dealers.dealer_id = cars_clients.car_id 
JOIN profiles ON profiles.car_id = dealers.dealer_id
GROUP BY cars_clients.car_id	
ORDER BY price

/* Информация по автомобилям, которые обращались в сервис */

CREATE or replace VIEW v_car_service AS
SELECT 
	model,
	date_of_production,
	cars_services.created_at AS date_of_service,
	services.service_name AS type_of_service,
	dealers.dealer_name AS dealer
FROM profiles
JOIN cars_services ON cars_services.car_id = profiles.car_id
JOIN services ON services.id = cars_services.service_id 
JOIN dealers ON dealer_id = services.car_id 


/* Статистика продаж по автосалонам */

CREATE or replace VIEW v_statistic AS
SELECT 
	COUNT(*) as sold,
	dealers.dealer_name AS dealer,
	dealers.dealer_showroom_adress AS car_showroom
	
FROM cars_dealers
JOIN dealers ON dealers.dealer_id = cars_dealers.car_id 
JOIN cars_clients ON cars_clients.client_id = cars_dealers.dealer_id
GROUP BY cars_dealers.dealer_id

/* Автомобили у диллера */

CREATE or replace VIEW v_cars AS

SELECT*
	FROM profiles
JOIN dealers ON dealers.dealer_id = profiles.car_id
JOIN cars_dealers ON cars_dealers.dealer_id = dealers.dealer_id

SELECT model,price
FROM v_cars;

/* Хранимая процедура на добавление нового автомобиля в базу данных*/

DROP PROCEDURE IF EXISTS sp_add_car;

DELIMITER $$

CREATE PROCEDURE volkswagen.sp_add_car(id BIGINT, vin CHAR(17), pts BIGINT(15), car_id BIGINT, model VARCHAR(100), date_of_production DATE, category ENUM ('new', 'used'), color VARCHAR(100), body_type ENUM ('HATCHBACK', 'SEDAN', 'SUVs', 'COMPACTS', 'OTHER'), price BIGINT, transmission ENUM ('automatic', 'manual', 'robot'), 
	engine ENUM ('petrol', 'diesel'), engine_volume BIGINT, created_at DATETIME, updated_at DATETIME, 
	OUT tran_result varchar(200))

BEGIN
	DECLARE `_rollback` BIT DEFAULT 0;
	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);
    
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   begin
    	SET `_rollback` = 1;
	GET stacked DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
         
    set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
   
   end;


START TRANSACTION;
	INSERT INTO cars (id, vin, pts)
	VALUES (id, vin, pts);

	INSERT INTO profiles (car_id, model, date_of_production, category, color, body_type, price, transmission, engine, engine_volume, created_at, updated_at)
	VALUES (last_insert_id(), model, date_of_production, category, color, body_type, price, transmission, engine, engine_volume, created_at, updated_at);
IF `_rollback`= 1 THEN
	       ROLLBACK;
ELSE
	set tran_result := 'ok';
	COMMIT;
END IF;
END$$

DELIMITER ;


/* Передаем данные*/

call sp_add_car ('29','XX8ZZZ5NLG050301', '165251660855458', '29', 'touareg', '2020-02-21', 'new', 'GREY', 'OTHER', '5300000', 'robot', 'petrol', '1999', '2021-01-26 05:20:53', '2021-01-26 01:38:06', @tran_result);
SELECT @tran_result;

SELECT * from cars ORDER BY id DESC;
SELECT * from profiles ORDER BY car_id DESC;
