<style>
<?php include "styles/messagerie.css"; ?>
</style>
<?php
session_start();
include_once 'daos/PdoBD.php';
include_once 'messagerieDAO.php';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nom_utilisateur = $_POST['nom_utilisateur'];
    $mot_de_passe = $_POST['mot_de_passe'];
    $resultat_authentification = MessagerieDAO::authentifierUtilisateur($nom_utilisateur, $mot_de_passe);
    if ($resultat_authentification) {
        $_SESSION['prenom'] = $resultat_authentification[0]['prenom'];
        $_SESSION['username0'] = $nom_utilisateur;
        header("Location: messagerie.php");
        exit();
    } else {
        $erreur = "Authentification échouée. Veuillez vérifier vos informations d'identification.";
    }
}
if (!isset($_SESSION['prenom'])) {
    header("Location: traiter_formulaire.php");
    exit();
}
$page = isset($_GET['page']) ? $_GET['page'] : '';
switch ($page) {
    case 'envoyermessage':
        include 'envoyer_message.php';
        break;
    default:
        echo "Bonjour <strong>" . $_SESSION['prenom'] . "</strong>";
        echo '<a href="messagerie.php?page=envoyermessage">Envoyer un message</a>';
        echo '<a href="deconnexion.php">Se déconnecter</a>';
        $pseudo_utilisateur = $_SESSION['prenom'];
        MessagerieDAO::AfficherMessages($pseudo_utilisateur);
        break;
}
?>
