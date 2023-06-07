<?php
session_start();
function getPageContents($url)
{
    $user_agent = 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0';
    $options = array(
        CURLOPT_CUSTOMREQUEST  => "GET",        //set request type post or get
        CURLOPT_POST           => false,        //set to GET
        CURLOPT_USERAGENT      => $user_agent, //set user agent
        CURLOPT_COOKIEFILE     => "cookie.txt", //set cookie file
        CURLOPT_COOKIEJAR      => "cookie.txt", //set cookie jar
        CURLOPT_RETURNTRANSFER => true,     // return web page
        CURLOPT_HEADER         => false,    // don't return headers
        CURLOPT_FOLLOWLOCATION => true,     // follow redirects
        CURLOPT_ENCODING       => "",       // handle all encodings
        CURLOPT_AUTOREFERER    => true,     // set referer on redirect
        CURLOPT_CONNECTTIMEOUT => 120,      // timeout on connect
        CURLOPT_TIMEOUT        => 120,      // timeout on response
        CURLOPT_MAXREDIRS      => 10,       // stop after 10 redirects
    );

    $ch = curl_init($url);
    curl_setopt_array($ch, $options);
    $content = curl_exec($ch);
    $err = curl_errno($ch);
    $errmsg = curl_error($ch);
    $header = curl_getinfo($ch);
    curl_close($ch);

    $header['errno'] = $err;
    $header['errmsg'] = $errmsg;
    $header['content'] = $content;
    return $content;
}

$output = getPageContents("https://coinmarketcap.com/");

// Use regular expressions to extract first div with class "sc-c9eecf69-0 ktISRC"
preg_match_all('#<div class="sc-c9eecf69-0 ktISRC">(.*?)</div></div><div class="sc-1a736df3-0 PimrZ cmc-body-wrapper#s', $output, $matches);

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
