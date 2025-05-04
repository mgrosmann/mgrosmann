<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="utf-8">
        <title>Inscription</title>
        <link href="styles/index.css" rel="stylesheet" />
    </head>
    <body>
        <form action="traiter_inscription.php" method="post">
            <input type="text" name="pseudo" placeholder="Votre Pseudo"/>
            <input  type="text" name="nom" placeholder="Votre nom"/>
            <input  type="text" name="prenom" placeholder="Votre Prenom"/>
            <input type="password" name="mot_de_passe" placeholder="Votre mot de passe" required/>
            <input  type="email" name="mail" placeholder="Votre mail"/>
            <input type="submit" value="Proceder a l'inscription !"/>
        </form>

    </body>
</html>
