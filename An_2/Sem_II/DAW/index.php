<?php
session_start();

echo '<html>';

echo '
<head>
    <title>MyPage</title>
</head>';

echo '<body>';

echo '<h1>Wellcome to MyPage</h1>';

if (isset($_SESSION["email"])) {
    echo 'User: ' . $_SESSION["email"] . '<br>';
} else {
    echo 'User: Guest<br>';
}

echo '<a href="/src/login.html">Signup/Login</a><br>
    <a href="/src/logout.php">Logout</a><br>';



echo '</body>';

echo '</html>';
