/****************/
/* normal flights */
/****************/

call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2022/11/01 20:30:00', '2022/11/02 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2022/11/02 09:30:00', '2022/11/02 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2022/11/02 20:30:00', '2022/11/03 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2022/11/03 09:30:00', '2022/11/03 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2022/11/03 20:30:00', '2022/11/04 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2022/11/04 09:30:00', '2022/11/04 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2022/11/04 20:30:00', '2022/11/05 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2022/11/05 09:30:00', '2022/11/05 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2022/11/05 20:30:00', '2022/11/06 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2022/11/06 09:30:00', '2022/11/06 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2022/11/06 20:30:00', '2022/11/07 04:30:00', 464,'active');

call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2022/11/01 09:30:00', '2022/11/01 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2022/11/01 20:30:00', '2022/11/02 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2022/11/02 09:30:00', '2022/11/02 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2022/11/02 20:30:00', '2022/11/03 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2022/11/03 09:30:00', '2022/11/03 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2022/11/03 20:30:00', '2022/11/04 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2022/11/04 09:30:00', '2022/11/04 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2022/11/04 20:30:00', '2022/11/05 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2022/11/05 09:30:00', '2022/11/05 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2022/11/05 20:30:00', '2022/11/06 04:30:00', 464,'active');

call sp_flights_insert ('3873', 1, 'HND', 'BTH', '2022/11/16 13:00:00', '2022/11/16 18:00:00', 422,'active');
call sp_flights_insert ('3873', 2, 'BTH', 'HND', '2022/11/16 08:00:00', '2022/11/16 15:00:00', 286,'active');
call sp_flights_insert ('8851', 1, 'HND', 'BTH', '2022/11/17 13:00:00', '2022/11/18 18:00:00', 507,'active');
call sp_flights_insert ('8851', 6, 'BTH', 'HND', '2022/11/17 08:00:00', '2022/11/17 15:00:00', 330,'active');
call sp_flights_insert ('3873', 1, 'HND', 'BTH', '2022/11/18 13:00:00', '2022/11/18 18:00:00', 422,'active');
call sp_flights_insert ('3873', 2, 'BTH', 'HND', '2022/11/18 08:00:00', '2022/11/18 15:00:00', 286,'active');
call sp_flights_insert ('6923', 1, 'HND', 'BTH', '2022/11/19 13:00:00', '2022/11/20 18:00:00', 507,'active');
call sp_flights_insert ('6923', 6, 'BTH', 'HND', '2022/11/19 08:00:00', '2022/11/19 15:00:00', 330,'active');
call sp_flights_insert ('0251', 1, 'HND', 'BTH', '2022/11/20 13:00:00', '2022/11/20 18:00:00', 422,'active');
call sp_flights_insert ('0251', 2, 'BTH', 'HND', '2022/11/20 08:00:00', '2022/11/20 15:00:00', 286,'active');

/****************/
/* indirect flight from SIN to YIA to HND. To test 1 hop indirect flight from SIN to HND */
/****************/
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/01 09:30:00', '2022/11/01 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/01 11:30:00', '2022/11/01 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/01 16:00:00', '2022/11/01 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/01 20:30:00', '2022/11/02 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/02 09:30:00', '2022/11/02 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/02 11:30:00', '2022/11/02 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/02 16:00:00', '2022/11/02 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/02 20:30:00', '2022/11/03 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/03 09:30:00', '2022/11/03 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/03 11:30:00', '2022/11/03 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/03 16:00:00', '2022/11/03 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/03 20:30:00', '2022/11/04 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/04 09:30:00', '2022/11/04 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/04 11:30:00', '2022/11/04 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/04 16:00:00', '2022/11/04 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/04 20:30:00', '2022/11/05 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/05 09:30:00', '2022/11/05 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/05 11:30:00', '2022/11/05 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/05 16:00:00', '2022/11/05 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/05 20:30:00', '2022/11/06 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/06 09:30:00', '2022/11/06 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/06 11:30:00', '2022/11/06 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2022/11/06 16:00:00', '2022/11/06 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2022/11/06 20:30:00', '2022/11/07 01:30:00', 464,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/01 08:00:00', '2022/11/01 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/01 08:00:00', '2022/11/01 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/01 20:00:00', '2022/11/02 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/01 20:00:00', '2022/11/02 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/02 08:00:00', '2022/11/02 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/02 08:00:00', '2022/11/02 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/02 20:00:00', '2022/11/03 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/02 20:00:00', '2022/11/03 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/03 08:00:00', '2022/11/03 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/03 08:00:00', '2022/11/03 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/03 20:00:00', '2022/11/04 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/03 20:00:00', '2022/11/04 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/04 08:00:00', '2022/11/04 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/04 08:00:00', '2022/11/04 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/04 20:00:00', '2022/11/05 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/04 20:00:00', '2022/11/05 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/05 08:00:00', '2022/11/05 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/05 08:00:00', '2022/11/05 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/05 20:00:00', '2022/11/06 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/05 20:00:00', '2022/11/06 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/06 08:00:00', '2022/11/06 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/06 08:00:00', '2022/11/06 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2022/11/06 20:00:00', '2022/11/07 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2022/11/06 20:00:00', '2022/11/07 04:00:00', 1000,'active');

