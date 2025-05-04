<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Messagerie</title>
    <link href="styles/index.css" rel="stylesheet" />
</head>
<?php
    echo '<a href="inscription.php">Pas de compte ? Inscrivez vous !</a>';
    ?>
<body>
    <form action="messagerie.php" method="post">
        <input type="text" name="nom_utilisateur" placeholder="Votre nom d'utilisateur"/>
        <input type="password" name="mot_de_passe" placeholder="Votre mot de passe" required/>
        <input type="submit" value="Se Connecter"/>
    </form>

    
</body>
</html>
