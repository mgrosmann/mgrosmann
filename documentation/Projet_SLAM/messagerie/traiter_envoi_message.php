<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include_once 'messagerieDAO.php';
include_once 'messagerie.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['envoyer_message'])) {
        traiterEnvoiMessage();
    }
}

function traiterEnvoiMessage() {
    $userInfo = MessagerieDAO::getInfoUser();
    if ($userInfo) {
        $expediteur = $userInfo['pseudo'];
        $contenu = $_POST['contenu_message'];

        // Vérifier si le destinataire est "Classe SIO"
        if ($_POST['destinataire'] === 'Classe SIO') {
            $destinataire = null;
        } else {
            $destinataire = $_POST['destinataire'];
        }

        $messageEnvoye = MessagerieDAO::envoiMessage($expediteur, $destinataire, $contenu);

        if ($messageEnvoye) {
            $_SESSION['message_envoye'] = true;

            header("Location: messagerie.php");
            exit();
        } else {
            echo "Erreur: Impossible d'envoyer le message.";
        }
    } else {
        echo "Erreur: Impossible de récupérer les informations de l'utilisateur.";
    }
}
?>
