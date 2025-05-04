<h1>Exemples (Anthony Médassi)</h1>
<div id="div_exemples">
    <style>
<?php include "styles/exemples.css"; ?>
    </style>
    <?php
    include "./daos/ExemplesDao.php";
    $lesExemples = ExemplesDao::getExemples();
    foreach ($lesExemples as $unExemple) {
        echo '<article>' . $unExemple["libelle"] . '</article>';
    }
    ?>
</div>