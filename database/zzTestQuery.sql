SG airport id - 557, 558, 559, 560
SG country id - 199

// will return 1 as airport in country
call sp_airport_exist_in_country(557, 199, @ret); select @ret; 

// will return 0 as airport not in country
call sp_airport_exist_in_country(558, 198, @ret); select @ret; 
call sp_airport_exist_in_country(600, 199, @ret); select @ret; 

// will return 0 as src aiport not in src country
call sp_flights_insert('1111',2,2,557,558,198,199,'1111-11-11 11:11:11','1111-11-12 11:11:12', 1111, 'active', @ret, @msg); select @ret, @msg;
call sp_flights_insert('1111',2,2,600,558,199,199,'1111-11-11 11:11:11','1111-11-12 11:11:12', 1111, 'active', @ret, @msg); select @ret, @msg;

// will return 0 as dst airport not in dst country
call sp_flights_insert('2222',2,2,557,558,199,198,'1111-11-11 11:11:11','1111-11-12 11:11:11', 1111, 'active', @ret, @msg); select @ret, @msg;
call sp_flights_insert('2222',2,2,557,600,199,199,'1111-11-11 11:11:11','1111-11-12 11:11:11', 1111, 'active', @ret, @msg); select @ret, @msg;

// will return 1 as dst and src airport in dst and src country
call sp_flights_insert('3333',2,2,557,558,199,199,'1111-11-11 11:11:11','1111-11-12 11:11:11', 1111, 'active', @ret, @msg); select @ret, @msg;