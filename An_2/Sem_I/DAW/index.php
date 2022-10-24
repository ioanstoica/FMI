<?php
    echo "<p> Salut, acesta este serverul lui Ioan! <p> ";

    $ipadress = getenv('REMOTE_ADDR');
    echo "Adresa ta ip este: $ipadress\n";

    # if ip is 192.168.43.155 echo "Salut, Stefan!";
    if ($ipadress == "192.168.43.155") {
        echo "Salut, Stefan!";
    }

    echo "x";
    
    // $servername = "localhost"; 
    // $username = "root"; 
    // $password = "87654321";

    // // Create connection
    // $conn = new mysqli($servername, $username, $password, "daw");

    // // Check connection
    // if ($conn->connect_error) {
    //     die("Connection failed: " . $conn->connect_error);
    // }
    // echo "Connected successfully";

    // // select * from persoane
    // $sql = "SELECT * FROM persoane";
    // $result = $conn->query($sql);
    // echo $result->num_rows;

    // // echo every rows from persoane
    // if ($result->num_rows > 0) {
    // // output data of each row
    // while($row = $result->fetch_assoc()) {
    //     echo "id: " . $row["id"]. " - Name: " . $row["nume"]. " " . $row["prenume"]. "<br>";
    // }
    // } else {
    //     echo "0 results";
    // }

    // $sql = "INSERT INTO persoane (nume, prenume) values ('Popescu', 'Ion')";
    // if ($conn->query($sql) === TRUE) {
    //     echo "New record created successfully";
    // } else {
    // echo "Error: " . $sql . "<br>" . $conn->error;
    // }

    // $conn->close();

?>