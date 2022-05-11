CREATE TABLE "TEAM" ("ID" NUMBER(*,0), "TEAM_API_ID" NUMBER(*,0), "TEAM_FIFA_API_ID" NUMBER(*,0), "TEAM_LONG_NAME" VARCHAR2(100), "TEAM_SHORT_NAME" VARCHAR2(100)) ;

Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9538,9830,71,'FC Nantes','NAN');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9539,9827,59,'Girondins de Bordeaux','BOR');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9540,7819,210,'SM Caen','CAE');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9542,9831,72,'OGC Nice','NIC');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9544,8689,217,'FC Lorient','LOR');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9545,9748,66,'Olympique Lyonnais','LYO');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9546,9941,1809,'Toulouse FC','TOU');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9547,9829,69,'AS Monaco','MON');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9548,9847,73,'Paris Saint-Germain','PSG');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9550,8639,65,'LOSC Lille','LIL');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9551,9851,74,'Stade Rennais FC','REN');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9552,8592,219,'Olympique de Marseille','MAR');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (9556,9853,1819,'AS Saint-?tienne','ETI');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (10309,10249,70,'Montpellier H?rault SC','MON');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (12587,9837,379,'Stade de Reims','REI');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (12594,7794,58,'SC Bastia','BAS');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (12595,10242,294,'ES Troyes AC','TRO');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (13343,9747,62,'En Avant de Guingamp','GUI');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (14868,8121,1530,'Angers SCO','ANG');
Insert into TEAM (ID,TEAM_API_ID,TEAM_FIFA_API_ID,TEAM_LONG_NAME,TEAM_SHORT_NAME) values (14876,6391,110316,'GFC Ajaccio','GAJ');


CREATE UNIQUE INDEX "SYS_C0011203" ON "TEAM" ("ID") ;


ALTER TABLE "TEAM" ADD PRIMARY KEY ("ID") USING INDEX  ENABLE;