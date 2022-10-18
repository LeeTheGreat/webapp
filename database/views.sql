drop view view_flights_informative;
CREATE VIEW view_flights_informative AS
    /*SELECT flts.id as flt_id, flt_num, airline_id, aircraft_id, src_airport_code, dst_airport_code, src_country_code, dst_country_code, depart, arrive, price, status, CONCAT(ac.company, " ", ac.model) as aircraft, ct1.name as src_country_name, ct2.name as dst_country_name, ap1.name as src_airport_name, ap2.name as dst_airport_name, icao_code as airline_icao, al.name as airline_name from flights as flts*/
    SELECT view_flights.*, CONCAT(ac.company, " ", ac.model) as aircraft, ct1.country_name as src_country_name, ct2.country_name as dst_country_name, ap1.airport_name as src_airport_name
            ,ap2.airport_name as dst_airport_name, al.name as airline_name, (SELECT total_seat FROM aircrafts ac WHERE ac.id = view_flights.aircraft_id) as total_seat
            ,(SELECT count(*) FROM seats WHERE flt_id = view_flights.flt_id AND available=true) as total_seat_available, TIMESTAMPDIFF(HOUR, depart,arrive) as hours from view_flights
            JOIN airlines as al on al.id = airline_id
            /*join view_airports as ap1 on ap1.airport_code = src_airport_code*/
            JOIN view_airports as ap1 on ap1.airport_code = src_airport_code
            JOIN view_airports as ap2 on ap2.airport_code = dst_airport_code
            JOIN view_countries as ct1 on ct1.country_code = ap1.country_code
            JOIN view_countries as ct2 on ct2.country_code = ap2.country_code
            JOIN aircrafts as ac on ac.id = aircraft_id;

drop view view_bookings_informative;
CREATE VIEW view_bookings_informative AS
    SELECT * FROM view_bookings
            JOIN view_flights_informative AS afi USING (flt_id)
            JOIN view_customers_and_users USING (cust_id)
            JOIN view_seats USING (seat_id,flt_id);

drop view view_countries;
CREATE VIEW view_countries AS
    SELECT name as country_name, iso2 as country_code FROM countries;

drop view view_airports;
CREATE VIEW view_airports AS
    SELECT name as airport_name, iata_code as airport_code, country_iso2 as country_code FROM airports;

drop view view_flights;
CREATE VIEW view_flights AS
    SELECT id as flt_id, flt_num, airline_id, aircraft_id, src_airport_code, dst_airport_code, DATE_FORMAT(depart,'%Y-%m-%d %H:%i') as depart, DATE_FORMAT(arrive,'%Y-%m-%d %H:%i') as arrive, price, status as flt_status from flights;

drop view view_bookings;
CREATE VIEW view_bookings AS
    SELECT id as booking_id, flt_id, cust_id, seat_id, purchase_datetime, status as booking_status, ref_num FROM bookings;

drop view view_customers_and_users;
CREATE VIEW view_customers_and_users AS
    SELECT * FROM view_customers WHERE user_id IS NULL UNION SELECT cust_id, view_users.* FROM view_customers JOIN view_users USING (user_id);

drop view view_customers;
CREATE VIEW view_customers AS
    SELECT id as cust_id, user_id, cust_email as email, fname, lname, gender, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age FROM customers;
/*
    SELECT id as cust_id, user_id, cust_email as email, fname, lname, gender, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age FROM customers WHERE user_id IS NULL
    UNION
    SELECT c.id as cust_id, user_id, u.email as email, u.fname, u.lname, u.gender, TIMESTAMPDIFF(YEAR, u.dob, CURDATE()) AS age FROM customers c JOIN users as u on user_id = u.id;
  */  

drop view view_users;
CREATE VIEW view_users AS
    SELECT id as user_id, email as email, fname, lname, gender, TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS user_age FROM users;

drop view view_seats;
CREATE VIEW view_seats AS
    SELECT id as seat_id, flt_id, seat_num FROM seats;