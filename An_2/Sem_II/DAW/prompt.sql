-- ex 1
Implementați  schema  relațională  transmisă  în  MySQL.  Este  obligatoriu  să  aveți 
adăugate cheile  primare  și cheile externe. Pot fi implementate constrângeri 
suplimentare.

rezervare(id_rezervare,data_sosire,data_plecare,persoana_contact,telefon);
hotel(id_hotel,denumire,zona,judet,localitate,numar_stele);
camera(id_camera,numar,etaj,observatii,id_hotel,tarif_pe_noapte);
cazare(id_cazare,data_sosire,data_plecare,id_rezervare,id_camera);	

user(id_user, email, parola);


-- ex 2
Autentificare/Înregistrare (2p):
Creati un site in php. La accesarea site-ului (home page) să se încarce un formular care să permită autentificarea utilizatorilor definiți sau înregistrarea unui nou utilizator. Accesul la orice alta pagină a unui utilizator neautentificat trebuie sa fie restricționat.
Obs: trebuie restricționată retransmiterea datelor folosite la înregistrare;

-- tabela de users
CREATE TABLE users (
    id_user INT AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_user),
    UNIQUE (email)
);




-- ex 3  
Se dorește implementarea operațiilor de insert, delete, update pe baza de date definită 
la I  (fără  tabelul  de  utilizatori). Se  dorește  reutilizarea  codului  pentru  scenarii 
asemănătoare (nu definesc câte o pagină pentru fiecare tabel etc.). 

-- I. Schema examen
CREATE TABLE HOTEL (
   ID_HOTEL INT AUTO_INCREMENT,
   DENUMIRE VARCHAR(255) NOT NULL,
   ZONA VARCHAR(255),
   JUDET VARCHAR(255),
   LOCALITATE VARCHAR(255),
   NUMAR_STELE INT,
   PRIMARY KEY (ID_HOTEL)
);

CREATE TABLE REZERVARE (
   ID_REZERVARE INT AUTO_INCREMENT,
   DATA_SOSIRE DATE NOT NULL,
   DATA_PLECARE DATE NOT NULL,
   PERSOANA_CONTACT VARCHAR(255) NOT NULL,
   TELEFON VARCHAR(20),
   PRIMARY KEY (ID_REZERVARE)
);

CREATE TABLE CAMERA (
   ID_CAMERA INT AUTO_INCREMENT,
   NUMAR INT NOT NULL,
   ETAJ INT NOT NULL,
   OBSERVATII TEXT,
   ID_HOTEL INT,
   TARIF_PE_NOAPTE DECIMAL(10, 2) NOT NULL,
   PRIMARY KEY (ID_CAMERA),
   FOREIGN KEY (ID_HOTEL) REFERENCES HOTEL(ID_HOTEL)
);

CREATE TABLE CAZARE (
   ID_CAZARE INT AUTO_INCREMENT,
   DATA_SOSIRE DATE NOT NULL,
   DATA_PLECARE DATE NOT NULL,
   ID_REZERVARE INT,
   ID_CAMERA INT,
   PRIMARY KEY (ID_CAZARE),
   FOREIGN KEY (ID_REZERVARE) REFERENCES REZERVARE(ID_REZERVARE),
   FOREIGN KEY (ID_CAMERA) REFERENCES CAMERA(ID_CAMERA)
);


-- ex 4  
