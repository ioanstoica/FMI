<?php

// Connect to the database using db_connect.php
require_once "db_connect.php";
$conn = db_connect();

// Get the form data
$email = $_POST["email"];
$password = $_POST["password"];


// Hash the password
$password = password_hash($password, PASSWORD_DEFAULT);

// Insert the new user into the users table
$sql = "INSERT INTO users (email, password) VALUES ('$email', '$password')";
if ($conn->query($sql) === TRUE) {
    echo "Signup successful! Welcome $email";
    session_start();
    $_SESSION["username"] = $email;
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

// Close the database connection
$conn->close();

echo '<br><br><a href="/index.php">Back</a>';
