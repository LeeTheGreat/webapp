drop trigger if exists ins_flights_after;
delimiter //
CREATE TRIGGER ins_flights_after AFTER INSERT ON flights
FOR EACH ROW
BEGIN
    CALL sp_create_seats(NEW.id, NEW.aircraft_id);
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
    IF NEW.status = 'active' AND NOT EXISTS (SELECT status FROM flights WHERE id = NEW.flt_id AND status = 'active') THEN
        SET @error_msg = CONCAT('Invalid Bookings INSERT. Booking id ', NEW.id, ' is active, but flt_id ', NEW.flt_id, ' status is non-active');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;
    
END//
delimiter ;

drop trigger if exists ins_bookings_after;
delimiter //
CREATE TRIGGER ins_bookings_after AFTER INSERT ON bookings
FOR EACH ROW
BEGIN

    UPDATE seats SET seats.available = false WHERE seats.flt_id = NEW.flt_id and seats.id = NEW.seat_id;

END//
delimiter ;

drop trigger if exists upd_bookings_before;
delimiter //
CREATE TRIGGER upd_bookings_before BEFORE UPDATE ON bookings FOR EACH ROW
BEGIN
 
    -- ensure that inactive bookings cannot be updated
    IF old.status = 'inactive' THEN
        SET @error_msg = CONCAT('Invalid Bookings UPDATE. Booking id ', old.id, ' to be updated, but status is inactive');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;
 
    -- ensure that a booking to be set as not active won't have fields other than status being modified
    IF NEW.status <> 'active' AND (NEW.id,NEW.flt_id,NEW.cust_id,NEW.seat_id,NEW.purchase_datetime,NEW.ref_num) <> (OLD.id,OLD.flt_id,OLD.cust_id,OLD.seat_id,OLD.purchase_datetime,OLD.ref_num) THEN
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

/*
drop trigger if exists upd_bookings_after;
delimiter //
CREATE TRIGGER upd_bookings_after AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    -- if booking is cancelled by customer, then seat becomes availalbe
    IF NEW.status = 'cust_cancelled' THEN
        UPDATE seats SET seats.available = true WHERE seats.id = NEW.seat_id;

    -- if booking is active, then seat becomes unavailable 
    -- if the seat_id for booking change, then the customer changed seat. Need to update the seat availability accordingly 
    -- if the seat_id didn't change, then everything still the same because the NEW.seat_id will overwrite the OLD.seat_id

    ELSEIF NEW.status = 'active' THEN
        UPDATE seats SET seats.available = true WHERE seats.id = OLD.seat_id;
        UPDATE seats SET seats.available = false WHERE seats.id = NEW.seat_id;    
    END IF;
END//
delimiter ;
*/

drop trigger if exists del_bookings_after;
delimiter //
CREATE TRIGGER del_bookings_after AFTER DELETE ON bookings
FOR EACH ROW
BEGIN
    
    UPDATE seats SET seats.available = true WHERE seats.id = OLD.seat_id;

END//
delimiter ;