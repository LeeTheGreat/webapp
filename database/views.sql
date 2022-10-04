drop view all_flights_informative;
CREATE VIEW all_flights_informative AS
    /*SELECT flt.id as flt_id, flt_num as flt_num, al.name as airline_name, CONCAT(ac.company, " ", ac.model) as "aircraft_info", ct1.name as "src_ct", ct2.name as "ct_2_name", ap1.name as "fm_airport", ap2.name as "", depart as Depart, arrive as Arrive, price as Price, status as Status from flights as flt*/
    SELECT flts.id as flt_id, flt_num, airline_id, aircraft_id, src_airport_code, dst_airport_code, src_country_code, dst_country_code, depart, arrive, price, status, CONCAT(ac.company, " ", ac.model) as aircraft, ct1.name as src_country_name, ct2.name as dst_country_name, ap1.name as src_airport_name, ap2.name as dst_airport_name, icao_code as airline_icao, al.name as airline_name from flights as flts
            join airlines as al on al.id = airline_id
            join airports as ap1 on ap1.iata_code = src_airport_code
            join airports as ap2 on ap2.iata_code = dst_airport_code
            join countries as ct1 on ct1.iso2 = src_country_code
            join countries as ct2 on ct2.iso2 = dst_country_code
            join aircrafts as ac on ac.id = aircraft_id;
