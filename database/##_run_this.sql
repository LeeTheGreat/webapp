create user 'airline'@'localhost' identified by 'password';
create database airline;
grant all privileges on airline.* to airline;

source aircraft.sql
source airline.sql
source country.sql
source state.sql
source airport.sql

CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int unsigned NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
);

CREATE TABLE IF NOT EXISTS `flights`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`airline_id` INT NOT NULL,
	`flt_num` VARCHAR(4) NOT NULL,
	`src_airport_id` INT NOT NULL,
	`dst_airport_id` INT NOT NULL,
	`src_country_id` INT NOT NULL,
	`dst_country_id` INT NOT NULL,
	`depart` DATETIME NOT NULL,
	`arrive` DATETIME NOT NULL,
	`aircraft_id` INT NOT NULL,
	CONSTRAINT fk_flight_airline_id FOREIGN KEY (airline_id) REFERENCES airline(id),
	CONSTRAINT fk_flight_src_airport_id FOREIGN KEY (src_airport_id) REFERENCES airport(id),
	CONSTRAINT fk_flight_dst_airport_id FOREIGN KEY (dst_airport_id) REFERENCES airport(id),
	CONSTRAINT fk_flight_src_country_id FOREIGN KEY (src_country_id) REFERENCES country(id),
	CONSTRAINT fk_flight_dst_country_id FOREIGN KEY (dst_country_id) REFERENCES country(id),
	CONSTRAINT fk_aircraft_id FOREIGN KEY (aircraft_id) REFERENCES aircraft(id)
);

CREATE TABLE IF NOT EXISTS `bookings`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`seat_id` INT,
	`booking_date` DATETIME NOT NULL,
	`guest_id` INT,
	`user_id` INT,
	CONSTRAINT fk_booking_user_id FOREIGN KEY (user_id) REFERENCES r_user(id)
);

CREATE TABLE IF NOT EXISTS `users`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`email` VARCHAR(50) NOT NULL UNIQUE,
	`pass` CHAR(64) NOT NULL,
	`title` VARCHAR(4) DEFAULT NULL,
	`first_name` CHAR(30) NOT NULL,
	`last_name` CHAR(30) DEFAULT '',
	`phone` VARCHAR(50) DEFAULT NULL,
	`dob` DATE NOT NULL,
	/*
	`country_id` INT NOT NULL,
	`state_id` INT NOT NULL,
	CONSTRAINT fk_users_country_id FOREIGN KEY (country_id) REFERENCES country(id),
	CONSTRAINT fk_users_state_id FOREIGN KEY (state_id) REFERENCES state(id)
	*/
);

CREATE TABLE IF NOT EXISTS `seats`(
	`id` INT AUTO_INCREMENT PRIMARY KEY ,
	`flt_id` INT NOT NULL,
	`seat_num` CHAR(3) NOT NULL,
	`available` INT NOT NULL,
	`price` INT NOT NULL,
	`class` VARCHAR(20) NOT NULL,
	CONSTRAINT fk_seat_airline_id_flt_id FOREIGN KEY (flt_id) REFERENCES flight(id)
);

insert into user(0, admin@airline.com, admin, NULL, NULL, '2000-01-01')