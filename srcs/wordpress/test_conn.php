<?php

    $conn = mysqli_connect('mariadb', 'user', 'pwduser', 'wordpress');
    
    if (!$conn) {
        die("La connexion a échoué: " . mysqli_connect_error());
    }
    echo "Connecté avec succès";
?>