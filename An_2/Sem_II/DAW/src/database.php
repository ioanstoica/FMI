<?php
require_once "db_connect.php";
$conn = db_connect();

function insert($table, $data)
{
   global $conn;
   $fields = implode(", ", array_keys($data));
   $values = implode(", ", array_map(function ($item) {
      return "'$item'";
   }, array_values($data)));
   $sql = "INSERT INTO $table ($fields) VALUES ($values)";
   if ($conn->query($sql) === TRUE) {
      return $conn->insert_id;
   } else {
      echo "Error: " . $sql . "<br>" . $conn->error;
      return false;
   }
}

function update($table, $data, $id)
{
   global $conn;
   $setValues = implode(", ", array_map(function ($key, $value) {
      return "$key='$value'";
   }, array_keys($data), $data));
   $sql = "UPDATE $table SET $setValues WHERE id=$id";
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
   $sql = "DELETE FROM $table WHERE id=$id";
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
   $data = []; // Get data from $_POST
   insert($table, $data);
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
