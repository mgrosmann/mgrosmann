<html lang="fr">
    <head>
        <link rel="stylesheet" href="styles/index.css" type="text/css"/>
        <title>Godefroy Basket Club</title>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    </head>
    <body>
        <?php
        ini_set('display_errors', 1);
        ini_set('display_startup_errors', 1);
        error_reporting(E_ALL);
        include "header.php";
        include "nav.php";
        ?>

        <section>
            <?php
            $page = filter_input(INPUT_GET, 'page');
            switch ($page) {
                case "exemples" :
                    include "exemples.php";
                    break;
                case "joueurs" :
                    include "joueurs.php";
                    break;
                case "entrainements" :
                    include "entrainements.php";
                    break;
                case "matchs" :
                    include "matchs.php";
                    break;
            }
            ?>
        </section>
    </body>
</html>