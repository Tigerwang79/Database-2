DROP TABLE Document CASCADE CONSTRAINTS;
CREATE TABLE Document (
reference int ,
titre varchar(50),
theme varchar(50),
id_editeur int,
CONSTRAINT PK_DOCUMENT PRIMARY KEY ( reference ) ,
constraint FK_document_editeur FOREIGN KEY ( id_editeur ) REFERENCES editeur ( editeurId )
) ;

DROP TABLE cd CASCADE CONSTRAINTS;
CREATE TABLE cd (
    cdId int,
    categorie varchar(5) default 'cd',
    documentId int,
    nombre_sous_titre int,
    duree timestamp,
    CONSTRAINT PK_CD PRIMARY KEY ( cdId )    
) ;

DROP TABLE DVD CASCADE CONSTRAINTS;
CREATE TABLE DVD (
dvdId int,
categorie varchar(5) default 'dvd',
documentId int,
duree timestamp,
CONSTRAINT PK_DVD PRIMARY KEY ( dvdId ) 
) ;


DROP TABLE Livre CASCADE CONSTRAINTS;
CREATE TABLE livre (
livreId int,
categorie varchar(5) default 'livre',
documentId int,
nombre_de_pages int,
CONSTRAINT PK_LIVRE PRIMARY KEY ( livreId ) 
) ;

DROP TABLE Video CASCADE CONSTRAINTS;
CREATE TABLE Video (
videoId int,
categorie varchar(5) default 'video',
documentId int,
duree timestamp,
format_video varchar(3),
CONSTRAINT PK_VIDEO PRIMARY KEY ( videoId ) 
) ;

Alter table document add id_categorie int;
Alter table document add constraint FK_document_CD FOREIGN KEY ( id_categorie ) REFERENCES cd ( cdId );
Alter table document add constraint FK_document_dvd FOREIGN KEY ( id_categorie ) REFERENCES dvd ( dvdId  );
Alter table document add constraint FK_document_livre FOREIGN KEY ( id_categorie ) REFERENCES livre ( livreId );
Alter table document add constraint FK_document_video FOREIGN KEY ( id_categorie ) REFERENCES video ( videoId );



DROP TABLE mots_cles CASCADE CONSTRAINTS;
CREATE TABLE mots_cles (
motclesId int,
mot varchar(30),
Constraint PK_MOTCLEF Primary key (motclesId)
) ;



Drop table liaisonMotDoc cascade CONSTRAINTS;
CREATE TABLE liaisonMotDoc (
liaisonId int,
motsId int,
docId int,
CONSTRAINTS PK_LIAISON PRIMARY KEY (liaisonId),
CONSTRAINT fk_liaison_mot FOREIGN KEY (motsId) REFERENCES mots_cles(motclesId),
CONSTRAINT fk_liaison_Doc FOREIGN KEY (docId) REFERENCES Document(reference)
);


DROP TABLE editeur CASCADE CONSTRAINTS;
CREATE TABLE editeur (
editeurId int ,
nom varchar(20),
adresse varchar(100),
numero_telephone NUMBER(10),
CONSTRAINT PK_EDITEUR PRIMARY KEY ( editeurId )
) ;

DROP TABLE auteur CASCADE CONSTRAINTS;
CREATE TABLE auteur (
auteurId int,
nom varchar(20),
prenom varchar(20),
date_de_naissance date,
CONSTRAINT PK_AUTEUR PRIMARY KEY ( auteurId ) 
) ;

Drop table liaisonAuteurDoc cascade CONSTRAINTS;
CREATE TABLE liaisonAuteurDoc (
liaisonId int,
auteurId int,
docId int,
CONSTRAINTS PK_liasonAD PRIMARY KEY (liaisonId),
CONSTRAINT fk_liaison_auteur FOREIGN KEY (auteurId) REFERENCES auteur(auteurId),
CONSTRAINT fk_liaison_Doc2 FOREIGN KEY (docId) REFERENCES Document(reference)
);

DROP TABLE categorie_emprunteur CASCADE CONSTRAINTS;
CREATE TABLE categorie_emprunteur (
categorie_emprunteurId int,
categorie varchar(20),
nombre_limite_emprunt int,
CONSTRAINT  PK_CATEGORIE_EMPRUNTEUR PRIMARY KEY ( categorie_emprunteurId )
) ;


DROP TABLE emprunteur CASCADE CONSTRAINTS;
CREATE TABLE emprunteur (
emprunteurId int,
id_categorie int,
nom varchar(20),
prenom varchar(20),
numero_telephone NUMBER(10),
adresse varchar(250), 
nb_emprunt int default 0,
CONSTRAINT PK_EMPRUNTEUR PRIMARY KEY ( emprunteurId ),
constraint FK_categorieEmprunteur_emprunteur FOREIGN KEY ( id_categorie ) REFERENCES categorie_emprunteur ( categorie_emprunteurId )
) ;


DROP TABLE exemplaire CASCADE CONSTRAINTS;
CREATE TABLE exemplaire (
exemplaireId int,
document int,
nombre_exemplaire int,
numero_rayon int,
CONSTRAINT PK_EXEMPLAIRE PRIMARY KEY ( exemplaireId ), 
CONSTRAINT FK_EXEMPLAIRE_DOCUMENT FOREIGN KEY (document) REFERENCES Document (Reference)
) ;

DROP TABLE Emprunt CASCADE CONSTRAINTS;
CREATE TABLE EMPRUNT (
    empruntId int,
    dateEmprunt date,
    dateRetour date, 
    exemplaire int, 
    emprunteur int, 
    CONSTRAINT PK_EMPRUNT PRIMARY KEY ( empruntId ),
    CONSTRAINT FK_EMPRUNT_EXEMPLAIRE FOREIGN KEY (exemplaire) REFERENCES exemplaire (exemplaireId),
    CONSTRAINT FK_EMPRUNT_EMPRUNTEUR FOREIGN KEY (emprunteur) REFERENCES Emprunteur (emprunteurId)    
);


