create user if not exists 'airline_admin'@'localhost' identified by 'password';
create database if not exists airline;
grant all privileges on airline.* to 'airline_admin'@'localhost' WITH GRANT OPTION;

use airline;
source aircraft.sql;
source airline.sql;
source country_reduced.sql;
source airport_reduced.sql;

CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int unsigned NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
);

CREATE TABLE IF NOT EXISTS `flights`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_num` VARCHAR(4) NOT NULL
	,`aircraft_id` INT NOT NULL	
	,`src_airport_code` VARCHAR(4) NOT NULL
	,`dst_airport_code` VARCHAR(4) NOT NULL
	,`depart` DATETIME NOT NULL
	,`arrive` DATETIME NOT NULL
	,`price` INT NOT NULL
	,`status` ENUM('active','cancelled','rescheduled') NOT NULL
	,CONSTRAINT fk_flight_src_airport_code FOREIGN KEY (src_airport_code) REFERENCES airports(iata_code)
	,CONSTRAINT fk_flight_dst_airport_code FOREIGN KEY (dst_airport_code) REFERENCES airports(iata_code)
	,CONSTRAINT fk_aircraft_id FOREIGN KEY (aircraft_id) REFERENCES aircrafts(id)
	,CONSTRAINT chk_flights_price CHECK (price >= 0)
	,CONSTRAINT chk_flights_arrive_gt_depart CHECK (arrive > depart)
	,CONSTRAINT chk_flights_src_aiport_ne_dst_airport CHECK (src_airport_code <> dst_airport_code)
	-- no duplicate flights with same flt_num, src_airport, dst_airport, depart, arrive
	,UNIQUE KEY uk_flight (flt_num, src_airport_code, dst_airport_code, depart, arrive)
	,INDEX idx_flight_uk (flt_num, src_airport_code, dst_airport_code, depart, arrive)
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
	,`cust_email` VARCHAR(50)
	,`fname` CHAR(30)
	,`lname` CHAR(30) DEFAULT ''
	,`gender` ENUM('M','F')
	,`dob` DATE
	,CONSTRAINT fk_customers_user_id FOREIGN KEY (user_id) REFERENCES users(id)
	 -- if user_id is present, the other fields can be null as it's an existing user. If user_id is not present, we need to fill the other fields
	,CONSTRAINT chk_cust_detail CHECK (user_id IS NOT NULL or (cust_email IS NOT NULL and fname IS NOT NULL and gender IS NOT NULL and dob IS NOT NULL))
);

CREATE TABLE IF NOT EXISTS `seats`(
	`id` INT AUTO_INCREMENT PRIMARY KEY 
	,`flt_id` INT NOT NULL
	,`seat_num` CHAR(3) NOT NULL
	,`available` BOOLEAN NOT NULL
	,CONSTRAINT fk_seat_airline_id_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
	,CONSTRAINT UNIQUE KEY uk_seats_flt_id_seat_num (flt_id,seat_num)
	,INDEX idx_seats_flt_id_seat_id (flt_id,id)
);

/* ref_num is to for cases where a person book for multiple passengers */
CREATE TABLE IF NOT EXISTS `bookings`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_id` INT NOT NULL
	,`cust_id` INT NOT NULL
	,`seat_id` INT NOT NULL
	,`purchase_datetime` DATETIME NOT NULL
	,`status` ENUM('active','cust_cancelled','flt_cancelled') NOT NULL /* need to differentiate between customer action or non-customer action. Removed cust_rescheduled because it serves no purpose, and will complicate triggers */
	,`ref_num` VARCHAR(8) NOT NULL
	,CONSTRAINT fk_booking_cust_id FOREIGN KEY (cust_id) REFERENCES customers(id)
	,CONSTRAINT fk_booking_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
	,CONSTRAINT fk_booking_seat_id FOREIGN KEY (seat_id) REFERENCES seats(id)
	/* there cannot be two booking with same flt_id and seat_id. But what if cancelled, and then someone else book? Will have same flt_id and seat_id. Unable to ensure it via CONSTRAINT
	   CONSTRAINT must be (flt_id,seat_id,"active")
	,CONSTRAINT UNIQUE KEY uk_bookings_flt_id_seat_id (flt_id,seat_id,'active') 
	,INDEX idx_bookings_flt_id_seat_id (flt_id,seat_id)
	*/
	,CONSTRAINT fk_booking_flt_id_seat_id FOREIGN KEY (flt_id,seat_id) REFERENCES seats(flt_id,id) /*to prevent cases where bookings.flt_id = X but seat_id has flt_id = Y*/
);

CREATE TABLE IF NOT EXISTS `admins`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`username` VARCHAR(20) NOT NULL UNIQUE
	,`password` VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS `flights_hist`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_id` INT NOT NULL
	,`old_data` VARCHAR(100) NOT NULL
	,CONSTRAINT fk_flights_hist_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
);

show tables;
source views.sql
source trigger.sql
source stored_procedures.sql
source mock_users.sql;
source mock_customers_not_users_multi_pax.sql;
source mock_customers_not_users_single_pax.sql;
source mock_customers_users_multi_pax.sql;
source mock_customers_users_single_pax.sql;
source mock_flights.sql;
