CREATE TABLE IF NOT EXISTS `aircrafts`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
	`company` VARCHAR(30) NOT NULL,
	`model` VARCHAR(20) NOT NULL UNIQUE,
	`total_seat` INT NOT NULL
);

INSERT INTO aircrafts VALUES (NULL, 'Boeing', '777', 200);
INSERT INTO aircrafts VALUES (NULL, 'Boeing', '737', 200);
INSERT INTO aircrafts VALUES (NULL, 'Boeing', '767', 200);
INSERT INTO aircrafts VALUES (NULL, 'Boeing', '747', 200);
INSERT INTO aircrafts VALUES (NULL, 'Airbus', 'A320', 100);
INSERT INTO aircrafts VALUES (NULL, 'Airbus', 'A330', 100);
INSERT INTO aircrafts VALUES (NULL, 'Airbus', 'A340', 120);
INSERT INTO aircrafts VALUES (NULL, 'Airbus', 'A350', 120);