--PARTIE 4

--trigger pour l'insertion dans la table exemplaire
create or replace Trigger trig_exemplaire
before insert on exemplaire
for each row
begin
    if :new.nombre_exemplaire < 1 then
    raise_application_error('-20001', 'il n y a pas d exemplaire disponible');
    end if;
End;
/

--trigger pour l'update de la table exemplaire pour qu'on en puisse pas prendre plus d'exmplaire que disponible
create or replace Trigger trig_exemplaire_update
before update on exemplaire
for each row
begin
    if :old.nombre_exemplaire + :new.nombre_exemplaire  < 1 then
    raise_application_error('-20001', 'il n y a pas d exemplaire disponible');
    end if;
End;
/
--Alter Trigger trig_exemplaire Enable;

--Update exemplaire set nombre_exemplaire = (nombre_exemplaire + 1) where exemplaireId = 1 ;
create or replace trigger trig_emprunt_insert
before insert on emprunt 
for each row
begin 
    update emprunteur set nb_emprunt = (nb_emprunt+1) where emprunteurId = :new.emprunteur;
    update exemplaire set nombre_exemplaire = nombre_exemplaire -1 where exemplaireId = :new.exemplaire;
end;
/

create or replace trigger trig_emprunt_update
before update on emprunt 
for each row 
begin 
    update emprunteur set nb_emprunt = nb_emprunt - 1 where emprunteurId = :old.emprunteur;
    update exemplaire set nombre_exemplaire = nombre_exemplaire +1 where exemplaireId = :new.exemplaire;

end;
/

create or replace trigger trig_emprunteur_update
before update on emprunteur 
for each row 
declare
    nb_limite int;
begin 
    select nombre_limite_emprunt into nb_limite from categorie_emprunteur where categorie_emprunteurId = :old.id_categorie;
    if(:old.nb_emprunt + 1 > nb_limite)
        then 
         raise_application_error('-20001', 'Vous ne pouvez pas emprunter plus de document !');
    end if;
end;
/
--drop trigger trig_emprunteur_update;



--PARTIE 5
--Remplissage de la base

 --DELETE ALL ROW
 DELETE FROM VIDEO;
 
 --INSERT VIDEO
INSERT INTO VIDEO (VIDEOID, documentId, DUREE, FORMAT_VIDEO)
 VALUES (1,18, TO_TIMESTAMP('02:12:37', 'HH24:MI:SS'), 'mp4')
 ;
 
INSERT INTO VIDEO (VIDEOID, documentId, DUREE, FORMAT_VIDEO)
 VALUES (2,16, TO_TIMESTAMP('01:47:47', 'HH24:MI:SS'), 'avi')
 ;
 
INSERT INTO VIDEO (VIDEOID, documentId, DUREE, FORMAT_VIDEO)
 VALUES (3,17, TO_TIMESTAMP('00:39:55', 'HH24:MI:SS'), 'mov')
 ;
 INSERT INTO VIDEO (VIDEOID, documentId, DUREE, FORMAT_VIDEO)
 VALUES (4,19, TO_TIMESTAMP('01:27:11', 'HH24:MI:SS'), 'mp4')
 ;
 
INSERT INTO VIDEO (VIDEOID, documentId, DUREE, FORMAT_VIDEO)
 VALUES (5,20, TO_TIMESTAMP('01:55:20', 'HH24:MI:SS'), 'mp4')
 ;
 
 --Selection de la durée
SELECT to_char( DUREE, 'HH24:MI:SS' )
  FROM VIDEO;
  
  
--DELETE ALL ROW
 --DELETE FROM LIVRE;
 
 --INSERT LIVRE
DELETE FROM LIVRE;
INSERT INTO LIVRE (LIVREID, documentId, NOMBRE_DE_PAGES)
 VALUES (1,11, '365')
 ;
 INSERT INTO LIVRE (LIVREID, documentId, NOMBRE_DE_PAGES)
 VALUES (2,12, '159')
 ;INSERT INTO LIVRE (LIVREID, documentId, NOMBRE_DE_PAGES)
 VALUES (3,13, '1752')
 ;
 INSERT INTO LIVRE (LIVREID, documentId, NOMBRE_DE_PAGES)
 VALUES (4,14, '205')
 ;
 INSERT INTO LIVRE (LIVREID, documentId, NOMBRE_DE_PAGES)
 VALUES (5,15, '55')
 ;
 
 --DELETE ALL ROW
 DELETE FROM CD;
 
 --INSERT CD
  INSERT INTO CD (CDID, documentId, NOMBRE_SOUS_TITRE, DUREE)
 VALUES (1,1, '13554' ,TO_TIMESTAMP('01:23:20', 'HH24:MI:SS'))
 ;
   INSERT INTO CD (CDID, documentId, NOMBRE_SOUS_TITRE, DUREE)
 VALUES (2,2, '1578' ,TO_TIMESTAMP('0:15:47', 'HH24:MI:SS'))
 ;
   INSERT INTO CD (CDID, documentId, NOMBRE_SOUS_TITRE, DUREE)
 VALUES (3,3, '7985' ,TO_TIMESTAMP('00:39:30', 'HH24:MI:SS'))
 ;
   INSERT INTO CD (CDID, documentId, NOMBRE_SOUS_TITRE, DUREE)
 VALUES (4,4, '32597' ,TO_TIMESTAMP('02:33:12', 'HH24:MI:SS'))
 ;
   INSERT INTO CD (CDID, documentId, NOMBRE_SOUS_TITRE, DUREE)
 VALUES (5,5, '645' ,TO_TIMESTAMP('00:09:39', 'HH24:MI:SS'))
 ;
 
 
 --DELETE ALL ROW
 DELETE FROM DVD;
 
 --INSERT DVD
  INSERT INTO DVD (DVDID, documentId, DUREE)
 VALUES (1,6, TO_TIMESTAMP('00:07:25', 'HH24:MI:SS'))
 ;
   INSERT INTO DVD (DVDID, documentId, DUREE)
 VALUES (2,7, TO_TIMESTAMP('02:06:29', 'HH24:MI:SS'))
 ;
   INSERT INTO DVD (DVDID, documentId, DUREE)
 VALUES (3,8, TO_TIMESTAMP('01:25:45', 'HH24:MI:SS'))
 ;
   INSERT INTO DVD (DVDID, documentId, DUREE)
 VALUES (4,9, TO_TIMESTAMP('00:55:23', 'HH24:MI:SS'))
 ;
   INSERT INTO DVD (DVDID, documentId, DUREE)
 VALUES (5,10, TO_TIMESTAMP('01:46:05', 'HH24:MI:SS'))
 ;
 
 --creation catégorie emprunteur 