/****************/
/* indirect flight from SIN to BTH to PER to HND. To 2 hop indirect flight from SIN to HND */
/****************/
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/01 08:00:00', '2022/11/01 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/01 10:00:00', '2022/11/01 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/01 20:00:00', '2022/11/02 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/01 22:00:00', '2022/11/02 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/02 08:00:00', '2022/11/02 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/02 10:00:00', '2022/11/02 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/02 20:00:00', '2022/11/03 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/02 22:00:00', '2022/11/03 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/03 08:00:00', '2022/11/03 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/03 10:00:00', '2022/11/03 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/03 20:00:00', '2022/11/04 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/03 22:00:00', '2022/11/04 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/04 08:00:00', '2022/11/04 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/04 10:00:00', '2022/11/04 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/04 20:00:00', '2022/11/05 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/04 22:00:00', '2022/11/05 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/05 08:00:00', '2022/11/05 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/05 08:00:00', '2022/11/05 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/05 20:00:00', '2022/11/06 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/05 20:00:00', '2022/11/06 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/06 08:00:00', '2022/11/06 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/06 08:00:00', '2022/11/06 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2022/11/06 20:00:00', '2022/11/07 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2022/11/06 20:00:00', '2022/11/07 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/01 08:00:00', '2022/11/01 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/01 08:00:00', '2022/11/01 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/01 20:00:00', '2022/11/02 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/01 20:00:00', '2022/11/02 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/02 08:00:00', '2022/11/02 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/02 08:00:00', '2022/11/02 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/02 20:00:00', '2022/11/03 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/02 20:00:00', '2022/11/03 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/03 08:00:00', '2022/11/03 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/03 08:00:00', '2022/11/03 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/03 20:00:00', '2022/11/04 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/03 20:00:00', '2022/11/04 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/04 08:00:00', '2022/11/04 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/04 08:00:00', '2022/11/04 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/04 20:00:00', '2022/11/05 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/04 20:00:00', '2022/11/05 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/05 08:00:00', '2022/11/05 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/05 08:00:00', '2022/11/05 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/05 20:00:00', '2022/11/06 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/05 20:00:00', '2022/11/06 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/06 08:00:00', '2022/11/06 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/06 08:00:00', '2022/11/06 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2022/11/06 20:00:00', '2022/11/07 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2022/11/06 20:00:00', '2022/11/07 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/01 08:00:00', '2022/11/01 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/01 08:00:00', '2022/11/01 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/01 20:00:00', '2022/11/02 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/01 20:00:00', '2022/11/02 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/02 08:00:00', '2022/11/02 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/02 08:00:00', '2022/11/02 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/02 20:00:00', '2022/11/03 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/02 20:00:00', '2022/11/03 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/03 08:00:00', '2022/11/03 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/03 08:00:00', '2022/11/03 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/03 20:00:00', '2022/11/04 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/03 20:00:00', '2022/11/04 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/04 08:00:00', '2022/11/04 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/04 08:00:00', '2022/11/04 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/04 20:00:00', '2022/11/05 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/04 20:00:00', '2022/11/05 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/05 08:00:00', '2022/11/05 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/05 08:00:00', '2022/11/05 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/05 20:00:00', '2022/11/06 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/05 20:00:00', '2022/11/06 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/06 08:00:00', '2022/11/06 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/06 08:00:00', '2022/11/06 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2022/11/06 20:00:00', '2022/11/07 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2022/11/06 20:00:00', '2022/11/07 02:00:00', 1000,'active');

