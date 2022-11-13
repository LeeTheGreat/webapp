drop procedure if exists sp_flights_insert;
delimiter //
CREATE PROCEDURE sp_flights_insert (IN flt_num CHAR(4), IN ac_id INT, IN src_ap_code VARCHAR(4), IN dst_ap_code VARCHAR(4), IN dpt DATETIME, IN arr DATETIME, IN price INT, IN status VARCHAR(20))
BEGIN
	INSERT INTO flights VALUES(NULL,flt_num,ac_id,src_ap_code,dst_ap_code,REPLACE(dpt,'/','-'),REPLACE(arr,'/','-'),price,status);
END//
delimiter ;

drop procedure if exists sp_ins_user;
delimiter //
CREATE procedure sp_ins_user(IN email VARCHAR(50), IN password CHAR(60), IN fn VARCHAR(30), IN ln VARCHAR(30), IN gender CHAR(1), IN dob DATE)
BEGIN
	-- previously a customer, then created an account. Due to unique email constraint, we can't add another account of the email. So, we update the existing entry
	IF (EXISTS(SELECT * FROM users u WHERE u.email = TRIM(email) AND u.password IS NULL AND role = 'user')) THEN 
		UPDATE users u SET u.password = password, u.fname = fn, u.lname = ln, u.gender = gender, u.dob = dob WHERE u.email = email AND role = 'user';
	-- new user signing up
	ELSE
		INSERT INTO users VALUES (NULL,TRIM(email),password,fn,ln,gender,REPLACE(dob,'/','-'),'user');
	END IF;
END//
delimiter ;

drop procedure if exists sp_ins_admin;
delimiter //
CREATE procedure sp_ins_admin(IN username VARCHAR(50), IN password CHAR(60), IN fn VARCHAR(30), IN ln VARCHAR(30), IN gender CHAR(1), IN dob DATE)
BEGIN
	INSERT INTO users VALUES (NULL,TRIM(username),password,fn,ln,gender,REPLACE(dob,'/','-'),'admin');
END//
delimiter ;

drop procedure if exists sp_ins_user_and_booking;
delimiter //
CREATE PROCEDURE sp_ins_user_and_booking (IN email VARCHAR(50), IN fn VARCHAR(30), IN ln VARCHAR(30), IN gender CHAR(1), IN dob DATE, IN flt_id INT, IN seat_num CHAR(3), IN ref_num CHAR(8))
BEGIN
	DECLARE cust_id INT DEFAULT -1;
	DECLARE ref_num_uuid CHAR(8) DEFAULT (SELECT UPPER(SUBSTRING(UUID(),1,8)));
	DECLARE ref_num_count INT DEFAULT 0;
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

	-- if ref_num is not empty, use it
	IF (TRIM(ref_num) <> '') THEN
		SET ref_num_uuid = ref_num;
	END IF;
	
	-- if ref_num is empty, then generate a new one
	IF (TRIM(ref_num) = '') THEN
		WHILE (SELECT COUNT(id) FROM bookings WHERE ref_num = ref_num_uuid) > 0 DO
			-- check if ref_num exists. If yes, regenerate new one. Else ok		
			SET ref_num_uuid = (SELECT UPPER(SUBSTRING(UUID(),1,8)));
		END WHILE;
	END IF;
	
	-- check if customer exists by email. If exists, then just need to insert booking
	SET cust_id = (SELECT id FROM users c WHERE c.email = email AND role = 'user');
	IF cust_id > -1 THEN
		INSERT INTO bookings VALUES(NULL, flt_id, cust_id, seat_num, NOW(), 'active', ref_num_uuid);
	ELSE
		-- need a TRANSACTION here as the whole process involves adding customers, then adding bookings. If any step went wrong, need to roll back
		START TRANSACTION;
		INSERT INTO users VALUES (NULL,TRIM(email),NULL,fn,ln,gender,REPLACE(dob,'/','-'),'user');
		INSERT INTO bookings VALUES(NULL, flt_id, LAST_INSERT_ID(), seat_num, NOW(), 'active', ref_num_uuid);
		COMMIT;
	END IF;
	SELECT ref_num_uuid;
