<?php
    // lab 3
    // comunicare in lan
    echo "<p> Salut, acesta este serverul lui Ioan! <p> ";

    $ipadress = getenv('REMOTE_ADDR');
    echo "Adresa ta ip este: $ipadress\n";

    # if ip is 192.168.43.155 echo "Salut, Stefan!";
    if ($ipadress == "192.168.43.155") {
        echo "Salut, Stefan!";
    }

    echo "x";
?>