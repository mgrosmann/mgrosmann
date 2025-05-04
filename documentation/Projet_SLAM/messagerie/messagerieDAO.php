<style>
<?php include "styles/messagerie.css"; ?>
</style>
<?php
ob_start();
include_once 'daos/PdoBD.php';
class MessagerieDAO {
    public static function authentifierUtilisateur($nom_utilisateur, $mot_de_passe) {
        $mot_de_passe_md5 = md5($mot_de_passe);
        $sql = "SELECT * FROM utilisateur WHERE pseudo=:nom_utilisateur AND mdp=:mot_de_passe_md5";
        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->bindParam(":nom_utilisateur", $nom_utilisateur);
        $stmt->bindParam(":mot_de_passe_md5", $mot_de_passe_md5);
        $stmt->execute();
        return $stmt->fetchAll();
    }
    public static function GetMessage($pseudo_utilisateur) {
        $sql = "SELECT * FROM message WHERE destinataire IS NULL OR destinataire = :username0 order by dateheure desc";
        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->bindParam(':username0', $_SESSION['username0']);
        $stmt->execute();
        $messages = $stmt->fetchAll();
        return $messages;
    }
    public static function AfficherMessages($pseudo_utilisateur) {
        $messages = self::GetMessage($pseudo_utilisateur);
        foreach ($messages as $message) {
            $destinataire = $message['destinataire'];
            $containerClass = ($destinataire === null || $destinataire === $pseudo_utilisateur) ? 'div_1' : 'div_0';
            echo '<div class="message-box ' . $containerClass . '">';
            echo '<p>' . htmlspecialchars($message['pseudo']) . '</p>';
            echo '<p>' . htmlspecialchars($message['dateheure']) . '</p>';
            echo '<p>' . htmlspecialchars($message['contenu']) . '</p>';
            echo '</div>';
            echo '<hr>';
        }
    }
    public static function user_sio() {
        $sql = "SELECT pseudo, prenom, nom FROM utilisateur ORDER BY nom";
        $stmt = PdoBD::getInstance()->getMonPdo()->query($sql);
        $users = $stmt->fetchAll();
        foreach ($users as $user) {
            echo '<option value="' . $user['pseudo'] . '">' . $user['nom'] . ' ' . $user['prenom'] . '</option>';
        }
    }
    public static function getInfoUser() {
        if (isset($_SESSION['username0'])) {
            $username0 = $_SESSION['username0'];
            $sql = "SELECT pseudo, nom, prenom FROM utilisateur WHERE pseudo=:username0";
            $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
            $stmt->bindParam(":username0", $username0);
            $stmt->execute();
            return $stmt->fetch(PDO::FETCH_ASSOC);
        }
        return null;
    }
    public static function envoiMessage($expediteur, $destinataire, $contenu) {
        try {
            if ($destinataire == null) {
                $sql = "INSERT INTO message (pseudo, destinataire, contenu) VALUES (:expediteur, NULL, :contenu)";
            } else {
                $sql = "INSERT INTO message (pseudo, destinataire, contenu) VALUES (:expediteur, :destinataire, :contenu)";
            }
            $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
            $stmt->bindParam(':expediteur', $expediteur);
            $stmt->bindParam(':contenu', $contenu);
            if ($destinataire !== null) {
                $stmt->bindParam(':destinataire', $destinataire);
            }
            $stmt->execute();
            ob_end_clean();
            return true;
        } catch (PDOException $e) {
            ob_end_clean();
            return false;
        }
    }
    public static function new_user($pseudo, $nom, $prenom, $mot_de_passe, $mail) {
        $new_mot_de_passe = md5($mot_de_passe);
        $sql = "SELECT nouvel_utilisateur(:pseudo, :nom, :prenom, :mot_de_passe, :mail) AS cle";
        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->bindParam(':pseudo', $pseudo);
        $stmt->bindParam(':nom', $nom);
        $stmt->bindParam(':prenom', $prenom);
        $stmt->bindParam(':mot_de_passe', $new_mot_de_passe);
        $stmt->bindParam(':mail', $mail);
        $stmt->execute();
    }
    public static function get_cle_user($pseudo, $nom, $prenom) {
        $sql = "SELECT cle FROM utilisateur WHERE pseudo = :pseudo AND nom = :nom AND prenom= :prenom";
        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->bindParam(':pseudo', $pseudo);
        $stmt->bindParam(':nom', $nom);
        $stmt->bindParam(':prenom', $prenom);
        $stmt->execute();
        $stmt->debugDumpParams() ;
        $cle = $stmt->fetch(PDO::FETCH_ASSOC);
        return $cle["cle"];
    }
     public static function active_user($pseudo, $cle) {
        $sql = "select activer_utilisateur($pseudo,$cle) as verification ;";
        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->bindParam(':pseudo', $pseudo);
        $stmt->bindParam(':cle', $cle);
        $stmt->execute();   
     }
}
?>