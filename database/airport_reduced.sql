CREATE TABLE `airports`(
  `id` INT AUTO_INCREMENT PRIMARY KEY
  ,`name` varchar(100) NOT NULL
  ,`iata_code` varchar(4) NOT NULL UNIQUE
  ,`country_iso2` char(2) NOT NULL
  ,`country` char(20) NOT NULL
  ,`region` char(50) NOT NULL
  ,INDEX idx_airports_iata_code (iata_code)
);

INSERT INTO `airports` VALUES (NULL,'Betong International Airport','BTZ','TH','Thailand','Betong');
INSERT INTO `airports` VALUES (NULL,'Banyuwangi International Airport','BWX','ID','Indonesia','Banyuwangi');
INSERT INTO `airports` VALUES (NULL,'Bicol International Airport','LGP','PH','Philippines','Daraga');
INSERT INTO `airports` VALUES (NULL,'Laguindingan International Airport','CGY','PH','Philippines','Cagayan de Oro');
INSERT INTO `airports` VALUES (NULL,'Cagayan North International Airport','LLC','PH','Philippines','Lal-lo');
INSERT INTO `airports` VALUES (NULL,'Narita International Airport','NRT','JP','Japan','Narita');
INSERT INTO `airports` VALUES (NULL,'Kansai International Airport','KIX','JP','Japan','Osaka');
INSERT INTO `airports` VALUES (NULL,'Chubu Centrair International Airport','NGO','JP','Japan','Tokoname');
INSERT INTO `airports` VALUES (NULL,'Osaka International Airport','ITM','JP','Japan','Osaka');
INSERT INTO `airports` VALUES (NULL,'Tokyo Haneda International Airport','HND','JP','Japan','Tokyo');
INSERT INTO `airports` VALUES (NULL,'Rosella Plains Airport','RLP','AU','Australia','Rosella Plains');
INSERT INTO `airports` VALUES (NULL,'Diosdado Macapagal International Airport','CRK','PH','Philippines','Mabalacat');
INSERT INTO `airports` VALUES (NULL,'Western Sydney International (Nancy Bird Walton) Airport','SWZ','AU','Australia','Sydney (Badgerys Creek)');
INSERT INTO `airports` VALUES (NULL,'Don Mueang International Airport','DMK','TH','Thailand','Bangkok');
INSERT INTO `airports` VALUES (NULL,'U-Tapao International Airport','UTP','TH','Thailand','Rayong');
INSERT INTO `airports` VALUES (NULL,'Chiang Mai International Airport','CNX','TH','Thailand','Chiang Mai');
INSERT INTO `airports` VALUES (NULL,'Mae Fah Luang - Chiang Rai International Airport','CEI','TH','Thailand','Chiang Rai');
INSERT INTO `airports` VALUES (NULL,'Phuket International Airport','HKT','TH','Thailand','Phuket');
INSERT INTO `airports` VALUES (NULL,'Hat Yai International Airport','HDY','TH','Thailand','Hat Yai');
INSERT INTO `airports` VALUES (NULL,'Yogyakarta International Airport','YIA','ID','Indonesia','Yogyakarta');
INSERT INTO `airports` VALUES (NULL,'Sentani International Airport','DJJ','ID','Indonesia','Sentani');
-- INSERT INTO `airports` VALUES (NULL,'Aji Pangeran Tumenggung Pranoto International Airport','AAP','ID','Indonesia');
INSERT INTO `airports` VALUES (NULL,'Kota Kinabalu International Airport','BKI','MY','Malaysia','Kota Kinabalu');
INSERT INTO `airports` VALUES (NULL,'Kertajati International Airport','KJT','ID','Indonesia','Kertajati');
INSERT INTO `airports` VALUES (NULL,'Hang Nadim International Airport','BTH','ID','Indonesia','Batam');
INSERT INTO `airports` VALUES (NULL,'Raja Haji Fisabilillah International Airport','TNJ','ID','Indonesia','Tanjung Pinang-Bintan Island');
INSERT INTO `airports` VALUES (NULL,'Soekarno-Hatta International Airport','CGK','ID','Indonesia','Jakarta');
INSERT INTO `airports` VALUES (NULL,'Senai International Airport','JHB','MY','Malaysia','Johor');
INSERT INTO `airports` VALUES (NULL,'Kuala Lumpur International Airport','KUL','MY','Malaysia','Kuala Lumpur');
INSERT INTO `airports` VALUES (NULL,'Langkawi International Airport','LGK','MY','Malaysia','Langkawi');
-- INSERT INTO `airports` VALUES (NULL,'Malacca International Airport','MKZ','MY','Malaysia');
INSERT INTO `airports` VALUES (NULL,'Penang International Airport','PEN','MY','Malaysia', 'Penang');
INSERT INTO `airports` VALUES (NULL,'Sultan Abdul Aziz Shah International Airport','SZB','MY','Malaysia','Subang');
INSERT INTO `airports` VALUES (NULL,'Brisbane International Airport','BNE','AU','Australia','Brisbane');
INSERT INTO `airports` VALUES (NULL,'Melbourne International Airport','MEL','AU','Australia','Melbourne');
INSERT INTO `airports` VALUES (NULL,'Adelaide International Airport','ADL','AU','Australia','Adelaide');
INSERT INTO `airports` VALUES (NULL,'Perth International Airport','PER','AU','Australia','Perth');
INSERT INTO `airports` VALUES (NULL,'Sydney Bankstown Airport','BWU','AU','Australia','Sydney');
INSERT INTO `airports` VALUES (NULL,'Canberra International Airport','CBR','AU','Australia','Canberra');
INSERT INTO `airports` VALUES (NULL,'Jeju International Airport','CJU','KR','Korea','Jeju City');
INSERT INTO `airports` VALUES (NULL,'Incheon International Airport','ICN','KR','Korea','Seoul');
INSERT INTO `airports` VALUES (NULL,'Gimpo International Airport','GMP','KR','Korea','Seoul');
INSERT INTO `airports` VALUES (NULL,'Cat Bi International Airport','HPH','VN','Vietnam','Haiphong (Hai An)');
INSERT INTO `airports` VALUES (NULL,'Cam Ranh International Airport','CXR','VN','Vietnam','Cam Ranh');
INSERT INTO `airports` VALUES (NULL,'Can Tho International Airport','VCA','VN','Vietnam','Can Tho');
INSERT INTO `airports` VALUES (NULL,'Da Nang International Airport','DAD','VN','Vietnam','Da Nang');
INSERT INTO `airports` VALUES (NULL,'Noi Bai International Airport','HAN','VN','Vietnam','Hanoi');
INSERT INTO `airports` VALUES (NULL,'Phu Quoc International Airport','PQC','VN','Vietnam','Phu Quoc Island');
INSERT INTO `airports` VALUES (NULL,'Tan Son Nhat International Airport','SGN','VN','Vietnam','Ho Chi Minh City');
INSERT INTO `airports` VALUES (NULL,'Van Don International Airport','VDO','VN','Vietnam','Van Don');
INSERT INTO `airports` VALUES (NULL,'Singapore Changi Airport','SIN','SG','Singapore','Singapore');