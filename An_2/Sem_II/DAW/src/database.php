<?php
require_once "db_connect.php";
$conn = db_connect();

// function insert($table, $data)
// {
//    global $conn;
//    $fields = implode(", ", array_keys($data));
//    $values = implode(", ", array_map(function ($item) {
//       return "'$item'";
//    }, array_values($data)));
//    $sql = "INSERT INTO $table ($fields) VALUES ($values)";
//    if ($conn->query($sql) === TRUE) {
//       return $conn->insert_id;
//    } else {
//       echo "Error: " . $sql . "<br>" . $conn->error;
//       return false;
//    }
// }

function insert($table, $data)
{
   global $conn;

   // Prepare an array of placeholders and bind values.
   $placeholders = array();
   $bind_values = array();
   foreach ($data as $field => $value) {
      $placeholders[] = '?';
      $bind_values[] = $value;
   }

   // Create an SQL statement with placeholders.
   $fields = implode(", ", array_keys($data));
   $values = implode(", ", $placeholders);
   $sql = "INSERT INTO $table ($fields) VALUES ($values)";

   // Prepare the SQL statement.
   $stmt = $conn->prepare($sql);

   if ($stmt === false) {
      echo "Error: " . $conn->error;
      return false;
   }

   // Bind parameters and execute the statement.
   $stmt->bind_param(str_repeat('s', count($bind_values)), ...$bind_values);

   if ($stmt->execute() === TRUE) {
      return $conn->insert_id;
   } else {
      echo "Error: " . $stmt->error;
      return false;
   }
}


function update($table, $data, $id)
{
   global $conn;
   $setValues = implode(", ", array_map(function ($key, $value) {
      return "$key='$value'";
   }, array_keys($data), $data));
   $sql = "UPDATE $table SET $setValues WHERE id_$table=$id";
   if ($conn->query($sql) === TRUE) {
      return true;
   } else {
      echo "Error: " . $sql . "<br>" . $conn->error;
      return false;
   }
}

function delete($table, $id)
{
   global $conn;
   $sql = "DELETE FROM $table WHERE id_$table=$id";
   if ($conn->query($sql) === TRUE) {
      return true;
   } else {
      echo "Error: " . $sql . "<br>" . $conn->error;
      return false;
   }
}



$action = $_POST['action'];
$table = $_POST['table'];
if ($action == 'insert') {
   $data = $_POST;
   // remove action and table from data
   unset($data['action']);
   unset($data['table']);

   insert($table, $data);

   echo "S-au insertat urmatoarele date in tabela: $table";
   print_r($data);
} else if ($action == 'update') {
   $data = []; // Get data from $_POST
   $id = $_POST['id']; // Get id from $_POST
   update($table, $data, $id);
} else if ($action == 'delete') {
   $id = $_POST['id']; // Get id from $_POST
   delete($table, $id);
} else {
   echo "Invalid action.";
}
