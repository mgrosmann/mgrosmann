<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include 'messagerieDAO.php';
$pseudo = $_POST['pseudo'];
$nom = $_POST['nom'];
$prenom = $_POST['prenom'];
$mot_de_passe = $_POST['mot_de_passe'];
$mail = $_POST['mail'];
MessagerieDAO::new_user($pseudo, $nom, $prenom, $mot_de_passe, $mail);
$cle = MessagerieDAO::get_cle_user($pseudo, $nom, $prenom);
$nom_expediteur = "Messagerie PHP jbdelasalle";
$mail_destinataire = $mail;
$sujet = "Cle";
$message = "Voici votre cle : $cle, veuillez l'entrer sur le site suivant : <a href=\"https://sio.jbdelasalle.com/~mgrosmann/messagerie/valider_inscription.php?pseudo=$pseudo&cle=$cle\">Valider l'inscription</a>";
$messageHtml = "<html><head><title>TEST</title></head><body><p>$message</p></body></html>";
$headers = 'Content-type: text/html; charset=iso-8859-1' . "\n";
$headers .= "To: $mail_destinataire <$mail_destinataire>" . "\n";
$headers .= "From: $nom_expediteur <jbdls63@free.fr>" . "\r\n";
if (mail($mail_destinataire, $sujet, $messageHtml, $headers)) {
    echo "<h3>Veuillez consulter vos mails.</h3>";
} else {
    echo "<h3>Echec de la recpetion des données</h3>";
}
?>