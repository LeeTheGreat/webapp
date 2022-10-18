DROP procedure if exists sp_create_seats;
delimiter //
CREATE PROCEDURE sp_create_seats (IN flt_id INT, IN aircraft_id INT)
BEGIN
	DECLARE k INT DEFAULT 0;
	DECLARE seat_num CHAR(3);
	DECLARE num INT;
	DECLARE totalseat INT DEFAULT 0;
	SELECT total_seat FROM aircrafts WHERE id = aircraft_id INTO totalseat;
	WHILE k < totalseat DO			
		IF(k < totalseat/4) THEN
			SET seat_num = CONCAT('A', LPAD(k+1,2,0));
			INSERT INTO seats VALUES(NULL,flt_id,seat_num,true);
		ELSEIF(k < totalseat/4 * 2) THEN
			SET num = k+1 - totalseat/4;
			SET seat_num = CONCAT('B', LPAD(num,2,0));
			INSERT INTO seats VALUES(NULL,flt_id,seat_num,true);
		ELSEIF(k < totalseat/4 * 3) THEN
			SET num = k+1 - totalseat/4 * 2;
			SET seat_num = CONCAT('C', LPAD(num,2,0));
			INSERT INTO seats VALUES(NULL,flt_id,seat_num,true);
		ELSEIF(k < totalseat/4 * 4) THEN
			SET num = k+1 - totalseat/4 * 3;
			SET seat_num = CONCAT('D', LPAD(num,2,0));
			INSERT INTO seats VALUES(NULL,flt_id,seat_num,true);
		END IF;
		SET k = k + 1;
	END WHILE;
END//
delimiter ;

drop procedure if exists sp_flights_insert;
delimiter //
CREATE PROCEDURE sp_flights_insert (IN flt_num CHAR(4), IN airline_id INT, IN ac_id INT, IN src_ap_code VARCHAR(4), IN dst_ap_code VARCHAR(4), IN dpt DATETIME, IN arr DATETIME, IN price INT, IN status VARCHAR(20))
BEGIN
	INSERT INTO flights VALUES(NULL,flt_num,airline_id,ac_id,src_ap_code,dst_ap_code,dpt,arr,price,status);
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
	IF user_id IS NULL THEN
		INSERT INTO customers VALUES (NULL,NULL,cust_email,fn,ln,gender,dob);
	ELSEIF user_id IS NOT NULL THEN
		INSERT INTO customers VALUES (NULL,user_id,NULL,NULL,NULL,NULL,NULL);
	END IF;
	INSERT INTO bookings VALUES(NULL, flt_id, LAST_INSERT_ID(), seat_id, NOW(), 'active', ref_num);
	COMMIT;
END//
delimiter ;

/*
drop procedure if exists sp_select_flights_direct;
delimiter //
CREATE procedure sp_select_flights_direct (IN dpt DATETIME, IN arr DATETIME, IN src_ap_code CHAR(3), IN dst_ap_code CHAR(3), IN pax INT)
BEGIN
	SELECT * FROM view_flights_informative WHERE depart >= dpt AND arrive <= arr AND src_airport_code = src_ap_code AND dst_airport_code = dst_ap_code AND total_seat_available >= pax;	
END//
delimiter ;
*/

drop procedure if exists sp_select_flights_recurse;
delimiter //
CREATE procedure sp_select_flights_recurse (IN dpt DATETIME, IN arr DATETIME, IN src_ap_code CHAR(3), IN dst_ap_code CHAR(3), IN pax INT)
BEGIN
	WITH RECURSIVE base AS
	(
		SELECT cast(dst_airport_code as char(100)) as ap_path, cast(flt_id as char(100)) as id_path, dst_airport_code, src_airport_code as src, depart, arrive, cast(concat(depart,',',arrive) as char(200)) as dpt_arv, 1 as hops, hours as total_flt_hours, TIMESTAMPDIFF(HOUR,depart,depart) as total_wait_hours
		FROM view_flights_informative WHERE src_airport_code = src_ap_code AND depart >= dpt AND flt_status = 'active'
		
		UNION ALL 
		
		SELECT cast(concat(ap_path,'-',f.dst_airport_code) as char(100)), cast(concat(id_path,'-',f.flt_id) as char(100)), f.dst_airport_code, b.src, f.depart, f.arrive, cast(concat(b.dpt_arv,'@',f.depart,',',f.arrive) as char(200)), b.hops+1, b.total_flt_hours+f.hours, TIMESTAMPDIFF(HOUR,b.arrive,f.depart)+b.total_wait_hours
		FROM view_flights_informative f
		JOIN base b ON b.dst_airport_code = f.src_airport_code 
		AND b.ap_path NOT LIKE concat('%',f.dst_airport_code,'%') /* prevent recursion from having cycle with multi hops. E.g., SIN > PER > HND > PER > ... */
		AND b.arrive < f.depart /* incoming flight must arrive before next flight */
		AND f.arrive <= arr
		AND f.dst_airport_code <> b.src /* prevent recursion from having cycle back to the src. E.g., SIN > HND > SIN */
		AND total_seat_available >= pax
		/*ORDER BY depart ASC*//* doesn't yet support 'ORDER BY over UNION in recursive Common Table Expression' */
		AND b.dst_airport_code <> dst_ap_code /* if reach destination, then stop. Otherwise, continue to recurse until end */	
		AND f.flt_status = 'active'
	)
	SELECT * FROM base WHERE dst_airport_code = dst_ap_code;
END//
delimiter ;

drop procedure if exists sp_select_booking_by_ref_and_email;
delimiter //
CREATE procedure sp_select_booking_by_ref_and_email (IN in_refnum CHAR(8), IN in_email VARCHAR(50))
BEGIN
	/* get booking if the ref_num exists, and for all the bookings with ref_num, there's a customer with the specified email */
	SELECT * FROM view_bookings_informative vbi1
		WHERE vbi1.cust_id IN (SELECT cust_id FROM view_bookings WHERE ref_num = in_refnum)
		AND EXISTS(SELECT 1 FROM view_bookings_informative vbi2 WHERE vbi2.email = in_email);
END//
delimiter ;

drop procedure if exists sp_update_flights;
delimiter //
CREATE procedure sp_update_flights (IN flt_id INT, IN flt_num CHAR(4), IN airline_id INT, IN ac_id INT, IN src_ap_code VARCHAR(4), IN dst_ap_code VARCHAR(4), IN dpt DATETIME, IN arr DATETIME, IN price INT, IN status VARCHAR(20))
BEGIN
	UPDATE flights f SET f.flt_num=flt_num, f.airline_id=airline_id, aircraft_id=ac_id, src_airport_code=src_ap_code,dst_airport_code=dst_ap_code,depart=dpt,arrive=arr,f.price=price,f.status=status WHERE id=flt_id;
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