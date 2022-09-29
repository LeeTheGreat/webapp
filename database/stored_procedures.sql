delimiter //
CREATE PROCEDURE sp_airport_exist_in_country (IN airport_code VARCHAR(4), IN country_code CHAR(2), OUT result BOOLEAN)
BEGIN
	SELECT EXISTS(SELECT id FROM airports WHERE iata_code = airport_code and id IN (SELECT a.id FROM countries c JOIN airports a ON a.country_iso2 = c.iso2 AND c.iso2 = country_code)) INTO result;
END//
delimiter ;

DROP procedure sp_create_seats;
delimiter //
CREATE PROCEDURE sp_create_seats (IN flt_id INT, IN msg VARCHAR(100))
BEGIN
	DECLARE k INT DEFAULT 0;
	DECLARE seat_num CHAR(3);
	DECLARE num INT;
	DECLARE totalseat INT DEFAULT 0;
	SELECT total_seat FROM aircrafts, flights WHERE aircraft_id = aircrafts.id AND flights.id = flt_id INTO totalseat;
	WHILE k < totalseat DO			
		IF(k < totalseat/4) THEN
			SET seat_num = CONCAT('A', LPAD(k+1,2,0));
			INSERT IGNORE INTO seats VALUES(NULL,flt_id,seat_num,true);
		ELSEIF(k < totalseat/4 * 2) THEN
			SET num = k+1 - totalseat/4;
			SET seat_num = CONCAT('B', LPAD(num,2,0));select k,seat_num;
			INSERT IGNORE INTO seats VALUES(NULL,flt_id,seat_num,true);
		ELSEIF(k < totalseat/4 * 3) THEN
			SET num = k+1 - totalseat/4 * 2;
			SET seat_num = CONCAT('C', LPAD(num,2,0));
			INSERT IGNORE INTO seats VALUES(NULL,flt_id,seat_num,true);
		ELSEIF(k < totalseat/4 * 4) THEN
			SET num = k+1 - totalseat/4 * 3;
			SET seat_num = CONCAT('D', LPAD(num,2,0));
			INSERT IGNORE INTO seats VALUES(NULL,flt_id,seat_num,true);
		END IF;
		SET k = k + 1;
	END WHILE;
END//
delimiter ;

drop procedure sp_flights_insert;
delimiter //
CREATE PROCEDURE sp_flights_insert (IN flt_num INT, IN airline_id INT, IN ac_id INT, IN src_ap_code VARCHAR(4), IN dst_ap_code VARCHAR(4), IN src_cy_code CHAR(2), IN dst_cy_code CHAR(2), IN dpt DATETIME, IN arr DATETIME, IN price INT, IN status VARCHAR(20))
BEGIN
	DECLARE src_exists BOOLEAN DEFAULT false;
	DECLARE dst_exists BOOLEAN DEFAULT false;

	/* add code to check for dpt and arr date > today() */
	CALL sp_airport_exist_in_country(src_ap_code,src_cy_code,src_exists);
	CALL sp_airport_exist_in_country(dst_ap_code,dst_cy_code,dst_exists);
	/*START TRANSACTION;*/
	IF(dst_exists AND src_exists) THEN
		INSERT INTO flights VALUES(NULL,flt_num,airline_id,ac_id,src_ap_code,dst_ap_code,src_cy_code,dst_cy_code,dpt,arr,price,status);
		CALL sp_create_seats(LAST_INSERT_ID(), msg);
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Src or Dst Airport not in Country";
	END IF;
	/*
	GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SET msg = CONCAT(@p1,': ', @p2);
	*/
	/*
	IF(msg = '') THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
	*/
END//
delimiter ;

CREATE TABLE IF NOT EXISTS `bookings`(
	`id` INT AUTO_INCREMENT PRIMARY KEY
	,`flt_id` INT NOT NULL
	,`cust_id` INT NOT NULL
	,`seat_id` INT NOT NULL
	,`purchase_datetime` DATETIME NOT NULL
	,`status` ENUM('active','cancelled','rescheduled') NOT NULL
	,`ref_num` CHAR(10) NOT NULL

drop procedure sp_ins_customer;
delimiter //
CREATE PROCEDURE sp_ins_customer (IN user_id INT, IN cust_email VARCHAR(50), IN fn VARCHAR(30), IN ln VARCHAR(30), IN gender CHAR(1), IN dob DATE, OUT last_insert_id INT)
BEGIN
	IF(user_id IS NULL) THEN
		INSERT INTO customers VALUES (NULL,NULL,cust_email,fn,ln,gender,dob);
	ELSE
		INSERT INTO customers VALUES (NULL,user_id,NULL,NULL,NULL,NULL,NULL);
	END IF;
	SET last_insert_id = LAST_INSERT_ID();

END//
delimiter ;

drop procedure sp_ins_customer_and_booking;
delimiter //
CREATE PROCEDURE sp_ins_customer_and_booking (IN user_id INT, IN cust_email VARCHAR(50), IN fn VARCHAR(30), IN ln VARCHAR(30), IN gender CHAR(1), IN dob DATE, IN flt_id INT, IN seat_id INT)
BEGIN
	IF(user_id IS NULL) THEN
		INSERT INTO customers VALUES (NULL,NULL,cust_email,fn,ln,gender,dob);
	ELSE
		INSERT INTO customers VALUES (NULL,user_id,NULL,NULL,NULL,NULL,NULL);
	END IF;
	INSERT INTO bookings VALUES(NULL, flt_id, LAST_INSERT_ID(), seat_id, NOW(), 'active', (SELECT LEFT(UUID(), 10)));
	
END//
delimiter ;
