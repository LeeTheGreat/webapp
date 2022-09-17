CREATE TABLE IF NOT EXISTS countries(
   id           INTEGER  NOT NULL PRIMARY KEY,
   name         VARCHAR(36) NOT NULL,
   iso3         VARCHAR(3) NOT NULL UNIQUE,
   iso2         VARCHAR(2) NOT NULL UNIQUE,
   numeric_code INTEGER  NOT NULL UNIQUE,
   phone_code   VARCHAR(16) NOT NULL
);
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (1,'Afghanistan','AFG','AF',4,'93');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (2,'Aland Islands','ALA','AX',248,'+358-18');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (3,'Albania','ALB','AL',8,'355');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (4,'Algeria','DZA','DZ',12,'213');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (5,'American Samoa','ASM','AS',16,'+1-684');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (6,'Andorra','AND','AD',20,'376');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (7,'Angola','AGO','AO',24,'244');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (8,'Anguilla','AIA','AI',660,'+1-264');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (9,'Antarctica','ATA','AQ',10,'672');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (10,'Antigua And Barbuda','ATG','AG',28,'+1-268');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (11,'Argentina','ARG','AR',32,'54');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (12,'Armenia','ARM','AM',51,'374');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (13,'Aruba','ABW','AW',533,'297');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (14,'Australia','AUS','AU',36,'61');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (15,'Austria','AUT','AT',40,'43');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (16,'Azerbaijan','AZE','AZ',31,'994');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (18,'Bahrain','BHR','BH',48,'973');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (19,'Bangladesh','BGD','BD',50,'880');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (20,'Barbados','BRB','BB',52,'+1-246');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (21,'Belarus','BLR','BY',112,'375');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (22,'Belgium','BEL','BE',56,'32');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (23,'Belize','BLZ','BZ',84,'501');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (24,'Benin','BEN','BJ',204,'229');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (25,'Bermuda','BMU','BM',60,'+1-441');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (26,'Bhutan','BTN','BT',64,'975');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (27,'Bolivia','BOL','BO',68,'591');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (155,'Bonaire, Sint Eustatius and Saba','BES','BQ',535,'599');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (28,'Bosnia and Herzegovina','BIH','BA',70,'387');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (29,'Botswana','BWA','BW',72,'267');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (30,'Bouvet Island','BVT','BV',74,'0055');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (31,'Brazil','BRA','BR',76,'55');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (32,'British Indian Ocean Territory','IOT','IO',86,'246');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (33,'Brunei','BRN','BN',96,'673');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (34,'Bulgaria','BGR','BG',100,'359');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (35,'Burkina Faso','BFA','BF',854,'226');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (36,'Burundi','BDI','BI',108,'257');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (37,'Cambodia','KHM','KH',116,'855');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (38,'Cameroon','CMR','CM',120,'237');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (39,'Canada','CAN','CA',124,'1');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (40,'Cape Verde','CPV','CV',132,'238');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (41,'Cayman Islands','CYM','KY',136,'+1-345');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (42,'Central African Republic','CAF','CF',140,'236');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (43,'Chad','TCD','TD',148,'235');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (44,'Chile','CHL','CL',152,'56');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (45,'China','CHN','CN',156,'86');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (46,'Christmas Island','CXR','CX',162,'61');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (47,'Cocos (Keeling) Islands','CCK','CC',166,'61');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (48,'Colombia','COL','CO',170,'57');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (49,'Comoros','COM','KM',174,'269');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (50,'Congo','COG','CG',178,'242');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (52,'Cook Islands','COK','CK',184,'682');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (53,'Costa Rica','CRI','CR',188,'506');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (54,'Cote D''Ivoire (Ivory Coast)','CIV','CI',384,'225');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (55,'Croatia','HRV','HR',191,'385');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (56,'Cuba','CUB','CU',192,'53');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (249,'CuraÃ§ao','CUW','CW',531,'599');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (57,'Cyprus','CYP','CY',196,'357');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (58,'Czech Republic','CZE','CZ',203,'420');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (51,'Democratic Republic of the Congo','COD','CD',180,'243');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (59,'Denmark','DNK','DK',208,'45');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (60,'Djibouti','DJI','DJ',262,'253');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (61,'Dominica','DMA','DM',212,'+1-767');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (62,'Dominican Republic','DOM','DO',214,'+1-809 and 1-829');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (63,'East Timor','TLS','TL',626,'670');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (64,'Ecuador','ECU','EC',218,'593');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (65,'Egypt','EGY','EG',818,'20');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (66,'El Salvador','SLV','SV',222,'503');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (67,'Equatorial Guinea','GNQ','GQ',226,'240');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (68,'Eritrea','ERI','ER',232,'291');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (69,'Estonia','EST','EE',233,'372');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (70,'Ethiopia','ETH','ET',231,'251');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (71,'Falkland Islands','FLK','FK',238,'500');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (72,'Faroe Islands','FRO','FO',234,'298');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (73,'Fiji Islands','FJI','FJ',242,'679');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (74,'Finland','FIN','FI',246,'358');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (75,'France','FRA','FR',250,'33');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (76,'French Guiana','GUF','GF',254,'594');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (77,'French Polynesia','PYF','PF',258,'689');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (78,'French Southern Territories','ATF','TF',260,'262');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (79,'Gabon','GAB','GA',266,'241');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (80,'Gambia The','GMB','GM',270,'220');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (81,'Georgia','GEO','GE',268,'995');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (82,'Germany','DEU','DE',276,'49');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (83,'Ghana','GHA','GH',288,'233');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (84,'Gibraltar','GIB','GI',292,'350');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (85,'Greece','GRC','GR',300,'30');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (86,'Greenland','GRL','GL',304,'299');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (87,'Grenada','GRD','GD',308,'+1-473');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (88,'Guadeloupe','GLP','GP',312,'590');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (89,'Guam','GUM','GU',316,'+1-671');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (90,'Guatemala','GTM','GT',320,'502');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (91,'Guernsey and Alderney','GGY','GG',831,'+44-1481');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (92,'Guinea','GIN','GN',324,'224');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (93,'Guinea-Bissau','GNB','GW',624,'245');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (94,'Guyana','GUY','GY',328,'592');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (95,'Haiti','HTI','HT',332,'509');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (96,'Heard Island and McDonald Islands','HMD','HM',334,'672');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (97,'Honduras','HND','HN',340,'504');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (98,'Hong Kong S.A.R.','HKG','HK',344,'852');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (99,'Hungary','HUN','HU',348,'36');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (100,'Iceland','ISL','IS',352,'354');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (101,'India','IND','IN',356,'91');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (102,'Indonesia','IDN','ID',360,'62');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (103,'Iran','IRN','IR',364,'98');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (104,'Iraq','IRQ','IQ',368,'964');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (105,'Ireland','IRL','IE',372,'353');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (106,'Israel','ISR','IL',376,'972');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (107,'Italy','ITA','IT',380,'39');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (108,'Jamaica','JAM','JM',388,'+1-876');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (109,'Japan','JPN','JP',392,'81');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (110,'Jersey','JEY','JE',832,'+44-1534');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (111,'Jordan','JOR','JO',400,'962');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (112,'Kazakhstan','KAZ','KZ',398,'7');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (113,'Kenya','KEN','KE',404,'254');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (114,'Kiribati','KIR','KI',296,'686');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (248,'Kosovo','XKX','XK',926,'383');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (117,'Kuwait','KWT','KW',414,'965');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (118,'Kyrgyzstan','KGZ','KG',417,'996');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (119,'Laos','LAO','LA',418,'856');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (120,'Latvia','LVA','LV',428,'371');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (121,'Lebanon','LBN','LB',422,'961');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (122,'Lesotho','LSO','LS',426,'266');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (123,'Liberia','LBR','LR',430,'231');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (124,'Libya','LBY','LY',434,'218');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (125,'Liechtenstein','LIE','LI',438,'423');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (126,'Lithuania','LTU','LT',440,'370');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (127,'Luxembourg','LUX','LU',442,'352');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (128,'Macau S.A.R.','MAC','MO',446,'853');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (129,'Macedonia','MKD','MK',807,'389');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (130,'Madagascar','MDG','MG',450,'261');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (131,'Malawi','MWI','MW',454,'265');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (132,'Malaysia','MYS','MY',458,'60');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (133,'Maldives','MDV','MV',462,'960');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (134,'Mali','MLI','ML',466,'223');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (135,'Malta','MLT','MT',470,'356');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (136,'Man (Isle of)','IMN','IM',833,'+44-1624');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (137,'Marshall Islands','MHL','MH',584,'692');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (138,'Martinique','MTQ','MQ',474,'596');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (139,'Mauritania','MRT','MR',478,'222');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (140,'Mauritius','MUS','MU',480,'230');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (141,'Mayotte','MYT','YT',175,'262');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (142,'Mexico','MEX','MX',484,'52');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (143,'Micronesia','FSM','FM',583,'691');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (144,'Moldova','MDA','MD',498,'373');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (145,'Monaco','MCO','MC',492,'377');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (146,'Mongolia','MNG','MN',496,'976');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (147,'Montenegro','MNE','ME',499,'382');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (148,'Montserrat','MSR','MS',500,'+1-664');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (149,'Morocco','MAR','MA',504,'212');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (150,'Mozambique','MOZ','MZ',508,'258');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (151,'Myanmar','MMR','MM',104,'95');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (152,'Namibia','NAM','NA',516,'264');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (153,'Nauru','NRU','NR',520,'674');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (154,'Nepal','NPL','NP',524,'977');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (156,'Netherlands','NLD','NL',528,'31');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (157,'New Caledonia','NCL','NC',540,'687');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (158,'New Zealand','NZL','NZ',554,'64');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (159,'Nicaragua','NIC','NI',558,'505');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (160,'Niger','NER','NE',562,'227');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (161,'Nigeria','NGA','NG',566,'234');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (162,'Niue','NIU','NU',570,'683');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (163,'Norfolk Island','NFK','NF',574,'672');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (115,'North Korea','PRK','KP',408,'850');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (164,'Northern Mariana Islands','MNP','MP',580,'+1-670');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (165,'Norway','NOR','NO',578,'47');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (166,'Oman','OMN','OM',512,'968');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (167,'Pakistan','PAK','PK',586,'92');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (168,'Palau','PLW','PW',585,'680');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (169,'Palestinian Territory Occupied','PSE','PS',275,'970');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (170,'Panama','PAN','PA',591,'507');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (171,'Papua new Guinea','PNG','PG',598,'675');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (172,'Paraguay','PRY','PY',600,'595');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (173,'Peru','PER','PE',604,'51');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (174,'Philippines','PHL','PH',608,'63');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (175,'Pitcairn Island','PCN','PN',612,'870');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (176,'Poland','POL','PL',616,'48');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (177,'Portugal','PRT','PT',620,'351');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (178,'Puerto Rico','PRI','PR',630,'+1-787 and 1-939');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (179,'Qatar','QAT','QA',634,'974');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (180,'Reunion','REU','RE',638,'262');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (181,'Romania','ROU','RO',642,'40');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (182,'Russia','RUS','RU',643,'7');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (183,'Rwanda','RWA','RW',646,'250');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (184,'Saint Helena','SHN','SH',654,'290');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (185,'Saint Kitts And Nevis','KNA','KN',659,'+1-869');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (186,'Saint Lucia','LCA','LC',662,'+1-758');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (187,'Saint Pierre and Miquelon','SPM','PM',666,'508');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (188,'Saint Vincent And The Grenadines','VCT','VC',670,'+1-784');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (189,'Saint-Barthelemy','BLM','BL',652,'590');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (190,'Saint-Martin (French part)','MAF','MF',663,'590');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (191,'Samoa','WSM','WS',882,'685');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (192,'San Marino','SMR','SM',674,'378');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (193,'Sao Tome and Principe','STP','ST',678,'239');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (194,'Saudi Arabia','SAU','SA',682,'966');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (195,'Senegal','SEN','SN',686,'221');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (196,'Serbia','SRB','RS',688,'381');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (197,'Seychelles','SYC','SC',690,'248');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (198,'Sierra Leone','SLE','SL',694,'232');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (199,'Singapore','SGP','SG',702,'65');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (250,'Sint Maarten (Dutch part)','SXM','SX',534,'1721');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (200,'Slovakia','SVK','SK',703,'421');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (201,'Slovenia','SVN','SI',705,'386');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (202,'Solomon Islands','SLB','SB',90,'677');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (203,'Somalia','SOM','SO',706,'252');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (204,'South Africa','ZAF','ZA',710,'27');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (205,'South Georgia','SGS','GS',239,'500');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (116,'South Korea','KOR','KR',410,'82');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (206,'South Sudan','SSD','SS',728,'211');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (207,'Spain','ESP','ES',724,'34');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (208,'Sri Lanka','LKA','LK',144,'94');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (209,'Sudan','SDN','SD',729,'249');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (210,'Suriname','SUR','SR',740,'597');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (211,'Svalbard And Jan Mayen Islands','SJM','SJ',744,'47');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (212,'Swaziland','SWZ','SZ',748,'268');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (213,'Sweden','SWE','SE',752,'46');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (214,'Switzerland','CHE','CH',756,'41');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (215,'Syria','SYR','SY',760,'963');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (216,'Taiwan','TWN','TW',158,'886');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (217,'Tajikistan','TJK','TJ',762,'992');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (218,'Tanzania','TZA','TZ',834,'255');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (219,'Thailand','THA','TH',764,'66');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (17,'The Bahamas','BHS','BS',44,'+1-242');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (220,'Togo','TGO','TG',768,'228');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (221,'Tokelau','TKL','TK',772,'690');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (222,'Tonga','TON','TO',776,'676');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (223,'Trinidad And Tobago','TTO','TT',780,'+1-868');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (224,'Tunisia','TUN','TN',788,'216');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (225,'Turkey','TUR','TR',792,'90');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (226,'Turkmenistan','TKM','TM',795,'993');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (227,'Turks And Caicos Islands','TCA','TC',796,'+1-649');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (228,'Tuvalu','TUV','TV',798,'688');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (229,'Uganda','UGA','UG',800,'256');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (230,'Ukraine','UKR','UA',804,'380');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (231,'United Arab Emirates','ARE','AE',784,'971');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (232,'United Kingdom','GBR','GB',826,'44');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (233,'United States','USA','US',840,'1');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (234,'United States Minor Outlying Islands','UMI','UM',581,'1');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (235,'Uruguay','URY','UY',858,'598');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (236,'Uzbekistan','UZB','UZ',860,'998');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (237,'Vanuatu','VUT','VU',548,'678');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (238,'Vatican City State (Holy See)','VAT','VA',336,'379');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (239,'Venezuela','VEN','VE',862,'58');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (240,'Vietnam','VNM','VN',704,'84');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (241,'Virgin Islands (British)','VGB','VG',92,'+1-284');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (242,'Virgin Islands (US)','VIR','VI',850,'+1-340');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (243,'Wallis And Futuna Islands','WLF','WF',876,'681');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (244,'Western Sahara','ESH','EH',732,'212');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (245,'Yemen','YEM','YE',887,'967');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (246,'Zambia','ZMB','ZM',894,'260');
INSERT INTO countries(id,name,iso3,iso2,numeric_code,phone_code) VALUES (247,'Zimbabwe','ZWE','ZW',716,'263');
