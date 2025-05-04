<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include_once 'messagerieDAO.php';
echo '<form action="traiter_envoi_message.php" method="post">';
echo '    <label for="destinataire">Destinataire :</label>';
echo '    <select name="destinataire">';
echo '        <option value="Classe SIO">Classe SIO</option>';
MessagerieDAO::user_sio();
echo '    </select>';
echo '    <br>';
echo '';
echo '    <label for="contenu_message">Message :</label>';
echo '    <textarea name="contenu_message" rows="4" cols="50"></textarea>';
echo '    <br>';
echo '';
echo '    <input type="submit" name="envoyer_message" value="Envoyer le message">';
echo '</form>';
?>
