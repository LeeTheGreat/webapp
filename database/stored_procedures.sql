drop procedure if exists sp_airport_exist_in_country;
delimiter //
CREATE PROCEDURE sp_airport_exist_in_country (IN airport_code VARCHAR(4), IN country_code CHAR(2), OUT result BOOLEAN)
BEGIN
	SELECT EXISTS(SELECT id FROM airports WHERE iata_code = airport_code and id IN (SELECT a.id FROM countries c JOIN airports a ON a.country_iso2 = c.iso2 AND c.iso2 = country_code)) INTO result;
END//
delimiter ;

DROP procedure if exists sp_create_seats;
delimiter //
CREATE PROCEDURE sp_create_seats (IN flt_id INT)
BEGIN
	DECLARE k INT DEFAULT 0;
	DECLARE seat_num CHAR(3);
	DECLARE num INT;
	DECLARE totalseat INT DEFAULT 0;
	SELECT total_seat FROM aircrafts, flights WHERE aircraft_id = aircrafts.id AND flights.id = flt_id INTO totalseat;
	START TRANSACTION;
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
	COMMIT;
END//
delimiter ;

drop procedure if exists sp_flights_insert;
delimiter //
CREATE PROCEDURE sp_flights_insert (IN flt_num INT, IN airline_id INT, IN ac_id INT, IN src_ap_code VARCHAR(4), IN dst_ap_code VARCHAR(4), IN src_cy_code CHAR(2), IN dst_cy_code CHAR(2), IN dpt DATETIME, IN arr DATETIME, IN price INT, IN status VARCHAR(20))
BEGIN
	DECLARE src_exists BOOLEAN DEFAULT false;
	DECLARE dst_exists BOOLEAN DEFAULT false;

	/* add code to check for dpt and arr date > today() */
	CALL sp_airport_exist_in_country(src_ap_code,src_cy_code,src_exists);
	CALL sp_airport_exist_in_country(dst_ap_code,dst_cy_code,dst_exists);

	START TRANSACTION;
	IF(dst_exists AND src_exists) THEN
		INSERT INTO flights VALUES(NULL,flt_num,airline_id,ac_id,src_ap_code,dst_ap_code,src_cy_code,dst_cy_code,dpt,arr,price,status);
		CALL sp_create_seats(LAST_INSERT_ID());
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Src or Dst Airport not in Country";
	END IF;
	COMMIT;
END//
delimiter ;

drop procedure if exists sp_ins_customer_and_booking;
delimiter //
CREATE PROCEDURE sp_ins_customer_and_booking (IN user_id INT, IN cust_email VARCHAR(50), IN fn VARCHAR(30), IN ln VARCHAR(30), IN gender CHAR(1), IN dob DATE, IN flt_id INT, IN seat_id INT, IN ref_num CHAR(8))
BEGIN
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;

  DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
		ROLLBACK;
		RESIGNAL;
	END;

	START TRANSACTION; /* need a TRANSACTION here as the whole process involves adding customers, then adding bookings. If any step went wrong, need to roll back */
	IF(user_id IS NULL) THEN
		INSERT INTO customers VALUES (NULL,NULL,cust_email,fn,ln,gender,dob);
	ELSE
		INSERT INTO customers VALUES (NULL,user_id,NULL,NULL,NULL,NULL,NULL);
	END IF;
	INSERT INTO bookings VALUES(NULL, flt_id, LAST_INSERT_ID(), seat_id, NOW(), 'active', ref_num);
	COMMIT;
	
END//
delimiter ;

/* TODO: test this */
drop procedure if exists sp_select_flights_for_cust_flt_search;
delimiter //
CREATE procedure sp_select_flights_for_cust_flt_search (IN dpt DATETIME, IN arr DATETIME, IN fm_cy INT, IN to_cy INT, IN fm_ap INT, IN to_ap INT)
BEGIN
	SELECT id, flt_num as "Flt #", ct1.name as "From", ct2.name as "To", ct1.iso2 as "fc_iso2", ct2.iso2 as "tc_iso2", ap1.name as "From Airport", ap2.name as "To Airport", ap1.iata_code as "fa_iata", ap2.iata_code as "ta_iata", depart as Depart, arrive as Arrive, price as Price from flights as flt
			join airlines as al on al.id = airline_id 
			join airports as ap1 on ap1.iata_code = src_airport_code 
			join airports as ap2 on ap2.iata_code = dst_airport_code 
			join countries as ct1 on ct1.iso2 = src_country_code 
			join countries as ct2 on ct2.iso2 = dst_country_code 
			where Depart >= dpt and Arrive <= arr and src_country_code = fm_cy and dst_country_code = to_cy and src_airport_code = fm_ap and dst_airport_code = to_ap;
END//
delimiter ;

drop procedure if exists sp_select_booking_by_ref_and_email;
delimiter //
CREATE procedure sp_select_booking_by_ref_and_email (IN in_refnum CHAR(8), IN in_email VARCHAR(50))
BEGIN
	/* get booking if the ref_num exists, and for all the bookings with ref_num, there's a customer with the specified email */
	SELECT * FROM bookings
			JOIN flights as flts on flt_id = flts.id
			JOIN seats on seat_id = seats.id
			JOIN customers as custs on cust_id = custs.id
			WHERE cust_id IN (SELECT cust_id FROM bookings WHERE ref_num = in_refnum)
			AND EXISTS(SELECT * FROM bookings JOIN customers as custs2 on cust_id = custs2.id AND cust_email = in_email);
END//
delimiter ;

/*
delimiter //
CREATE procedure sp_select_airlines(IN id INT)
BEGIN
	SELECT * FROM airlines WHERE airlines.id = id;
END//
delimiter ;

delimiter //
CREATE procedure sp_select_airports(IN iata CHAR(3))
BEGIN
	SELECT * FROM airports WHERE iata_code = iata;
END//
delimiter ;

delimiter //
CREATE procedure sp_select_countries(IN code CHAR(2))
BEGIN
	SELECT * FROM countries WHERE iso2 = code;
END//
delimiter ;
*/