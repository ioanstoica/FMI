<?php

// Connect to the database using db_connect.php
require_once "db_connect.php";
$conn = db_connect();

require $_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php';

// Get the form data
$email = $_POST["email"];
$password = $_POST["password"];

// echo a form to enter the verification code
echo '<form action="" method="post">
    <input type="text" name="code" placeholder="Enter the verification code">
    <input type="hidden" name="email" value="' . $email . '">
    <input type="hidden" name="password" value="' . $password . '">
    <input type="submit" value="Verify">';

// Close the database connection
$conn->close();

echo '<br><br><a href="/index.php">Back</a>';
