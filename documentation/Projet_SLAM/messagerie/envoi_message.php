<?php
session_start();
include_once 'messagerieDAO.php';

function traiterEnvoiMessage() {
    if (isset($_POST['envoyer_message'])) {
        $destinataire = $_POST['destinataire'];
        $contenu = $_POST['message'];
        $expediteur = $_SESSION['prenom'];

        // Appel de la fonction pour insérer le message
        MessagerieDAO::insererMessage($expediteur, $destinataire, $contenu);

        // Définir une variable de session pour indiquer le succès
        $_SESSION['message_envoye'] = true;

        // Redirection vers la page de messagerie
        header("Location: messagerie.php");
        exit();
    }
}
?>
