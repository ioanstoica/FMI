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
               </form>';
            break;
         case 'rezervare':
            echo "
                <form method='post' action='database.php?action=insert'>
                    <input type='hidden' name='table' value='rezervare'>
                    <label for='data_sosire'>Data Sosire:</label>
                    <input type='date' id='data_sosire' name='data_sosire'>
                    <!-- Add more fields as required -->
                    <input type='submit' value='Insert'>
                </form>";
            break;
         case 'camera':
            echo "
                <form method='post' action='database.php?action=insert'>
                    <input type='hidden' name='table' value='camera'>
                    <label for='numar'>Numar:</label>
                    <input type='number' id='numar' name='numar'>
                    <!-- Add more fields as required -->
                    <input type='submit' value='Insert'>
                </form>";
            break;
         case 'cazare':
            echo "
                <form method='post' action='database.php?action=insert'>
                    <input type='hidden' name='table' value='cazare'>
                    <label for='data_sosire'>Data Sosire:</label>
                    <input type='date' id='data_sosire' name='data_sosire'>
                    <!-- Add more fields as required -->
                    <input type='submit' value='Insert'>
                </form>";
            break;
      }

      // Similar switch cases can be used for update and delete forms
   }
   ?>
</body>

</html>