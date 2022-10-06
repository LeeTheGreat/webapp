drop view view_flights_informative;
CREATE VIEW view_flights_informative AS
    /*SELECT flts.id as flt_id, flt_num, airline_id, aircraft_id, src_airport_code, dst_airport_code, src_country_code, dst_country_code, depart, arrive, price, status, CONCAT(ac.company, " ", ac.model) as aircraft, ct1.name as src_country_name, ct2.name as dst_country_name, ap1.name as src_airport_name, ap2.name as dst_airport_name, icao_code as airline_icao, al.name as airline_name from flights as flts*/
    SELECT view_flights.*, CONCAT(ac.company, " ", ac.model) as aircraft, ct1.country_name as src_country_name, ct2.country_name as dst_country_name, ap1.airport_name as src_airport_name, ap2.airport_name as dst_airport_name, al.name as airline_name from view_flights
            join airlines as al on al.id = airline_id
            /*join view_airports as ap1 on ap1.airport_code = src_airport_code*/
            join view_airports as ap1 on ap1.airport_code = src_airport_code
            join view_airports as ap2 on ap2.airport_code = dst_airport_code
            join view_countries as ct1 on ct1.country_code = src_country_code
            join view_countries as ct2 on ct2.country_code = dst_country_code
            join aircrafts as ac on ac.id = aircraft_id;

drop view view_bookings_informative;
CREATE VIEW view_bookings_informative AS
    SELECT * FROM view_bookings
            JOIN view_flights_informative AS afi USING (flt_id)
            JOIN view_customers_and_users USING (cust_id);

drop view view_countries;
CREATE VIEW view_countries AS
    SELECT name as country_name, iso2 as country_code FROM countries;

drop view view_airports;
CREATE VIEW view_airports AS
    SELECT name as airport_name, iata_code as airport_code, country_iso2 as country_code FROM airports;

drop view view_flights;
CREATE VIEW view_flights AS
    SELECT id as flt_id, flt_num, airline_id, aircraft_id, src_country_code, dst_country_code, src_airport_code, dst_airport_code, depart, arrive, price, status as flt_status from flights;

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