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
		TODO: add check constraint on src_airport_id and dst_airport_id such that only airports in src_country and dst_country are allowed
		Based on stackoverflow, need to use User-Defined Function. https://stackoverflow.com/questions/3880698/can-a-check-constraint-relate-to-another-table

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
	,`cust_email` VARCHAR(50)
	,`fname` CHAR(30)
	,`lname` CHAR(30) DEFAULT ''
	,`gender` CHAR(1)
	,`dob` DATE
	/*
	`country_id` INT NOT NULL,
	`state_id` INT NOT NULL,
	CONSTRAINT fk_users_country_id FOREIGN KEY (country_id) REFERENCES country(id),
	CONSTRAINT fk_users_state_id FOREIGN KEY (state_id) REFERENCES state(id)
	*/
	,CONSTRAINT fk_customers_user_id FOREIGN KEY (user_id) REFERENCES users(id)
	 /* if user_id is present, the other fields can be null as it's an existing user. If user_id is not present, we need to fill it */
	,CONSTRAINT chk_existing_user CHECK (user_id IS NOT NULL or (cust_email IS NOT NULL and fname IS NOT NULL and gender IS NOT NULL and dob IS NOT NULL))
);

CREATE TABLE IF NOT EXISTS `seats`(
	`id` INT AUTO_INCREMENT PRIMARY KEY 
	,`flt_id` INT NOT NULL
	,`seat_num` CHAR(3) NOT NULL
	,`available` BOOLEAN NOT NULL
	,CONSTRAINT fk_seat_airline_id_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
	,CONSTRAINT UNIQUE KEY uk_seats_flt_id_seat_num (flt_id,seat_num)
	,INDEX idx_seats_flt_id_seat_num (flt_id,seat_num)
);

CREATE TABLE IF NOT EXISTS `bookings`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_id` INT NOT NULL
	,`cust_id` INT NOT NULL
	,`seat_id` INT NOT NULL
	,`datetime` DATETIME NOT NULL
	,`status` ENUM('active','cancelled','rescheduled')
	,CONSTRAINT fk_booking_cust_id FOREIGN KEY (cust_id) REFERENCES customers(id)
	,CONSTRAINT fk_booking_flt_id FOREIGN KEY (flt_id) REFERENCES flights(id)
	,CONSTRAINT fk_booking_seat_id FOREIGN KEY (seat_id) REFERENCES seats(id)
	,CONSTRAINT UNIQUE KEY uk_bookings_flt_id_seat_id (flt_id,seat_id)
	,INDEX idx_bookings_flt_id_seat_id (flt_id,seat_id)
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

insert into admins (username, password) values ('admin', 'password');
insert into users values (1, '1@1.com','1','1_fn','','F','1111-01-01'), (2, '2@2.com','2','2_fn','2_ln','F','2222-01-01'), (3, '3@3.com','3','3_fn','3_ln','F','3333-01-01');
insert into customers values (1,1,NULL,NULL,NULL,NULL,NULL), (2,2,NULL,NULL,NULL,NULL,NULL);
insert into customers values (3,NULL,'guest1@guest.com','guest1','','F','1111-01-01'), (4,NULL,'guest2@guest.com','guest2','','F','1111-01-02');
insert into flights values (1,'1111',1,1,1,1,14,14,'1111-11-11 11:11:11','1111-11-12 11:11:12', 1111, 'active');
insert into flights values (2,'1111',2,2,2,2,210,210,'1111-11-11 11:11:11','1111-11-12 11:11:12', 1111, 'active');
insert into seats values (NULL,1,'A01',true),(NULL,1,'A02',true),(NULL,1,'A03',true),(NULL,1,'B01',true),(NULL,1,'B02',true),(NULL,2,'A01',true),(NULL,2,'A02',true),(NULL,2,'A03',true),(NULL,2,'B01',true),(NULL,2,'B02',true)
insert into bookings values (1,1,3,1,'1111-11-11','active'),(2,2,4,1,'1111-11-11','active'),(3,1,2,2,'1111-11-11','active'),(4,2,1,2,'1111-11-11','active');
use airline;
show tables;

delimiter //
CREATE TRIGGER upd_flights_before BEFORE UPDATE ON flights
FOR EACH ROW
BEGIN
	IF NEW.status <> "active" THEN
		INSERT INTO flights_hist VALUES (NULL, NEW.id, CONCAT_WS(';',NEW.flt_num,NEW.airline_id,NEW.aircraft_id,NEW.src_airport_id,NEW.dst_airport_id,NEW.src_country_id,NEW.dst_country_id,NEW.depart,NEW.arrive,NEW.price,NEW.status));
	END IF;
END//
delimiter ;

delimiter //
CREATE TRIGGER upd_flights_after AFTER UPDATE ON flights
FOR EACH ROW
BEGIN
	IF NEW.status <> "active" THEN
		UPDATE bookings SET bookings.status = NEW.status WHERE bookings.flt_id = NEW.id;
END IF;
END//
delimiter ;

delimiter //

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


/* TODO: test */
delimiter //
CREATE PROCEDURE sp_dst_airport_exist_in_country(IN dst_airport_id INT, IN dst_country_id INT, OUT result BOOLEAN)
BEGIN
	SELECT EXISTS(SELECT id FROM airports WHERE id = dst_airport_id and id IN (SELECT id FROM airports WHERE country_iso2 = (SELECT iso2 FROM countries WHERE id = dst_country_id))) INTO result;
END//
delimiter ;

/* TODO: test */
delimiter //
CREATE PROCEDURE sp_src_airport_exist_in_country(IN src_airport_id INT, IN src_country_id INT, OUT result BOOLEAN)
BEGIN
	SELECT EXISTS(SELECT id FROM airports WHERE id = src_airport_id and id IN (SELECT id FROM airports WHERE country_iso2 = (SELECT iso2 FROM countries WHERE id = src_country_id))) INTO result;
END//
delimiter ;

/* TODO: test */
delimiter //
CREATE PROCEDURE sp_flights_insert(IN flt_num INT, IN airline_id INT, IN ac_id INT, IN src_ap_id INT, IN dst_ap_id INT, IN src_cy_id INT, IN dst_cy_id INT, IN dpt DATETIME, IN arr DATETIME, IN price INT, IN status VARCHAR(20), OUT ret BOOLEAN)
BEGIN
	CALL sp_dst_airport_exist_in_country(dst_ap_id,dst_cy_id,@dst_exist);
	CALL sp_src_airport_exist_in_country(dst_ap_id,dst_cy_id,@src_exists);
	IF(@dst_exist and @src_exists) THEN
		INSERT INTO fligts VALUES(NULL,flt_num,airline_id,ac_id,src_ap_id,dst_ap_id,src_cy_id,dst_cy_id,dpt,arr,price,status);
	END IF;
END//
delimiter ;