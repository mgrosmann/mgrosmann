<?php

include_once 'daos/PdoBD.php';

class EntrainementsDao {
     public static function getEntrainements() {
        $sql = "SELECT * FROM Entrainement";
        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->execute();
        $obj = $stmt->fetchAll(); 
        return $obj;
    }
    
    
    public static function getJoueursByEntrainement($idEntrainement) {
        $sql = "SELECT prenom, nom, motivation, date, commentaire FROM Entrainement 
                INNER JOIN ParticiperE ON ParticiperE.idEntrainement=Entrainement.id 
                INNER JOIN Joueur ON Joueur.id=ParticiperE.idJoueur 
                WHERE idEntrainement = :idEntrainement";

        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->bindParam(":idEntrainement", $idEntrainement);
        $stmt->execute();
        $obj = $stmt->fetchAll(); 
        return $obj;
    }


  
    
}

