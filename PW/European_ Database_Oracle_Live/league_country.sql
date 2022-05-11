CREATE TABLE "COUNTRY" ("ID" NUMBER(*,0), "NAME" VARCHAR2(100 BYTE)) ;
CREATE TABLE "LEAGUE" ("ID" NUMBER(*,0), "COUNTRY_ID" NUMBER(*,0), "NAME" VARCHAR2(100 BYTE)) ;

Insert into COUNTRY (ID,NAME) values (1,'Belgium');
Insert into COUNTRY (ID,NAME) values (1729,'England');
Insert into COUNTRY (ID,NAME) values (4769,'France');
Insert into COUNTRY (ID,NAME) values (7809,'Germany');
Insert into COUNTRY (ID,NAME) values (10257,'Italy');
Insert into COUNTRY (ID,NAME) values (13274,'Netherlands');
Insert into COUNTRY (ID,NAME) values (15722,'Poland');
Insert into COUNTRY (ID,NAME) values (17642,'Portugal');
Insert into COUNTRY (ID,NAME) values (19694,'Scotland');
Insert into COUNTRY (ID,NAME) values (21518,'Spain');
Insert into COUNTRY (ID,NAME) values (24558,'Switzerland');

Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (1,1,'Belgium Jupiler League');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (1729,1729,'England Premier League');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (4769,4769,'France Ligue 1');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (7809,7809,'Germany 1. Bundesliga');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (10257,10257,'Italy Serie A');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (13274,13274,'Netherlands Eredivisie');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (15722,15722,'Poland Ekstraklasa');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (17642,17642,'Portugal Liga ZON Sagres');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (19694,19694,'Scotland Premier League');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (21518,21518,'Spain LIGA BBVA');
Insert into LEAGUE (ID,COUNTRY_ID,NAME) values (24558,24558,'Switzerland Super League');

CREATE UNIQUE INDEX "SYS_C0011200" ON "COUNTRY" ("ID") ;

CREATE UNIQUE INDEX "SYS_C0011201" ON "LEAGUE" ("ID") ;

ALTER TABLE "COUNTRY" ADD PRIMARY KEY ("ID") USING INDEX  ENABLE;

ALTER TABLE "LEAGUE" ADD PRIMARY KEY ("ID") USING INDEX  ENABLE;
