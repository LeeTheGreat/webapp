-- sp_ins_customer_and_booking (IN email VARCHAR(50), IN fn VARCHAR(30), IN ln VARCHAR(30), IN gender CHAR(1), IN dob DATE, IN flt_id INT, IN seat_num CHAR(3), IN ref_num CHAR(8))

CALL sp_ins_user_and_booking('noemail@email.com', 'noemail_fn', 'noemail_ln', 'M', '1999-09-29', 16, 'A04', '123456');
CALL sp_ins_user_and_booking('mshemminga@networksolutions.com', 'mshemminga', 'mshemminga', 'M', '1988-10-01', 16, 'A05', '112233');
CALL sp_ins_user_and_booking('kfitzgilbert0@mapy.cz', 'kfitzgilbert0', 'kfitzgilbert0', 'M', '1987-01-10', 16, 'A06', '334455');
CALL sp_ins_user_and_booking('kfitzgilbert0@mapy.cz', 'kfitzgilbert0', 'kfitzgilbert0', 'M', '1987-01-10', 16, 'A07', '554433');