END//
delimiter ;

drop procedure if exists sp_select_flights_recurse;
delimiter //
CREATE procedure sp_select_flights_recurse (IN dpt DATETIME, IN arr DATETIME, IN src_ap_code CHAR(3), IN dst_ap_code CHAR(3), IN pax INT)
BEGIN
	WITH RECURSIVE base AS
	(
		SELECT src_airport_code, cast(concat(src_airport_code,'||',dst_airport_code) as char(100)) as path_ap_code, cast(concat(src_airport_name,'||',dst_airport_name) as char(1000)) as path_ap_name, cast(flt_id as char(100)) as path_flt_id, dst_airport_code, arrive, cast(concat(depart,',',arrive) as char(200)) as dpt_arv, 0 as hops, hours as total_flt_hours, TIMESTAMPDIFF(HOUR,depart,depart) as total_wait_hours, price
		FROM view_flights_join WHERE src_airport_code = src_ap_code AND DATE(depart) = DATE(dpt) AND flt_status = 'active'
		
		UNION ALL 
		
		SELECT b.src_airport_code, cast(concat(path_ap_code,'||',f.dst_airport_code) as char(100)), cast(concat(b.path_ap_name,'||',f.dst_airport_name) as char(1000)), cast(concat(path_flt_id,'||',f.flt_id) as char(100)), f.dst_airport_code, f.arrive, cast(concat(b.dpt_arv,'||',f.depart,',',f.arrive) as char(200)), b.hops+1, b.total_flt_hours+f.hours, TIMESTAMPDIFF(HOUR,b.arrive,f.depart)+b.total_wait_hours, b.price+f.price
		FROM view_flights_join f
		JOIN base b ON b.dst_airport_code = f.src_airport_code
		AND b.path_ap_code NOT LIKE concat('%',f.dst_airport_code,'%') /* prevent recursion from having cycle with multi hops. E.g., SIN > PER > HND > PER > ... */
		AND b.arrive < f.depart /* incoming flight must arrive before next flight */
		AND f.arrive <= arr
		AND f.dst_airport_code <> b.src_airport_code /* prevent recursion from having cycle back to the src. E.g., SIN > HND > SIN */
		AND total_seat_available >= pax
		/*ORDER BY depart ASC*//* doesn't yet support 'ORDER BY over UNION in recursive Common Table Expression' */
		AND b.dst_airport_code <> dst_ap_code /* if reach destination, then stop. Otherwise, continue to recurse until no more connecting flights */	
		AND f.flt_status = 'active'
	)
	-- finally, select the wanted results from the entire recused query
	SELECT * FROM base WHERE dst_airport_code = dst_ap_code AND DATE(arrive) < DATE(arr) ORDER BY hops ASC, dpt_arv ASC, total_wait_hours ASC;
END//
delimiter ;

drop procedure if exists sp_verify_refnum_email;
delimiter //
CREATE procedure sp_verify_refnum_email (IN in_refnum CHAR(8), IN in_email VARCHAR(50))
BEGIN
	SELECT ref_num FROM view_bookings_join WHERE ref_num = TRIM(in_refnum) AND email = TRIM(in_email) LIMIT 1;
END//
delimiter ;

drop procedure if exists sp_update_flights;
delimiter //
CREATE procedure sp_update_flights (IN flt_id INT, IN flt_num CHAR(4), IN ac_id INT, IN src_ap_code VARCHAR(4), IN dst_ap_code VARCHAR(4), IN dpt DATETIME, IN arr DATETIME, IN price INT, IN status VARCHAR(20))
BEGIN
	UPDATE flights f SET f.flt_num=flt_num, aircraft_id=ac_id, src_airport_code=src_ap_code,dst_airport_code=dst_ap_code,depart=dpt,arrive=arr,f.price=price,f.status=status WHERE id=flt_id;
END//
delimiter ;