delimiter //
CREATE PROCEDURE sp_airport_exist_in_country(IN airport_code VARCHAR(4), IN country_code CHAR(2), OUT result BOOLEAN)
BEGIN
	SELECT EXISTS(SELECT id FROM airports WHERE iata_code = airport_code and id IN (SELECT a.id FROM countries c JOIN airports a ON a.country_iso2 = c.iso2 AND c.iso2 = country_code)) INTO result;
END//
delimiter ;

DROP procedure sp_create_seats;
delimiter //
CREATE PROCEDURE sp_create_seats(IN flt_id INT, IN msg VARCHAR(100))
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
CREATE PROCEDURE sp_flights_insert(IN flt_num INT, IN airline_id INT, IN ac_id INT, IN src_ap_code VARCHAR(4), IN dst_ap_code VARCHAR(4), IN src_cy_code CHAR(2), IN dst_cy_code CHAR(2), IN dpt DATETIME, IN arr DATETIME, IN price INT, IN status VARCHAR(20), OUT ret BOOLEAN, OUT msg VARCHAR(100))
BEGIN
	DECLARE src_exists BOOLEAN DEFAULT false;
	DECLARE dst_exists BOOLEAN DEFAULT false;
	SET ret = false;

	/* add code to check for dpt and arr date > today() */
	CALL sp_airport_exist_in_country(src_ap_code,src_cy_code,src_exists);
	CALL sp_airport_exist_in_country(dst_ap_code,dst_cy_code,dst_exists);
	/*START TRANSACTION;*/
	IF(dst_exists AND src_exists) THEN
		INSERT INTO flights VALUES(NULL,flt_num,airline_id,ac_id,src_ap_code,dst_ap_code,src_cy_code,dst_cy_code,dpt,arr,price,status);
		CALL sp_create_seats(LAST_INSERT_ID(), msg);
	ELSE
		SET msg = CONCAT("Src or Dst Airport not in Country");
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
	ENDIF;
	*/
END//
delimiter ;