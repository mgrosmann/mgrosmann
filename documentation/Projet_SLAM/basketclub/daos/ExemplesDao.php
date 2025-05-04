<?php

include_once 'daos/PdoBD.php';

class ExemplesDao {
       public static function getExemples() {
        $sql = "SELECT * FROM Exemple";
        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->execute();
        $obj = $stmt->fetchAll(); //$obj = $stmt->fetch(); Si une seule ligne résultat
        return $obj;
    }

    public static function getExempleById($id) {
        $sql = "SELECT * FROM Exemple where id=:leId";
        $stmt = PdoBD::getInstance()->getMonPdo()->prepare($sql);
        $stmt->bindParam(":leId", $id);
        $stmt->execute();
        $obj = $stmt->fetch(); //$obj = $stmt->fetch(); Si une seule ligne résultat
        return $obj;
    }

}
