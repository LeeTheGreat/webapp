-- sp_ins_customer_and_booking (IN email VARCHAR(50), IN fn VARCHAR(30), IN ln VARCHAR(30), IN gender CHAR(1), IN dob DATE, IN flt_id INT, IN seat_num CHAR(3), IN ref_num CHAR(8))

CALL sp_ins_user_and_booking('noemail@email.com', 'noemail_fn', 'noemail_ln', 'M', '1999-09-29', 16, 'A04', 'EDD14E75');
CALL sp_ins_user_and_booking('mshemminga@networksolutions.com', 'mshemminga', 'mshemminga', 'M', '1988-10-01', 16, 'A05', 'A1372DC2');
CALL sp_ins_user_and_booking('kfitzgilbert0@mapy.cz', 'kfitzgilbert0', 'kfitzgilbert0', 'M', '1987-01-10', 16, 'A06', 'D124BDA2');
CALL sp_ins_user_and_booking('traveller1@t.com', 'traveller1', 'traveller1', 'M', '1987-01-10', 17, 'A07', 'D124BDA3');
CALL sp_ins_user_and_booking('traveller2@t.com', 'traveller2', 'traveller2', 'F', '1987-01-10', 17, 'A08', 'D124BDA3');
CALL sp_ins_user_and_booking('traveller3@t.com', 'traveller3', 'traveller3', 'F', '1987-01-10', 17, 'A09', 'D124BDA3');
CALL sp_ins_user_and_booking('traveller4@t.com', 'traveller4', 'traveller4', 'M', '1987-01-10', 18, 'A07', 'D124BEA3');
CALL sp_ins_user_and_booking('traveller5@t.com', 'traveller5', 'traveller5', 'F', '1987-01-10', 18, 'A08', 'D124BEA3');
CALL sp_ins_user_and_booking('traveller6@t.com', 'traveller6', 'traveller6', 'F', '1987-01-10', 18, 'A09', 'D124BEA3');

