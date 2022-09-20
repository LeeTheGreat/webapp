create user if not exists 'airline_admin'@'localhost' identified by 'password';
create database if not exists airline;
grant all privileges on airline.* to 'airline_admin'@'localhost' WITH GRANT OPTION;

use airline;
source aircraft.sql
source airline.sql
source country.sql
source airport_reduced.sql

CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int unsigned NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
);

CREATE TABLE IF NOT EXISTS `flights`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_num` VARCHAR(4) NOT NULL
	,`airline_id` INT NOT NULL
	,`aircraft_id` INT NOT NULL	
	,`src_airport_id` INT NOT NULL
	,`dst_airport_id` INT NOT NULL
	,`src_country_id` INT NOT NULL
	,`dst_country_id` INT NOT NULL
	,`depart` DATETIME NOT NULL
	,`arrive` DATETIME NOT NULL
	,`price` INT NOT NULL
	,`status` ENUM('active','cancelled','rescheduled')
	,CONSTRAINT fk_flight_airline_id FOREIGN KEY (airline_id) REFERENCES airlines(id)
	,CONSTRAINT fk_flight_src_airport_id FOREIGN KEY (src_airport_id) REFERENCES airports(id)
	,CONSTRAINT fk_flight_dst_airport_id FOREIGN KEY (dst_airport_id) REFERENCES airports(id)
	,CONSTRAINT fk_flight_src_country_id FOREIGN KEY (src_country_id) REFERENCES countries(id)
	,CONSTRAINT fk_flight_dst_country_id FOREIGN KEY (dst_country_id) REFERENCES countries(id)
	,CONSTRAINT fk_aircraft_id FOREIGN KEY (aircraft_id) REFERENCES aircrafts(id)
	,CONSTRAINT chk_flights_price CHECK (price >= 0)
	/*
		shouldn't have duplicate active flights with these same details
		can't implement it using unique key because I can't specify static values for status='active'
		may need to use WHERE NOT EXISTS (...) to check for duplicate, instead of UNIQUE KEY
	*/
	,UNIQUE KEY uk_flight (flt_num, src_airport_id, dst_airport_id, src_country_id, dst_country_id, depart, arrive, status)
	,INDEX idx_flight_uk (flt_num, src_airport_id, dst_airport_id, src_country_id, dst_country_id, depart, arrive, status)
);

CREATE TABLE IF NOT EXISTS `users`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`email` VARCHAR(50) NOT NULL UNIQUE
	,`password` CHAR(50) NOT NULL
	,`fname` CHAR(30) NOT NULL
	,`lname` CHAR(30) DEFAULT ''
	,`gender` CHAR(1) NOT NULL
	,`dob` DATE NOT NULL
	/*
	`country_id` INT NOT NULL,
	`state_id` INT NOT NULL,
	CONSTRAINT fk_users_country_id FOREIGN KEY (country_id) REFERENCES country(id),
	CONSTRAINT fk_users_state_id FOREIGN KEY (state_id) REFERENCES state(id)
	*/
);

CREATE TABLE IF NOT EXISTS `customers`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`user_id` INT DEFAULT NULL
	,`cust_email` VARCHAR(50) NOT NULL
	,`fname` CHAR(30) NOT NULL
	,`lname` CHAR(30)
	,`gender` CHAR(1) NOT NULL
	,`dob` DATE NOT NULL
	/*
	`country_id` INT NOT NULL,
	`state_id` INT NOT NULL,
	CONSTRAINT fk_users_country_id FOREIGN KEY (country_id) REFERENCES country(id),
	CONSTRAINT fk_users_state_id FOREIGN KEY (state_id) REFERENCES state(id)
	*/
	,CONSTRAINT fk_customers_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS `seats`(
	`id` INT AUTO_INCREMENT PRIMARY KEY 
	,`flt_id` INT NOT NULL
	,`seat_num` CHAR(3) NOT NULL
	,`available` BOOLEAN NOT NULL
	,CONSTRAINT fk_seat_airline_id_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
);

CREATE TABLE IF NOT EXISTS `bookings`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_id` INT
	,`cust_id` INT
	,`seat_id` INT
	,`datetime` DATETIME NOT NULL
	,`status` ENUM('active','cancelled','rescheduled')
	,CONSTRAINT fk_booking_cust_id FOREIGN KEY (cust_id) REFERENCES customers(id)
	,CONSTRAINT fk_booking_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
	,CONSTRAINT fk_booking_seat_id FOREIGN KEY (seat_id) REFERENCES seats(id)
);

CREATE TABLE IF NOT EXISTS `admins`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`username` VARCHAR(20) NOT NULL UNIQUE
	,`password` VARCHAR(50) NOT NULL
);

insert into admins (username, password) values ('admin', 'password');
use airline;
show tables;