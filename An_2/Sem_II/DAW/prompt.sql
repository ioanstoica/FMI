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
Avand mai jos schema tabelelor, scrie cate un formular custon pentru fiecare dintre cele 4 tabele.

Se dorește implementarea operațiilor de insert, delete, update pe baza de date definită 
la I  (fără  tabelul  de  utilizatori). Se  dorește  reutilizarea  codului  pentru  scenarii 
asemănătoare (nu definesc câte o pagină pentru fiecare tabel etc.). 

Avem o pagina template.php care genereaza iti ofera optiunea sa alegi intre
'Hotle' , 'Rezervare', 'Camera'  si 'Cazare' si creeaza 3 formulare diferit html 
(pentru insert, update si delete) in functie
de optiunea aleasa. Formularele apeleaza in spate metodele specifice din fisierul database.php

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


-- fisierul src/database.php
<?php
require_once "db_connect.php";
$conn = db_connect();

function insert($table, $data) {
    global $conn;
    $fields = implode(", ", array_keys($data));
    $values = implode(", ", array_map(function($item) { return "'$item'"; }, array_values($data)));
    $sql = "INSERT INTO $table ($fields) VALUES ($values)";
    if ($conn->query($sql) === TRUE) {
        return $conn->insert_id;
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
        return false;
    }
}

function update($table, $data, $id) {
    global $conn;
    $setValues = implode(", ", array_map(function($key, $value) { return "$key='$value'"; }, array_keys($data), $data));
    $sql = "UPDATE $table SET $setValues WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        return true;
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
        return false;
    }
}

function delete($table, $id) {
    global $conn;
    $sql = "DELETE FROM $table WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        return true;
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
        return false;
    }
}

-- fisierul template.php
<!DOCTYPE html>
<html>
<head>
    <title>Database Management</title>
</head>
<body>
    <form method="post">
        <select name="table">
            <option value="">-- Select an Option --</option>
            <option value="hotel">Hotel</option>
            <option value="rezervare">Rezervare</option>
            <option value="camera">Camera</option>
            <option value="cazare">Cazare</option>
        </select>
        <input type="submit" name="submit" value="Select"/>
    </form>

    <?php
    if (isset($_POST['table'])) {
        $table = $_POST['table'];
        echo "<h2>Working on: $table</h2>";
        // Generate forms
        echo "<h3>Insert Form</h3>";
        // You should customize your form fields according to the selected table
        echo "
        <form method='post' action='database.php?action=insert'>
            <!-- Custom Fields Here -->
            <input type='submit' value='Insert'>
        </form>";

        echo "<h3>Update Form</h3>";
        echo "
        <form method='post' action='database.php?action=update'>
            <!-- Custom Fields Here -->
            <input type='submit' value='Update'>
        </form>";

        echo "<h3>Delete Form</h3>";
        echo "
        <form method='post' action='database.php?action=delete'>
            <!-- Custom Fields Here -->
            <input type='submit' value='Delete'>
        </form>";
    }
    ?>
</body>
</html>


-- ex3
Scrie un formular html, care sa corespunda tabele de mai jos:

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

pe modelul:
<form method="post" action="database.php?action=insert">
               <input type="hidden" name="table" value="hotel">
               <input type="hidden" name="action" value="insert">
               
               <label for="denumire">Denumire:</label>
               <input type="text" id="denumire" name="denumire" required>
               
               <label for="zona">Zona:</label>
               <input type="text" id="zona" name="zona">
               
               <label for="judet">Judet:</label>
               <input type="text" id="judet" name="judet">
               
               <label for="localitate">Localitate:</label>
               <input type="text" id="localitate" name="localitate">
               
               <label for="numar_stele">Numar Stele:</label>
               <input type="number" id="numar_stele" name="numar_stele">
               
               <input type="submit" value="Insert">
               </form>

CREATE TABLE HOTEL (
   ID_HOTEL INT AUTO_INCREMENT,
   DENUMIRE VARCHAR(255) NOT NULL,
   ZONA VARCHAR(255),
   JUDET VARCHAR(255),
   LOCALITATE VARCHAR(255),
   NUMAR_STELE INT,
   PRIMARY KEY (ID_HOTEL)
);