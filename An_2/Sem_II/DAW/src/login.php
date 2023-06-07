<?php

require_once "db_connect.php";
$conn = db_connect();

// Get the form data
$email = $_POST["email"];
$password = $_POST["password"];

// Check if the user exists
$sql = "SELECT password FROM users WHERE email='$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // User exists
    $row = $result->fetch_assoc();
    if (password_verify($password, $row["password"])) {
        session_start();
        $_SESSION["email"] = $email;
        echo "Welcome back, $email" . "<br>";
    } else {
        // Wrong password
        echo "Wrong password";
    }
} else {
    // User does not exist
    echo "No such user";
}

// Close the database connection
$conn->close();

echo '<br><br><a href="/index.php">Back</a>';