DELETE FROM categorie_emprunteur;


INSERT INTO CATEGORIE_EMPRUNTEUR ( CATEGORIE_EMPRUNTEURID , CATEGORIE , NOMBRE_LIMITE_EMPRUNT ) VALUES ( 1 , 'PERSONNEL' , 10 ) ;
INSERT INTO CATEGORIE_EMPRUNTEUR ( CATEGORIE_EMPRUNTEURID , CATEGORIE , NOMBRE_LIMITE_EMPRUNT ) VALUES ( 2 , 'PROFESSIONNEL' , 5 ) ;
INSERT INTO CATEGORIE_EMPRUNTEUR ( CATEGORIE_EMPRUNTEURID , CATEGORIE , NOMBRE_LIMITE_EMPRUNT ) VALUES ( 3 , 'PUBLIC' , 3 ) ;


 --creation éditeur 
  DELETE FROM editeur;

  INSERT INTO EDITEUR (EDITEURID, NOM, ADRESSE, NUMERO_TELEPHONE)
  VALUES(1, 'Eyrolles', '25 rue de la paix, Cannes', '0585634155')
  ;  
 INSERT INTO EDITEUR (EDITEURID, NOM, ADRESSE, NUMERO_TELEPHONE)
  VALUES(2, 'Dunod', '255 rue de paris, Poitiers, CURAC', '0145783265')
  ;
  INSERT INTO EDITEUR (EDITEURID, NOM, ADRESSE, NUMERO_TELEPHONE)
  VALUES(3, 'Nathan', '32 avenue de la rochelle, Niort', '0415896533')
  ;
  INSERT INTO EDITEUR (EDITEURID, NOM, ADRESSE, NUMERO_TELEPHONE)
  VALUES(4, 'Universal musique', '78 rue de la cité, Paris', '0478325225')
  ;
  INSERT INTO EDITEUR (EDITEURID, NOM, ADRESSE, NUMERO_TELEPHONE)
  VALUES(5, 'Fox', '3669 rue de la New York, Springfield', '0448445632')
  ;
INSERT INTO EDITEUR (EDITEURID, NOM, ADRESSE, NUMERO_TELEPHONE)
  VALUES(6, 'Poket', '69 rue de la londre, Grenobles', '0341154544')
  ;
--creation auteur 
DELETE FROM AUTEUR;

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 1 , 'Metallica' , 'Metallica' , '15/08/1981' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 2 , 'Sia' , 'Sia' , '18/12/1975' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 3 , 'Cyrus' , 'Miley' , '23/11/1992' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 4 , 'IAM' , 'IAM' , '12/06/1988' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 5 , 'Punk' , 'Daft' , '25/05/1993' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 6 , 'Camus' , 'Albert' , '07/11/1913' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 7 , 'Poquelin' , 'Jean-Baptiste' , '15/01/1622' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 8 , 'Hugo' , 'Victor' , '26/02/1802' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 9 , 'Buzzati' , 'Dino' , '16/10/1906' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 10 , 'Remi' , 'Hergé' , '22/05/1907' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 11 , 'Gotaga' , 'Gotaga' , '07/09/1993' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 12 , 'Docteur' , 'Nozman' , '02/01/1990' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 13 , 'Dumas' , 'Michel' , '08/07/1949' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 14 , 'Grande' , 'Ariana' , '26/06/1993' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 15 , 'Minaj' , 'Nicki' , '08/12/1982' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 16 , 'J' , 'Jessie' , '27/03/1988' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 17 , 'Lipa' , 'Dua' , '22/08/1995' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 18 , 'Van Laeken' , 'Angèle' , '03/12/1995' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 19 , 'Squeezie' , 'Squeezie' , '27/01/1996' );

