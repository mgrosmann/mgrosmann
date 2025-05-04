<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
session_start();

include_once 'daos/PdoBD.php';
include_once 'messagerieDAO.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nom_utilisateur = isset($_POST['nom_utilisateur']) ? $_POST['nom_utilisateur'] : null;
    $mot_de_passe = isset($_POST['mot_de_passe']) ? $_POST['mot_de_passe'] : null;

    if ($nom_utilisateur !== null && $mot_de_passe !== null) {
        $resultat_authentification = MessagerieDAO::authentifierUtilisateur($nom_utilisateur, $mot_de_passe);

        if ($resultat_authentification) {
            $_SESSION['prenom'] = $resultat_authentification[0]['prenom'];
            header("Location: messagerie.php");
            exit();
        } else {
            echo "Authentification échouée. Veuillez vérifier vos informations d'identification.";
        }
    }
}

