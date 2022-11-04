/*
drop view view_countries if exists;
CREATE VIEW view_countries AS
    SELECT name as country_name, iso2 as country_code FROM countries;
*/

drop view if exists view_airports;
CREATE VIEW view_airports AS
    SELECT name as airport_name, iata_code as airport_code, country, region FROM airports;

drop view if exists view_flights; 
CREATE VIEW view_flights AS
    SELECT id as flt_id, flt_num, aircraft_id, src_airport_code, dst_airport_code, DATE_FORMAT(depart,'%Y-%m-%d %H:%i') as depart, DATE_FORMAT(arrive,'%Y-%m-%d %H:%i') as arrive, price, status as flt_status from flights;

drop view if exists view_bookings;
CREATE VIEW view_bookings AS
    SELECT id as booking_id, flt_id, cust_id, seat_num, purchase_datetime, status as booking_status, ref_num FROM bookings;

drop view if exists view_customers;
CREATE VIEW view_customers AS
    SELECT id as cust_id, email, password, fname, lname, gender, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS user_age, role FROM users;

drop view if exists view_seats;
CREATE VIEW view_seats AS
    SELECT flt_id, seat_num, available FROM seats;

drop view if exists view_flights_informative;
CREATE VIEW view_flights_informative AS
    -- SELECT flts.id as flt_id, flt_num, airline_id, aircraft_id, src_airport_code, dst_airport_code, src_country_code, dst_country_code, depart, arrive, price, status, CONCAT(ac.company, " ", ac.model) as aircraft, ct1.name as src_country_name, ct2.name as dst_country_name, ap1.name as src_airport_name, ap2.name as dst_airport_name, icao_code as airline_icao, al.name as airline_name from flights as flts*/
    SELECT view_flights.*, CONCAT(ac.company, " ", ac.model) as aircraft, ap1.country as src_country_name, ap2.country as dst_country_name, ap1.airport_name as src_airport_name
            ,ap2.airport_name as dst_airport_name, (SELECT total_seat FROM aircrafts ac WHERE ac.id = view_flights.aircraft_id) as total_seat
            ,(SELECT count(*) FROM seats WHERE flt_id = view_flights.flt_id AND available=true) as total_seat_available, TIMESTAMPDIFF(HOUR, depart,arrive) as hours from view_flights
            JOIN view_airports as ap1 on ap1.airport_code = src_airport_code
            JOIN view_airports as ap2 on ap2.airport_code = dst_airport_code
            JOIN aircrafts as ac on ac.id = aircraft_id;

drop view if exists view_bookings_informative;
CREATE VIEW view_bookings_informative AS
    SELECT * FROM view_bookings
            -- since we SELECT *, we use USING to combine the common ids. otherwise, there'll be multiple columns of ids
            JOIN view_flights_informative USING (flt_id)
            JOIN view_customers USING (cust_id)
            JOIN view_seats USING (seat_num,flt_id);