<?php

function db_connect()
{
    // Connect to the database
    $servername = "eu-cdbr-west-03.cleardb.net";
    $username = "bf1c9cef8d15c7";
    $password = "279489ec";
    $dbname = "heroku_16f0eed67d2b78d";

    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    return $conn;
}
