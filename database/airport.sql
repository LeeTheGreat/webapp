CREATE TABLE IF NOT EXISTS `airport`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(60) NOT NULL,	
	`iata_code` CHAR(3) NOT NULL UNIQUE
	`country_iso2` CHAR(2) NOT NULL,
	CONSTRAINT fk_airport_country_id FOREIGN KEY country_id REFERENCES country(id)
);

INSERT INTO airport ('WHN', 'Whini Airport', 1);
INSERT INTO airport ('ABN', 'Abini Airport', 2);
INSERT INTO airport ('CKK', 'Cekinket Airport', 3);
INSERT INTO airport ('ASP', 'Aintsipine Airport', 1);
INSERT INTO airport ('CTN', 'Cetrenil Airport', 3);
INSERT INTO airport ('JMM', 'Jiopimmin Airport', 1);
INSERT INTO airport ('TDS', 'Thedas Airport', 2);
INSERT INTO airport ('FED', 'Fereld Airport', 2);
INSERT INTO airport ('ORL', 'Orlenias Airport', 3);