INSERT INTO AUTEUR (auteurid, nom, prenom, date_de_naissance) VALUES ( 20 , 'Mister' , 'V' , '14/08/1993' );


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--****** Création des 20 documents avec pour chaque document : 1 à 4 exemplaires et 1 à 3 auteurs : ******
DELETE FROM DOCUMENT;
INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 1 , 1 , 'Master Of Puppets' , 'Rock' , 1 ) ;
-- CD : Artiste(s)/Groupe = Metallica(Grp), Titre = Master Of Puppets, Thème = Rock, éditeur = 1

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 2 , 1 , 'Courage To Change' , 'Pop' , 1 ) ;
-- CD : Artiste(s)/Groupe = Sia(A), Titre = Courage To Change, Thème = Pop, éditeur = 2

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 3 , 1 , 'Wrecking Ball' , 'Pop' , 4 ) ;
-- CD : Artiste(s)/Groupe = Miley Cyrus(A), Titre = Wrecking Ball, Thème = Pop, éditeur = 3

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 4 , 1 , 'Je danse le Mia' , 'Rap' , 1 ) ;
-- CD : Artiste(s)/Groupe = IAM(Grp), Titre = Je danse le Mia, Thème = Pop, éditeur = 4

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 5 , 1 , 'Around the World' , 'Electro' , 4 ) ;
-- CD : Artiste(s)/Groupe = Daft Punk(Grp), Titre = Around the World, Thème = Electro, éditeur = 5

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 6 , 1 , 'Bang Bang' , 'Pop' , 4 ) ;
-- CD : Artiste(s)/Groupe = (Ariana Grande-Nicki Minaj- Jessie J), Titre = Around the World, Thème = Electro, éditeur = 5

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 7 , 1 , 'Fever' , 'Pop' , 1 ) ;
-- CD : Artiste(s)/Groupe = (Dua Lipa-Angèle), Titre = 'Fever', Thème = 'Pop', éditeur = 1

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 8 , 2 , '300' , 'péplum' , 5 ) ;
-- DVD : Artiste(s)/Groupe = ?(Grp), Titre = '300', Thème = 'péplum', éditeur = 5

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 9 , 2 , 'Shrek' , 'Animation' , 5 ) ;
-- DVD : Artiste(s)/Groupe = ?(Grp), Titre = 'Shrek', Thème = 'Animation', éditeur = 5

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 10 , 2 , 'Shutter Island' , 'Thriller' , 2 ) ;
-- DVD : Artiste(s)/Groupe = ?(Grp), Titre = 'Shutter Island', Thème = 'Thriller', éditeur = 2

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 11 , 2 , 'Gandhi' , 'Biographie' , 2 ) ;
-- DVD : Artiste(s)/Groupe = ?(Grp), Titre = 'Gandhi', Thème = 'Biographie', éditeur = 2

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 12 , 2 , 'Le Seigneurs des Anneaux' , 'Fantastique' , 5 ) ;
-- DVD : Artiste(s)/Groupe = ?(Grp), Titre = 'Le Seigneurs des Anneaux', Thème = 'Fantastique', éditeur = 5

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 13 , 3 , 'L étranger' , 'Roman' , 3 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'Le Seigneurs des Anneaux', Thème = 'Fantastique', éditeur = 5

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 14 , 3 , 'Les Fourberies de Scapin' , 'Pièce de Théâtre' , 6 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'Les Fourberies de Scapin', Thème = 'Pièce de Théâtre', éditeur = 6

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 15 , 3 , 'À une femme' , 'Poème' , 3 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'À une femme', Thème = 'Poème', éditeur = 3

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 16 , 3 , 'Le K' , 'Nouvelle' , 3 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'Le K', Thème = 'Nouvelle', éditeur = 3

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 17 , 3 , 'Les Aventures de Tintin' , 'Bande Dessinée' , 3 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'Les Aventures de Tintin', Thème = 'Bande Dessinée', éditeur = 3

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 18 , 3 , 'SQL pour les nuls' , 'Informatique' , 5 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'Informatique pour les nuls', Thème = 'Informatique', éditeur = 5

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 19 , 3 , 'Calcul matricielle' , 'Mathématiques' , 6 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'Calcul matricielle', Thème = 'Mathématique', éditeur = 6

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 20 , 3 , 'IA, un danger pour l humanité ?' , 'Informatique' , 7 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'IA un danger pour l humanié ?', Thème = 'Informatique', éditeur = 7

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 21 , 3 , 'Guinness World Record Mathématique 1998' , 'Mathématiques' , 7 ) ;
-- LIVRE : Artiste(s)/Groupe = ?(Grp), Titre = 'Guinness World Record Mathématique 1998', Thème = 'Mathématique', éditeur = 7

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 22 , 4 , 'Mon record sur Fortnite' , 'Vidéo Divertissement Youtube' , 7 ) ;
-- VIDEO : Artiste(s)/Groupe = Gotaga(Grp), Titre = 'Mon record sur Fortnite', Thème = 'Vidéo Youtube', éditeur = 7

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 23 , 4 , 'Le réchauffement climatique' , 'Vidéo Reportage Brut' , 8 ) ;
-- VIDEO : Artiste(s)/Groupe = ?(Grp), Titre = 'Le réchauffement climatique', Thème = 'Vidéo Brut', éditeur = 8

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 24 , 4 , 'Interview François Hollande' , 'Vidéo Interview Konbini' , 8 ) ;
-- VIDEO : Artiste(s)/Groupe = ?(Grp), Titre = 'Interview François Hollande', Thème = 'Vidéo Interview Konbini', éditeur = 8

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 25 , 4 , 'Cette Objet défie la gravité' , 'Vidéo Education Youtube' , 7 ) ;
-- VIDEO : Artiste(s)/Groupe = ?(Grp), Titre = 'Cette Objet défie la gravité', Thème = 'Vidéo Education Youtube', éditeur = 7

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 26 , 4 , 'Comment Faire un Mille Feuilles' , 'Vidéo Cuisine Youtube' , 9 ) ;
-- VIDEO : Artiste(s)/Groupe = ?(Grp), Titre = 'Comment Faire un Mille Feuilles', Thème = 'Vidéo Cuisine Youtube', éditeur = 9

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) VALUES ( 27 , 4 , 'Mission : Impossible vs Mission : Pas Possible' , 'Vidéo Humour Youtube' , 9 ) ;
-- VIDEO : Artiste(s)/Groupe = ?(Grp), Titre = 'Comment Faire un Mille Feuilles', Thème = 'Vidéo Cuisine Youtube', éditeur = 9

