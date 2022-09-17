CREATE TABLE IF NOT EXISTS `airlines`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`icao_code` CHAR(3) NOT NULL UNIQUE,
	`name` VARCHAR(50) NOT NULL
);

INSERT INTO airlines VALUES (NULL, "VVV", "VVV International Airlines");
INSERT INTO airlines VALUES (NULL, "KKK", "KKK International Airlines");
INSERT INTO airlines VALUES (NULL, "SSS", "SSS International Airlines");