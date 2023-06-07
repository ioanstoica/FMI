<?php
session_start();

echo '<html>';

echo '
<head>
    <title>CryptoShop</title>
</head>';

echo '<body>';

echo '<h1>Wellcome to CryptoShop</h1>';

if (isset($_SESSION["email"])) {
    echo 'User: ' . $_SESSION["email"] . '<br>';
} else {
    echo 'User: Guest<br>';
}

echo '<a href="/src/login.html">Signup/Login</a><br>
    <a href="/src/logout.php">Logout</a><br>
    <a href="/src/contact.html">Contact</a><br>
    <a href="/src/news.php">News</a><br>
    <a href="/src/market.php"> Market</a><br>';

if (isset($_SESSION["email"])) {
    echo  '<a href="/src/generate_raport.php">Generate raport</a><br>';
}
if (isset($_SESSION["email"])) {
    // extract role for curent user
    require_once "src/db_connect.php";
    $conn = db_connect();
    $sql = "SELECT role FROM users WHERE email='" . $_SESSION["email"] . "'";
    $result = $conn->query($sql);
    $row = $result->fetch_assoc();
    $role = $row["role"];

    if ($role == "admin") {
        echo  '<a href="/src/crud.html">CRUD users</a><br>';
    }

    // Close the database connection
    $conn->close();
}

echo '<br><br>';

echo 'Real time data:<br>';
// If a match is found, print the contents of the div
if (!empty($matches[1])) {
    echo $matches[1][0];
} else {
    echo "No data from coinmarketcap.com...";
}


echo '</body>';

echo '</html>';