-- INFO :
-- ID cd = 1
-- ID dvd = 2 
-- ID livre = 3
-- ID video = 4


--Création des liaisonsAuteurDoc : 


INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 1 , 1 , 1 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 2 , 2 , 2 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 3 , 3 , 3 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 4 , 14 , 6 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 5 , 15 , 6 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 6 , 16 , 6 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 7 , 17 , 7 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 8 , 18 , 7 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 9 , 19 , 19 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 10 , 20 , 27 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 11 , 4 , 4 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 12 , 4 , 5 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 13 , 5 , 5 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 14 , 6 , 8 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 15 , 6 , 9 );

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 16 , 7 , 10);

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 17, 8, 11);

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 18, 9, 12 ) ;

INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 19 , 10, 12);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 20, 11, 13);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 21, 12, 4);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 22, 13, 14);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 23, 14, 14);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 24, 15, 14);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 25, 2, 15);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 26, 6, 16);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 27, 10, 17);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 28, 16, 18);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 29, 17, 19);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 30, 18, 20);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 31, 19, 21);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 32, 19, 22);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 33, 20, 23);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 34, 1, 23);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 35, 2, 24);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 36, 11, 24);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 37, 12, 25);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 38, 3, 26);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 39, 8, 27);
INSERT INTO LIAISONAUTEURDOC ( LIAISONID , AUTEURID , DOCID ) VALUES ( 40 , 14 , 5 ) ;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--****** Création des 15 emprunteurs : ****** 

--creation emprunteur
--DELETE ALL ROW
DELETE FROM EMPRUNTEUR;
 


INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE, ADRESSE ) VALUES ( 1 , 1 , 'Marquin' , 'Paul', 0666666666, '11 rue de la Marre' ) ;
 
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE, ADRESSE ) VALUES ( 2 , 1 , 'Dupont' , 'Frédéric' , 0688888888, '11 rue de la Marre') ;
 
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE, ADRESSE ) VALUES ( 3 , 1 , 'Rivière' , 'Lune' , 0699999999 , '24 avenue de Poitiers') ;
 
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE, ADRESSE ) VALUES ( 4 , 1 , 'Fleuve' , 'Clark' , 0600000000 , '255 impasse des rivières') ;
 
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE, ADRESSE ) VALUES ( 5 , 1 , 'Ruisseau' , 'Oliver' , 0711111111 , '45 rue des glières') ;
 
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 6 , 2 , 'Mont' , 'Brie' , 0722222222 , '8889 avenue de montparnasse') ;
 
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 7 , 2 , 'Ornement' , 'Will' , 0733333333 , '1 rue de paris') ;
 
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 8 , 2 , 'De Jarmin' , 'Donald' , 0633333333 , '45 rue des glières') ;
 
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 9 , 2 , 'Le Gredin' , 'Michelle' , 0644444444 , '22 impasse de la passe') ;
     
INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 10 , 2 , 'La Zagneux' , 'Céline' , 0744444444 , '166 avenue de la Rochelle') ;

INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 11 , 3 , 'Genbon' , 'Natalie' , 0655555555 , '55 rue de monaco') ;    

INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 12 , 3 , 'Amont' , 'James' , 0777777777 , '8889 avenue de montparnasse') ;

INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 13 , 3 , 'Robert' , 'De Montmirail' , 0982574218 , '2 rue de paris') ;

INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 14 , 3 , 'Mickael' , 'Delavega' , 0639780996 , '756 rue de la Mingollière') ;

INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 15 , 3 , 'Hans' , 'Ortega' , 0750946782 , '10 allées des allouettes') ;

INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 20 , 1 , 'Pierre' , 'Jean' , 0682184689, '13 allées des allouettes') ;

INSERT INTO EMPRUNTEUR ( EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE , ADRESSE) VALUES ( 21 , 2 , 'Robin' , 'Alexa' , 0778456535, '14 allées des Fierté') ;

--création exemplaire 

DELETE FROM Exemplaire;

INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(1,1,2,20);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(2,2,1,3);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(3,3,2,15);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(4,4,4,16);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(5,5,4,5);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(6,6,3,6);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(7,7,1,1);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(8,8,3,53);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(9,9,3,42);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(10,10,2,63);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(11,11,4,10);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(12,12,4,32);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(13,13,2,9);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(14,14,2,6);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(15,15,3,21);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(16,16,3,22);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(17,17,4,26);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(18,18,1,1);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(19,19,2,34);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(20,20,4,50);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(21,21,4,41);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(22,22,4,11);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(23,23,4,23);
INSERT INTO Exemplaire ( exemplaireId, document, nombre_exemplaire, numero_rayon) values(24,24,4,24);

--Création des emprunts : 
 
DELETE FROM EMPRUNT;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 1 , '06/08/2015' , NULL , 11 , 11 ) ;
update  EMPRUNT set dateretour = '13/02/2016' where emprunteur = 11 and exemplaire = 11;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 2 , '17/01/2015' , NULL , 10 , 4 ) ;
update  EMPRUNT set dateretour = '26/05/2016' where emprunteur = 4 and exemplaire = 10;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 3 , '17/01/2016' , NULL , 7 , 15 ) ;
update  EMPRUNT set dateretour = '04/04/2017' where emprunteur = 15 and exemplaire = 7;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 4 , '08/06/2016' , NULL , 4 , 10 ) ;
update  EMPRUNT set dateretour = '30/07/2016' where emprunteur = 10 and exemplaire = 4;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 5 , '22/03/2016' , NULL , 9 , 11 ) ;
update  EMPRUNT set dateretour = '17/08/2016' where emprunteur = 11 and exemplaire = 9;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 6 , '15/08/2017' , NULL , 19 , 6 ) ;
update  EMPRUNT set dateretour = '18/08/2017' where emprunteur = 6 and exemplaire = 19;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 7 , '02/11/2017' , NULL , 5 , 13 ) ;
update  EMPRUNT set dateretour = '18/01/2018' where emprunteur = 13 and exemplaire = 5;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 8 , '18/11/2018' , NULL , 3 , 2) ;
update  EMPRUNT set dateretour = '23/11/2018' where emprunteur = 2 and exemplaire = 3;


INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 9 , '28/07/2018' , NULL , 10 , 8 ) ;
update  EMPRUNT set dateretour = '19/02/2019' where emprunteur = 8 and exemplaire = 10;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 10 , '30/06/2019' , NULL , 16 , 11 ) ;
update  EMPRUNT set dateretour = '05/05/2021' where emprunteur = 11 and exemplaire = 16;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 11 , '19/12/2020' , NULL , 2 , 1 ) ;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 12 , '07/10/2020' , NULL , 13 , 5 ) ;
update  EMPRUNT set dateretour = '27/10/2020' where emprunteur = 5 and exemplaire = 13;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 13 , '25/08/2020' , NULL , 17 , 7 ) ;
update  EMPRUNT set dateretour = '14/09/2020' where emprunteur = 7 and exemplaire = 17;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 14 , '16/04/2020' , NULL , 1 , 11 ) ;
update  EMPRUNT set dateretour = '01/03/2021' where emprunteur = 11 and exemplaire = 1;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 15 , '01/03/2021' , NULL , 18 , 14 ) ;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES (16, '01/05/2021', NULL, 8, 12);
update emprunt set dateretour = '03/05/2021' where emprunteur = 12 and exemplaire = 8;

INSERT INTO EMPRUNT ( EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR ) VALUES ( 17, '01/02/2021',NULL, 10, 15);
update emprunt set dateretour = '05/02/2021' where emprunteur = 15  and exemplaire = 10;



-- Mécanisme de gestion d'ajouts simultanés de documents

START TRANSACTION ;

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) 
VALUES ( 28 , 2 , 'Avengers' , 'Film de Super Héro' , 2 ) ;

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) 
VALUES ( 29 , 3 , 'Vingt mille lieues sous les mers' , 'Roman d aventure' , 6 ) ;

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) 
VALUES ( 30 , 1 , 'New York' , 'RnB' , 1 ) ;

SAVEPOINT jalon1 ;

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) 
VALUES ( 31 , 2 , 'Avengers' , 'Film de Super Héro' , 2 ) ;

ROLLBACK TO SAVEPOINT jalon1 ;

INSERT INTO DOCUMENT (reference, id_categorie, titre, theme, id_editeur) 
VALUES ( 31 , 2 , 'La ligne verte' , 'Film Policier Fantastique' , 5 ) ;

COMMIT ;


-- Mécanisme de gestion de suppressions simultanés de documents

START TRANSACTION ;

DELETE FROM DOCUMENT
WHERE reference = 28
AND titre = 'Avengers' ;

DELETE FROM DOCUMENT
WHERE reference = 29
AND titre = 'Vingt mille lieues sous les mers' ;

DELETE FROM DOCUMENT
WHERE reference = 30
AND titre = 'New York' ;

SAVEPOINT jalon1 ;

DELETE FROM DOCUMENT
WHERE reference = 31
AND titre = 'Avengers' ;

ROLLBACK TO SAVEPOINT jalon1 ;

DELETE FROM DOCUMENT
WHERE reference = 31
AND titre = 'La ligne verte' ;

COMMIT ;


-- Mécanisme de gestion d'ajouts simultanés d'emprunts

START TRANSACTION ;

INSERT INTO EMPRUNT (EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR) 
VALUES ( 16 , '15/02/2018' , '25/03/2018' , 8 , 9 ) ;

INSERT INTO EMPRUNT (EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR) 
VALUES ( 17 , '03/01/2019' , '05/03/2019' , 21 , 11 ) ;

INSERT INTO EMPRUNT (EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR) 
VALUES ( 18 , '26/08/2017' , '09/07/2018' , 5 , 13 ) ;

SAVEPOINT jalon1 ;

INSERT INTO EMPRUNT (EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR) 
VALUES ( 19 , '19/06/2020' , '28/01/2019' , 20 , 14 ) ;

ROLLBACK TO SAVEPOINT jalon1 ;

INSERT INTO EMPRUNT (EMPRUNTID , DATEEMPRUNT , DATERETOUR , EXEMPLAIRE , EMPRUNTEUR) 
VALUES ( 19 , '03/10/2019' , '29/05/2020' , 14 , 10 ) ;

COMMIT ;


-- Mécanisme de gestion de suppressions simultanés d'emprunts

START TRANSACTION ;

DELETE FROM EMPRUNT
WHERE EMPRUNTID = 16
AND DATEEMPRUNT < DATERETOUR ;

DELETE FROM EMPRUNT
WHERE EMPRUNTID = 17
AND DATEEMPRUNT < DATERETOUR ;

DELETE FROM EMPRUNT
WHERE EMPRUNTID = 18
AND DATEEMPRUNT < DATERETOUR ;

SAVEPOINT jalon1 ;

DELETE FROM EMPRUNT
WHERE EMPRUNTID = 19
AND DATEEMPRUNT > DATERETOUR ;

ROLLBACK TO SAVEPOINT jalon1 ;

DELETE FROM EMPRUNT
WHERE EMPRUNTID = 19
AND DATEEMPRUNT < DATERETOUR ;

