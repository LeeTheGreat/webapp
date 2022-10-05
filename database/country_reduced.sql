CREATE TABLE IF NOT EXISTS countries(
   id           INTEGER  NOT NULL PRIMARY KEY,
   name         VARCHAR(36) NOT NULL,
   iso3         VARCHAR(3) NOT NULL UNIQUE,
   iso2         VARCHAR(2) NOT NULL UNIQUE
);
INSERT INTO countries(id,name,iso3,iso2) VALUES (14,'Australia','AUS','AU');
INSERT INTO countries(id,name,iso3,iso2) VALUES (116,'South Korea','KOR','KR');
INSERT INTO countries(id,name,iso3,iso2) VALUES (199,'Singapore','SGP','SG');
INSERT INTO countries(id,name,iso3,iso2) VALUES (240,'Vietnam','VNM','VN');
INSERT INTO countries(id,name,iso3,iso2) VALUES (219,'Thailand','THA','TH');
INSERT INTO countries(id,name,iso3,iso2) VALUES (102,'Indonesia','IDN','ID');
INSERT INTO countries(id,name,iso3,iso2) VALUES (174,'Philippines','PHL','PH');
INSERT INTO countries(id,name,iso3,iso2) VALUES (109,'Japan','JPN','JP');
INSERT INTO countries(id,name,iso3,iso2) VALUES (132,'Malaysia','MYS','MY');