call sp_flights_insert ('2257', 4, 'SIN', 'PER', '2022/11/02 09:30:00', '2022/11/02 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'PER', 'SIN', '2022/11/02 20:30:00', '2022/11/03 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'PER', '2022/11/01 09:30:00', '2022/11/01 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'PER', 'SIN', '2022/11/01 20:30:00', '2022/11/02 04:30:00', 464,'active');

/****************/
/* normal flights */
/****************/

call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2021/07/01 20:30:00', '2021/07/02 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2021/07/02 09:30:00', '2021/07/02 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2021/07/02 20:30:00', '2021/07/03 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2021/07/03 09:30:00', '2021/07/03 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2021/07/03 20:30:00', '2021/07/04 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2021/07/04 09:30:00', '2021/07/04 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2021/07/04 20:30:00', '2021/07/05 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2021/07/05 09:30:00', '2021/07/05 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2021/07/05 20:30:00', '2021/07/06 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'ITM', '2021/07/06 09:30:00', '2021/07/06 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'ITM', 'SIN', '2021/07/06 20:30:00', '2021/07/07 04:30:00', 464,'active');

call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2021/07/01 09:30:00', '2021/07/01 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2021/07/01 20:30:00', '2021/07/02 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2021/07/02 09:30:00', '2021/07/02 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2021/07/02 20:30:00', '2021/07/03 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2021/07/03 09:30:00', '2021/07/03 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2021/07/03 20:30:00', '2021/07/04 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2021/07/04 09:30:00', '2021/07/04 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2021/07/04 20:30:00', '2021/07/05 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'HND', '2021/07/05 09:30:00', '2021/07/05 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'HND', 'SIN', '2021/07/05 20:30:00', '2021/07/06 04:30:00', 464,'active');

call sp_flights_insert ('3873', 1, 'HND', 'BTH', '2021/07/16 13:00:00', '2021/07/16 18:00:00', 422,'active');
call sp_flights_insert ('3873', 2, 'BTH', 'HND', '2021/07/16 08:00:00', '2021/07/16 15:00:00', 286,'active');
call sp_flights_insert ('8851', 1, 'HND', 'BTH', '2021/07/17 13:00:00', '2021/07/18 18:00:00', 507,'active');
call sp_flights_insert ('8851', 6, 'BTH', 'HND', '2021/07/17 08:00:00', '2021/07/17 15:00:00', 330,'active');
call sp_flights_insert ('3873', 1, 'HND', 'BTH', '2021/07/18 13:00:00', '2021/07/18 18:00:00', 422,'active');
call sp_flights_insert ('3873', 2, 'BTH', 'HND', '2021/07/18 08:00:00', '2021/07/18 15:00:00', 286,'active');
call sp_flights_insert ('6923', 1, 'HND', 'BTH', '2021/07/19 13:00:00', '2021/07/20 18:00:00', 507,'active');
call sp_flights_insert ('6923', 6, 'BTH', 'HND', '2021/07/19 08:00:00', '2021/07/19 15:00:00', 330,'active');
call sp_flights_insert ('0251', 1, 'HND', 'BTH', '2021/07/20 13:00:00', '2021/07/20 18:00:00', 422,'active');
call sp_flights_insert ('0251', 2, 'BTH', 'HND', '2021/07/20 08:00:00', '2021/07/20 15:00:00', 286,'active');

/****************/
/* indirect flight from SIN to YIA to HND. To test 1 hop indirect flight from SIN to HND */
/****************/
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/01 09:30:00', '2021/07/01 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/01 11:30:00', '2021/07/01 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/01 16:00:00', '2021/07/01 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/01 20:30:00', '2021/07/02 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/02 09:30:00', '2021/07/02 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/02 11:30:00', '2021/07/02 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/02 16:00:00', '2021/07/02 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/02 20:30:00', '2021/07/03 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/03 09:30:00', '2021/07/03 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/03 11:30:00', '2021/07/03 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/03 16:00:00', '2021/07/03 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/03 20:30:00', '2021/07/04 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/04 09:30:00', '2021/07/04 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/04 11:30:00', '2021/07/04 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/04 16:00:00', '2021/07/04 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/04 20:30:00', '2021/07/05 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/05 09:30:00', '2021/07/05 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/05 11:30:00', '2021/07/05 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/05 16:00:00', '2021/07/05 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/05 20:30:00', '2021/07/06 01:30:00', 464,'active');

call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/06 09:30:00', '2021/07/06 14:30:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/06 11:30:00', '2021/07/06 16:30:00', 464,'active');
call sp_flights_insert ('3351', 4, 'SIN', 'YIA', '2021/07/06 16:00:00', '2021/07/06 21:00:00', 464,'active');
call sp_flights_insert ('0158', 4, 'YIA', 'SIN', '2021/07/06 20:30:00', '2021/07/07 01:30:00', 464,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/01 08:00:00', '2021/07/01 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/01 08:00:00', '2021/07/01 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/01 20:00:00', '2021/07/02 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/01 20:00:00', '2021/07/02 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/02 08:00:00', '2021/07/02 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/02 08:00:00', '2021/07/02 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/02 20:00:00', '2021/07/03 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/02 20:00:00', '2021/07/03 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/03 08:00:00', '2021/07/03 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/03 08:00:00', '2021/07/03 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/03 20:00:00', '2021/07/04 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/03 20:00:00', '2021/07/04 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/04 08:00:00', '2021/07/04 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/04 08:00:00', '2021/07/04 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/04 20:00:00', '2021/07/05 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/04 20:00:00', '2021/07/05 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/05 08:00:00', '2021/07/05 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/05 08:00:00', '2021/07/05 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/05 20:00:00', '2021/07/06 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/05 20:00:00', '2021/07/06 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/06 08:00:00', '2021/07/06 16:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/06 08:00:00', '2021/07/06 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'YIA', 'HND', '2021/07/06 20:00:00', '2021/07/07 04:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'YIA', '2021/07/06 20:00:00', '2021/07/07 04:00:00', 1000,'active');

/****************/
/* indirect flight from SIN to BTH to PER to HND. To 2 hop indirect flight from SIN to HND */
/****************/
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/01 08:00:00', '2021/07/01 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/01 10:00:00', '2021/07/01 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/01 20:00:00', '2021/07/02 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/01 22:00:00', '2021/07/02 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/02 08:00:00', '2021/07/02 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/02 10:00:00', '2021/07/02 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/02 20:00:00', '2021/07/03 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/02 22:00:00', '2021/07/03 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/03 08:00:00', '2021/07/03 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/03 10:00:00', '2021/07/03 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/03 20:00:00', '2021/07/04 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/03 22:00:00', '2021/07/04 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/04 08:00:00', '2021/07/04 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/04 10:00:00', '2021/07/04 16:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/04 20:00:00', '2021/07/05 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/04 22:00:00', '2021/07/05 04:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/05 08:00:00', '2021/07/05 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/05 08:00:00', '2021/07/05 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/05 20:00:00', '2021/07/06 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/05 20:00:00', '2021/07/06 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/06 08:00:00', '2021/07/06 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/06 08:00:00', '2021/07/06 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'SIN', 'BTH', '2021/07/06 20:00:00', '2021/07/07 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'SIN', '2021/07/06 20:00:00', '2021/07/07 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/01 08:00:00', '2021/07/01 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/01 08:00:00', '2021/07/01 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/01 20:00:00', '2021/07/02 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/01 20:00:00', '2021/07/02 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/02 08:00:00', '2021/07/02 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/02 08:00:00', '2021/07/02 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/02 20:00:00', '2021/07/03 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/02 20:00:00', '2021/07/03 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/03 08:00:00', '2021/07/03 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/03 08:00:00', '2021/07/03 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/03 20:00:00', '2021/07/04 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/03 20:00:00', '2021/07/04 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/04 08:00:00', '2021/07/04 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/04 08:00:00', '2021/07/04 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/04 20:00:00', '2021/07/05 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/04 20:00:00', '2021/07/05 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/05 08:00:00', '2021/07/05 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/05 08:00:00', '2021/07/05 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/05 20:00:00', '2021/07/06 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/05 20:00:00', '2021/07/06 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/06 08:00:00', '2021/07/06 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/06 08:00:00', '2021/07/06 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'BTH', '2021/07/06 20:00:00', '2021/07/07 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'BTH', 'PER', '2021/07/06 20:00:00', '2021/07/07 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/01 08:00:00', '2021/07/01 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/01 08:00:00', '2021/07/01 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/01 20:00:00', '2021/07/02 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/01 20:00:00', '2021/07/02 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/02 08:00:00', '2021/07/02 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/02 08:00:00', '2021/07/02 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/02 20:00:00', '2021/07/03 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/02 20:00:00', '2021/07/03 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/03 08:00:00', '2021/07/03 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/03 08:00:00', '2021/07/03 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/03 20:00:00', '2021/07/04 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/03 20:00:00', '2021/07/04 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/04 08:00:00', '2021/07/04 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/04 08:00:00', '2021/07/04 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/04 20:00:00', '2021/07/05 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/04 20:00:00', '2021/07/05 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/05 08:00:00', '2021/07/05 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/05 08:00:00', '2021/07/05 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/05 20:00:00', '2021/07/06 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/05 20:00:00', '2021/07/06 02:00:00', 1000,'active');

call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/06 08:00:00', '2021/07/06 14:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/06 08:00:00', '2021/07/06 14:00:00', 1000,'active');
call sp_flights_insert ('5852', 4, 'PER', 'HND', '2021/07/06 20:00:00', '2021/07/07 02:00:00', 1000,'active');
call sp_flights_insert ('2217', 4, 'HND', 'PER', '2021/07/06 20:00:00', '2021/07/07 02:00:00', 1000,'active');

call sp_flights_insert ('2257', 4, 'SIN', 'PER', '2021/07/02 09:30:00', '2021/07/02 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'PER', 'SIN', '2021/07/02 20:30:00', '2021/07/03 04:30:00', 464,'active');
call sp_flights_insert ('2257', 4, 'SIN', 'PER', '2021/07/01 09:30:00', '2021/07/01 17:30:00', 900,'active');
call sp_flights_insert ('2257', 4, 'PER', 'SIN', '2021/07/01 20:30:00', '2021/07/02 04:30:00', 464,'active');
