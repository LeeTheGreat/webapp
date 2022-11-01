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
    /* only cancels active bookings of flight if flight gets cancelled*/
    IF NEW.status = "cancelled" THEN
        UPDATE bookings SET bookings.status = "flt_cancelled" WHERE flt_id = NEW.id AND status = 'active';

    /* only reactivate bookings that were previously affected by flight changes */
    ELSEIF NEW.status = "active" OR NEW.status = "rescheduled" THEN    
        UPDATE bookings SET bookings.status = "active" WHERE flt_id = NEW.id AND status LIKE 'flt_%';
    END IF;

    -- INSERT INTO flights_hist VALUES (NULL, NEW.id, CONCAT_WS(';',OLD.flt_num,OLD.aircraft_id,OLD.src_airport_code,OLD.dst_airport_code,OLD.depart,OLD.arrive,OLD.price,OLD.status));
END//
delimiter ;

drop trigger if exists ins_bookings_before;
delimiter //
CREATE TRIGGER ins_bookings_before BEFORE INSERT ON bookings
FOR EACH ROW
BEGIN

    /* check if an inactive booking is being inserted */
    IF NEW.status <> 'active' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Bookings INSERT. Inserting a booking with non-active status';
    END IF;

    /* check if there's an existing active booking with the same seat id before a booking is inserted */
    /* SELECT count(*) FROM bookings WHERE (flt_id,seat_id) = (127,5351) AND status = 'active'; */
    IF NEW.status = 'active' AND (SELECT count(*) FROM bookings WHERE (flt_id,seat_id) = (NEW.flt_id,NEW.seat_id) AND status = NEW.status) > 0 THEN
        SET @error_msg = CONCAT('Invalid Bookings INSERT. seat_id ', NEW.seat_id, ' already exists for flt_id ', NEW.flt_id, ' with status \'active\'');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    /* check if there's insertion of booking where flight is not active */
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
    /* automatically set seat availability to false if booking is added */
    IF NEW.status = 'active' THEN
        UPDATE seats SET seats.available = false WHERE seats.flt_id = NEW.flt_id and seats.id = NEW.seat_id;
    END IF;
END//
delimiter ;

drop trigger if exists upd_bookings_before;
delimiter //
CREATE TRIGGER upd_bookings_before BEFORE UPDATE ON bookings
FOR EACH ROW
BEGIN
    /* check if there's an existing active booking with the same seat id before a booking is updated */
    /*update bookings set status = 'active' where id=68;*/
    IF NEW.status = 'active' AND (SELECT count(*) FROM bookings WHERE (flt_id,seat_id) = (NEW.flt_id,NEW.seat_id) AND status = 'active' AND id <> NEW.id) > 0 THEN
        SET @error_msg = CONCAT('Invalid Bookings UPDATE. seat_id ', NEW.seat_id, ' already exists for flt_id ', NEW.flt_id, ' with status \'active\'');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    /* check if a non-active bookings has its fields other than status being modified */
    IF NEW.status <> 'active' AND (NEW.id,NEW.flt_id,NEW.cust_id,NEW.seat_id,NEW.purchase_datetime,NEW.ref_num) <> (OLD.id,OLD.flt_id,OLD.cust_id,OLD.seat_id,OLD.purchase_datetime,OLD.ref_num) THEN
        SET @error_msg = CONCAT('Invalid Bookings UPDATE. Booking id ', NEW.id, ' to be updated as non-active, but other fields were modified');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    /*check if a booking is updated to be active when the flight is non-active*/
    IF NEW.status = 'active' AND NOT EXISTS (SELECT status FROM flights WHERE id = NEW.flt_id AND status = 'active') THEN
        SET @error_msg = CONCAT('Invalid Bookings UPDATE. Booking id ', NEW.id, ' to be updated as active, but flt_id ', NEW.flt_id, ' status is non-active');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;    

END//
delimiter ;

drop trigger if exists upd_bookings_after;
delimiter //
CREATE TRIGGER upd_bookings_after AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    /* if booking is cancelled by customer, then seat becomes availalbe */
    IF NEW.status = 'cust_cancelled' THEN
        UPDATE seats SET seats.available = true WHERE seats.id = NEW.seat_id;

    /* if booking is active, then seat becomes unavailable */
    /* if the seat_id for booking change, then the customer changed seat. Need to update the seat availability accordingly 
       if the seat_id didn't change, then everything still the same because the NEW.seat_id will overwrite the OLD.seat_id
    */

    ELSEIF NEW.status = 'active' THEN
        UPDATE seats SET seats.available = true WHERE seats.id = OLD.seat_id;
        UPDATE seats SET seats.available = false WHERE seats.id = NEW.seat_id;    
    END IF;
END//
delimiter ;