COMMIT ;


-- Mécanisme de gestion d'ajouts simultanés d'emprunteurs

START TRANSACTION ;

INSERT INTO EMPRUNTEUR (EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE) 
VALUES ( 16 , 1 , 'Joachim' , 'Junior', 0785531272 ) ;

INSERT INTO EMPRUNTEUR (EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE) 
VALUES ( 17 , 2 , 'Tony' , 'Jimmy', 0635489381 ) ;

INSERT INTO EMPRUNTEUR (EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE) 
VALUES ( 18 , 3 , 'Vicenzo' , 'Marcel', 0709167053 ) ;

SAVEPOINT jalon1 ;

INSERT INTO EMPRUNTEUR (EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE) 
VALUES ( 19 , 3 , 'Bertrand' , 'Gaspard', 0709167053 ) ;

ROLLBACK TO SAVEPOINT jalon1 ;

INSERT INTO EMPRUNTEUR (EMPRUNTEURID , ID_CATEGORIE , NOM , PRENOM , NUMERO_TELEPHONE) 
VALUES ( 19 , 3 , 'Bertrand' , 'Gaspard', 0614826910 ) ;

COMMIT ;


-- Mécanisme de gestion de suppressions simultanés d'emprunteurs

START TRANSACTION ;

DELETE FROM EMPRUNTEUR
WHERE EMPRUNTEURID = 16
AND NOM = 'Joachim' 
AND PRENOM = 'Junior'
AND NUMERO_TELEPHONE = 0785531272 ;

DELETE FROM EMPRUNTEUR
WHERE EMPRUNTEURID = 17
AND NOM = 'Tony' 
AND PRENOM = 'Jimmy'
AND NUMERO_TELEPHONE = 0635489381 ;

DELETE FROM EMPRUNTEUR
WHERE EMPRUNTEURID = 18
AND NOM = 'Vicenzo' 
AND PRENOM = 'Marcel'
AND NUMERO_TELEPHONE = 0709167053 ;

SAVEPOINT jalon1 ;

DELETE FROM EMPRUNTEUR
WHERE EMPRUNTEURID = 19
AND NOM = 'Bertrand' 
AND PRENOM = 'Gaspard'
AND NUMERO_TELEPHONE = 0709167053 ;

ROLLBACK TO SAVEPOINT jalon1 ;

DELETE FROM EMPRUNTEUR
WHERE EMPRUNTEURID = 19
AND NOM = 'Bertrand' 
AND PRENOM = 'Gaspard'
AND NUMERO_TELEPHONE = 0614826910 ;

COMMIT ;



--PEUT ETRE EN RAJOUTER ?
DELETE FROM MOTS_CLES;
 
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 1, 'Musique') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 2, 'Pop') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 3, 'Rock') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 4, 'Rap') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 5, 'Film') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 6, 'Action') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 7, 'Animation') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 8, 'Guerre') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 9, 'Comique') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 10, 'Roman') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 11, 'Théatre') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 12, 'Fantaisie') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 13, 'BD') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 14, 'Mathématiques') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 15, 'Informatique') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 16, 'IA') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 17, 'Records') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 18, 'YT') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 19, 'Dicertissement') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 20, 'Vidéo') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 21, 'Climat') ;
INSERT INTO MOTS_CLES ( MOTCLESID , MOT) VALUES ( 22, 'Président') ;

---ATTENTION PAS FINI LES ID
DELETE FROM LIAISONMOTDOC;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 1, 1, 1) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 2, 2, 1) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 3, 1, 2) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 4, 2, 2) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 5, 1, 3) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 6, 2, 3) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 7, 1, 4) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 8, 3, 4) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 9, 5, 6) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 10, 6, 6) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 11, 8, 6) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 12, 5, 7) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 13, 7, 7) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 14, 5, 8) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 15, 6, 8) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 16, 10, 11) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 17, 11, 12);
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES (29,15,12) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 18, 14, 17);
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES (27,15,17);
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES (28,16,17);
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 19, 16, 18);
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES (25,15,18)  ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 20, 15, 18) ;

INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 21, 14, 19) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 22, 19, 19) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 23, 16, 20);
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES (26,15,20) ;
INSERT INTO LIAISONMOTDOC ( LIAISONID, MOTSID, DOCID) VALUES ( 24, 19, 20) ;

--Requêtes 
--19)
/*Select distinct d.titre
from mots_cles m1, mots_cles m2, liaisonmotdoc l, document d, liaisonmotdoc ll, document dd

where m1.motclesid = l.motsid and d.reference = l.docid
and m2.motclesid = ll.motsid and dd.reference = ll.docid and dd.titre = 'Wrecking Ball'
and m1.mot = m2.mot and d.titre != 'Wrecking Ball'

group by d.titre
having count(m1.mot) >= count(m2.mot)
;


Select mots_cles.mot
from mots_cles
inner join liaisonmotdoc on liaisonmotdoc.motsid = mots_cles.motclesid 
inner join document on document.reference = liaisonmotdoc.docid
minus
Select mots_cles.mot
from mots_cles
inner join liaisonmotdoc on liaisonmotdoc.motsid = mots_cles.motclesid 
inner join document on document.reference = liaisonmotdoc.docid
where document.titre = 'Wrecking Ball'
;
*/

--18)


Select distinct document.titre
from mots_cles
inner join liaisonmotdoc on liaisonmotdoc.motsid = mots_cles.motclesid 
inner join document on document.reference = liaisonmotdoc.docid 
where document.titre != 'SQL pour les nuls' and mots_cles.mot in(
        Select mots_cles.mot
        from mots_cles
        inner join liaisonmotdoc on liaisonmotdoc.motsid = mots_cles.motclesid 
        inner join document on document.reference = liaisonmotdoc.docid
        where document.titre = 'SQL pour les nuls'
);


