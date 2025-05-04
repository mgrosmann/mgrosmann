<!DOCTYPE html>
<html>
    <head>
        <title>Pergabri</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="pergabri.css"/>
        <link rel="shortcut icon" href="image/logo_pergabri.png">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <div id ="grille">
            <?php include "menu.php"; ?>
            <?php include "actualite.php"; ?>
            <?php include "projets.php"; ?>
            <?php
            $page = filter_input(INPUT_GET, "page");
            switch ($page) {
                case "accueil":
                    include "accueil.php";
                    break;
                case "pergolas":
                    include "pergolas.php";
                    break;
                 case "abris":
                    include "abris.php";
                    break;
                default:
                    break;
            }
            ?>
            <?php include "footer.php" ?>

        </div>

    </body>
</html>