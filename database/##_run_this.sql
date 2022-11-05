create user if not exists 'airline_admin'@'localhost' identified by 'password';
drop database airline;
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
	,CONSTRAINT uk_flight UNIQUE (flt_num, src_airport_code, dst_airport_code, depart, arrive)
	,INDEX idx_flight_uk (flt_num, src_airport_code, dst_airport_code, depart, arrive)
);

CREATE TABLE IF NOT EXISTS `users`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`email` VARCHAR(50)
	,`password` BINARY(60)
	,`fname` CHAR(30) NOT NULL
	,`lname` CHAR(30)
	,`gender` ENUM('M','F')
	,`dob` DATE
	,`role` VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS `seats`(
	`flt_id` INT NOT NULL
	,`seat_num` CHAR(3) NOT NULL
	,`available` BOOLEAN NOT NULL
	,PRIMARY KEY (flt_id,seat_num)
	,CONSTRAINT fk_seat_airline_id_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
	-- ,INDEX idx_seats_flt_id_seat_id (flt_id,id)
);


CREATE TABLE IF NOT EXISTS `bookings`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_id` INT NOT NULL
	,`user_id` INT NOT NULL
	,`seat_num` CHAR(3) NOT NULL
	,`purchase_datetime` DATETIME NOT NULL
	,`status` ENUM('active','inactive') NOT NULL
	-- ref_num is for cases where a person book for multiple passengers
	,`ref_num` VARCHAR(8) NOT NULL
	,CONSTRAINT fk_booking_user_id FOREIGN KEY (user_id) REFERENCES users(id)
	,CONSTRAINT fk_booking_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
	-- to prevent cases where bookings.flt_id = X but seat_id has flt_id = Y
	,CONSTRAINT fk_booking_flt_id_seat_num FOREIGN KEY (flt_id,seat_num) REFERENCES seats(flt_id,seat_num)
	-- cannot have two flights with same flt_id having same seat_num
	,CONSTRAINT uk_flt_id_seat_num UNIQUE (flt_id,seat_num)
);

/*
CREATE TABLE IF NOT EXISTS `admins`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`username` VARCHAR(20) NOT NULL UNIQUE
	,`password` VARCHAR(50) NOT NULL
);
*/
/*
CREATE TABLE IF NOT EXISTS `flights_hist`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_id` INT NOT NULL
	,`old_data` VARCHAR(100) NOT NULL
	,CONSTRAINT fk_flights_hist_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
);
*/

show tables;
source views.sql
source trigger.sql
source stored_procedures.sql
-- source mock_users.sql;
source mock_customers_not_users_multi_pax.sql;
source mock_customers_not_users_single_pax.sql;
-- source mock_customers_users_multi_pax.sql;
-- source mock_customers_users_single_pax.sql;
source mock_flights.sql;
source mock_bookings.sql