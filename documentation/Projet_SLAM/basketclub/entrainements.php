<h1>Entrainements</h1>
<style>
<?php include "styles/entrainements.css"; ?>
</style>
<div id="div_entrainements">
    <?php
    include "./daos/EntrainementsDao.php";
    $tousLesEntrainements = EntrainementsDao::getEntrainements();
    foreach ($tousLesEntrainements as $e) {
        echo '<div class="div_un_entrainement">';
        echo '<p>' . $e['id'] . '</p>';
        echo '<p><strong>Entrainement du ' . $e['date'] . '</strong></p>';
        $listeJoueurs = EntrainementsDao::getJoueursByEntrainement($e['id']);
        $currentDate = null;
        foreach ($listeJoueurs as $leJoueur) {
            $prenom = $leJoueur["prenom"];
            $nom = $leJoueur["nom"];
            $motivation = $leJoueur["motivation"];
            $commentaire = $leJoueur["commentaire"];

            if ($prenom || $nom || $motivation || $commentaire) {
                
                echo '<div>' . $prenom . ' ' . $nom . ' (' . $motivation . ') ' . $commentaire . '</div>';
            } 
        }
       
        echo '</div>';
    }
    ?>

</div>