--17)
Select mots_cles.mot
from mots_cles
inner join liaisonmotdoc on liaisonmotdoc.motsid = mots_cles.motclesid 
inner join document on document.reference = liaisonmotdoc.docid
minus
Select mots_cles.mot
from mots_cles
inner join liaisonmotdoc on liaisonmotdoc.motsid = mots_cles.motclesid 
inner join document on document.reference = liaisonmotdoc.docid
where document.titre = '300'
;




--16)

Select editeur.editeurid, count(*)
From editeur 
inner join document on document.id_editeur = editeur.editeurid
inner join exemplaire on exemplaire.exemplaireid = document.reference
inner join emprunt on emprunt.empruntid = exemplaire.exemplaireid
group by editeur.editeurid
having count(*)=(

Select max(count(*))
From editeur 
inner join document on document.id_editeur = editeur.editeurid
inner join exemplaire on exemplaire.exemplaireid = document.reference
inner join emprunt on emprunt.empruntid = exemplaire.exemplaireid
group by editeur.editeurid

);

--15)
select AUTEUR.NOM
from AUTEUR
inner join LIAISONAUTEURDOC on LIAISONAUTEURDOC.AUTEURID = AUTEUR.AUTEURID
inner join DOCUMENT on DOCUMENT.REFERENCE = LIAISONAUTEURDOC.LIAISONID
where DOCUMENT.THEME = 'Informatique'
;

--14)
--avg = 2.7


Select document.titre, e1.nombre_exemplaire
from exemplaire e1
inner join document on e1.exemplaireid = document.reference
where e1.nombre_exemplaire > (select AVG(e2.nombre_exemplaire) as avg_e2 from exemplaire e2)
;

--13)
select emprunteur.nom, emprunteur.prenom
from emprunteur
inner join categorie_emprunteur on categorie_emprunteur.categorie_emprunteurid = emprunteur.id_categorie
inner join emprunt on emprunt.emprunteur = emprunteur.emprunteurid
inner join exemplaire on exemplaire.exemplaireid = emprunt.exemplaire
inner join document on document.reference = exemplaire.document
inner join dvd on dvd.dvdid = document.id_categorie
where categorie_emprunteur.categorie = 'professionnel' and sysdate-emprunt.dateemprunt>182
;

--12)
select document.titre, document.reference
from document 
minus
select document.titre, document.reference
from emprunt
inner join document on document.reference = emprunt.exemplaire
;

--11)
select emprunteur.nom, emprunteur.emprunteurId
from emprunteur
minus
select emprunteur.nom, emprunteur.emprunteurId
from emprunt
inner join emprunteur on emprunteur.emprunteurid = emprunt.emprunteur
;

--10)
select editeur.nom
from editeur
inner join document on document.id_editeur = editeur.editeurid
minus
select editeur.nom
from editeur
inner join document on document.id_editeur = editeur.editeurid
where document.theme = 'Informatique'
;

--9)
select emprunteur.nom
from emprunteur
where emprunteur.adresse in (
    select emprunteur.adresse
    from emprunteur
    where emprunteur.nom = 'Dupont'
)
;
--8)
select editeur.nom
from editeur
inner join document on document.id_editeur = editeur.editeurid
inner join liaisonmotdoc on liaisonmotdoc.docid = document.reference
inner join mots_cles on mots_cles.motclesid = liaisonmotdoc.motsid
where mots_cles.mot = 'Informatique' or mots_cles.mot = 'Mathématiques'
group by editeur.nom
having count(editeur.nom) >= 2
;

--7)
select document.titre, count(document.titre) as Nombre_Emprunt
from exemplaire
inner join emprunt on emprunt.exemplaire = exemplaire.exemplaireid
inner join document on document.reference = exemplaire.document
group by document.titre
;

--6)
select editeur.nom, count(document.titre)
from emprunt
inner join exemplaire on exemplaire.exemplaireid = emprunt.exemplaire
inner join document on document.reference = exemplaire.document
inner join editeur on editeur.editeurid = document.id_editeur
where emprunt.dateretour is not NULL
group by editeur.nom
;


--5)
select exemplaire.nombre_exemplaire
from exemplaire
inner join document on document.reference = exemplaire.document
inner join editeur on editeur.editeurid = document.id_editeur
where editeur.nom = 'Eyrolles'
;

--4)
select auteur.nom
from editeur
inner join document on document.reference = editeur.editeurid
inner join liaisonauteurdoc on liaisonauteurdoc.auteurid = document.reference
inner join auteur on auteur.auteurid = liaisonauteurdoc.auteurid
where editeur.nom = 'Dunod'
;

--3)
select emprunteur.nom, document.titre, auteur.nom
from emprunt
inner join exemplaire on exemplaire.exemplaireid = emprunt.exemplaire
inner join emprunteur on emprunteur.emprunteurId = emprunt.emprunteur
inner join document on document.reference = exemplaire.document
inner join liaisonauteurdoc on document.reference = liaisonauteurdoc.docid
inner join auteur on liaisonauteurdoc.auteurid = auteur.auteurId
;

--2)

select document.titre, document.theme
from emprunteur
inner join emprunt on emprunt.emprunteur = emprunteur.emprunteurid
inner join exemplaire on exemplaire.exemplaireid = emprunt.exemplaire
inner join document on document.reference = exemplaire.document
where emprunteur.nom = 'Dupont' and emprunt.dateemprunt  > '15/11/2018' and 
emprunt.dateemprunt < '15/11/2019' 
;

--1)
select titre from document where theme = 'Informatique' or theme = 'Mathématiques' order by titre asc ;