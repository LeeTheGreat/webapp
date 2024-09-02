drop trigger if exists ins_flights_after;
delimiter //
CREATE TRIGGER ins_flights_after AFTER INSERT ON flights
FOR EACH ROW
BEGIN
    -- CALL sp_create_seats(NEW.id, NEW.aircraft_id);
    DECLARE k INT DEFAULT 0;
	DECLARE seat_num CHAR(3);
	DECLARE num INT;
	DECLARE totalseat INT DEFAULT 0;
	SELECT total_seat FROM aircrafts WHERE id = NEW.aircraft_id INTO totalseat;
	WHILE k < totalseat DO			
		IF(k < totalseat/4) THEN
			SET seat_num = CONCAT('A', LPAD(k+1,2,0));
			INSERT INTO seats VALUES(NEW.id,seat_num,true);
		ELSEIF(k < totalseat/4 * 2) THEN
			SET num = k+1 - totalseat/4;
			SET seat_num = CONCAT('B', LPAD(num,2,0));
			INSERT INTO seats VALUES(NEW.id,seat_num,true);
		ELSEIF(k < totalseat/4 * 3) THEN
			SET num = k+1 - totalseat/4 * 2;
			SET seat_num = CONCAT('C', LPAD(num,2,0));
			INSERT INTO seats VALUES(NEW.id,seat_num,true);
		ELSEIF(k < totalseat/4 * 4) THEN
			SET num = k+1 - totalseat/4 * 3;
			SET seat_num = CONCAT('D', LPAD(num,2,0));
			INSERT INTO seats VALUES(NEW.id,seat_num,true);
		END IF;
		SET k = k + 1;
	END WHILE;
END//
delimiter ;

drop trigger if exists upd_flights_after;
delimiter //
CREATE TRIGGER upd_flights_after AFTER UPDATE ON flights
FOR EACH ROW
BEGIN
    -- set all bookings to inactive if flight is cancelled
    IF NEW.status = "cancelled" THEN
        UPDATE bookings SET bookings.status = "inactive" WHERE flt_id = NEW.id;

    -- set all bookings to active if flight is active or rescheduled
    ELSEIF NEW.status = "active" OR NEW.status = "rescheduled" THEN    
        UPDATE bookings SET bookings.status = "active" WHERE flt_id = NEW.id;
    END IF;

    -- INSERT INTO flights_hist VALUES (NULL, NEW.id, CONCAT_WS(';',OLD.flt_num,OLD.aircraft_id,OLD.src_airport_code,OLD.dst_airport_code,OLD.depart,OLD.arrive,OLD.price,OLD.status));
END//
delimiter ;

drop trigger if exists ins_bookings_before;
delimiter //
CREATE TRIGGER ins_bookings_before BEFORE INSERT ON bookings
FOR EACH ROW
BEGIN

    -- check if an inactive booking is being inserted 
    IF NEW.status = 'inactive' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Bookings INSERT. Inserting a booking with non-active status';
    END IF;

    -- check if there's insertion of booking where flight is not active
    -- also triggers if flt_id not exists in flights table
    IF NEW.status = 'active' AND NOT EXISTS (SELECT status FROM flights WHERE id = NEW.flt_id AND status = 'active') THEN
        SET @error_msg = CONCAT('Invalid Bookings INSERT. Booking id ', NEW.id, ' is active, but no active flight for flt_id ', NEW.flt_id);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;
    
END//
delimiter ;

drop trigger if exists ins_bookings_after;
delimiter //
CREATE TRIGGER ins_bookings_after AFTER INSERT ON bookings
FOR EACH ROW
BEGIN
    UPDATE seats SET seats.available = false WHERE seats.flt_id = NEW.flt_id and seat_num = NEW.seat_num;
END//
delimiter ;

drop trigger if exists upd_bookings_before;
delimiter //
CREATE TRIGGER upd_bookings_before BEFORE UPDATE ON bookings FOR EACH ROW
BEGIN
    -- ensure that not active bookings cannot be updated
    IF OLD.status <> 'active' THEN
        SET @error_msg = CONCAT('Invalid Bookings UPDATE. Booking id ', old.id, ' to be updated, but status is inactive');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;
 
    -- ensure that a booking to be set as not active won't have fields other than status being modified
    IF NEW.status <> 'active' AND (NEW.id,NEW.flt_id,NEW.user_id,NEW.seat_num,NEW.purchase_datetime,NEW.ref_num) <> (OLD.id,OLD.flt_id,OLD.user_id,OLD.seat_num,OLD.purchase_datetime,OLD.ref_num) THEN
        SET @error_msg = CONCAT('Invalid Bookings UPDATE. Booking id ', NEW.id, ' to be updated as not active, but other fields except status were modified');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;
   
    -- ensure a booking cannot be updated to be active when the flight is not active
    IF NEW.status = 'active' AND NOT EXISTS (SELECT status FROM flights WHERE id = NEW.flt_id AND status = 'active') THEN
        SET @error_msg = CONCAT('Invalid Bookings UPDATE. Booking id ', NEW.id, ' to be updated as active, but flt_id ', NEW.flt_id, ' status is not active');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;
END//
delimiter ;


drop trigger if exists upd_bookings_after;
delimiter //
CREATE TRIGGER upd_bookings_after AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    IF(OLD.seat_num <> NEW.seat_num) THEN
        UPDATE seats SET available = true WHERE seat_num = OLD.seat_num AND flt_id = OLD.flt_id;
        UPDATE seats SET available = false WHERE seat_num = NEW.seat_num AND flt_id = OLD.flt_id;
    END IF;
END//
delimiter ;


drop trigger if exists del_bookings_before;
delimiter //
CREATE TRIGGER del_bookings_before BEFORE DELETE ON bookings
FOR EACH ROW
BEGIN
    UPDATE seats SET available = true WHERE seat_num = OLD.seat_num AND flt_id = OLD.flt_id;
END//
delimiter ;

