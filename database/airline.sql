CREATE TABLE IF NOT EXISTS `airline`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`icao_code` CHAR(3) NOT NULL UNIQUE,
	`name` VARCHAR(50) NOT NULL
);

INSERT INTO airline("VVV", "VVV International Airlines");
INSERT INTO airline("KKK", "KKK International Airlines");
INSERT INTO airline("SSS", "SSS International Airlines");