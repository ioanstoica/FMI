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
      <input type="submit" name="submit" value="Select" />
   </form>

   <?php
   // if user is not logged in, redirect to login.php
   session_start();
   if (!isset($_SESSION["email"])) {
      header("Location: /src/login.html");
      exit();
   }

   if (isset($_POST['table'])) {
      $table = $_POST['table'];
      echo "<h2>Working on: $table</h2>";
      // Generate forms
      echo "<h3>Insert Form</h3>";
      switch ($table) {
         case 'hotel':
            echo '<form method="post" action="database.php?action=insert">
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
               
               <h3>Update Form</h3>
               <form method="post" action="database.php?action=update">
               <input type="hidden" name="table" value="hotel">
               <input type="hidden" name="action" value="update">
               
               <label for="id">ID:</label>
               <input type="number" id="id" name="id" required>
               
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
               
               <input type="submit" value="Update">
               </form>
               <h3>Delete</h3>
               
               <form method="post" action="database.php?action=delete">
               <input type="hidden" name="table" value="hotel">
               <input type="hidden" name="action" value="delete">

               <label for="id">ID:</label>
               <input type="number" id="id" name="id" required>

               <input type="submit" value="Delete">
               </form>
';
            break;
         case 'rezervare':
            echo '
            <form method="post" action="database.php?action=insert">
            <input type="hidden" name="table" value="rezervare">
            <input type="hidden" name="action" value="insert">
            
            <label for="data_sosire">Data Sosire:</label>
            <input type="date" id="data_sosire" name="data_sosire" required>
            
            <label for="data_plecare">Data Plecare:</label>
            <input type="date" id="data_plecare" name="data_plecare" required>
            
            <label for="persoana_contact">Persoana Contact:</label>
            <input type="text" id="persoana_contact" name="persoana_contact" required>
            
            <label for="telefon">Telefon:</label>
            <input type="text" id="telefon" name="telefon">
            
            <input type="submit" value="Insert">
        </form>
        ';
            break;
         case 'camera':
            echo '<form method="post" action="database.php?action=insert">
            <input type="hidden" name="table" value="camera">
            <input type="hidden" name="action" value="insert">
            
            <label for="numar">Numar:</label>
            <input type="number" id="numar" name="numar" required>
            
            <label for="etaj">Etaj:</label>
            <input type="number" id="etaj" name="etaj" required>
            
            <label for="observatii">Observatii:</label>
            <textarea id="observatii" name="observatii"></textarea>
            
            <label for="id_hotel">ID Hotel:</label>
            <input type="number" id="id_hotel" name="id_hotel">
            
            <label for="tarif_pe_noapte">Tarif pe Noapte:</label>
            <input type="number" id="tarif_pe_noapte" name="tarif_pe_noapte" step="0.01" required>
            
            <input type="submit" value="Insert">
        </form>
        ';
            break;
         case 'cazare':
            echo  '<form method="post" action="database.php?action=insert">
            <input type="hidden" name="table" value="cazare">
            <input type="hidden" name="action" value="insert">
            
            <label for="data_sosire">Data Sosire:</label>
            <input type="date" id="data_sosire" name="data_sosire" required>
            
            <label for="data_plecare">Data Plecare:</label>
            <input type="date" id="data_plecare" name="data_plecare" required>
            
            <label for="id_rezervare">ID Rezervare:</label>
            <input type="number" id="id_rezervare" name="id_rezervare">
            
            <label for="id_camera">ID Camera:</label>
            <input type="number" id="id_camera" name="id_camera">
            
            <input type="submit" value="Insert">
        </form>
        ';
            break;
      }

      // Similar switch cases can be used for update and delete forms
   }
   ?>
</body>

</html>