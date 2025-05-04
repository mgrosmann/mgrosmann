<?php

class PdoBD {

    private static $_serveur = 'mysql:host=127.0.0.1';
    private static $_port = 'port=3306';
    private static $_bdd = 'dbname=messagerie';
    private static $_user = 'root';
    private static $_mdp = 'root';
    private static $_monPdo;
    private static $_instance = null;

    private function __construct() {
        PdoBD::$_monPdo = new \PDO(PdoBD::$_serveur . ';' . PdoBD::$_bdd . ";" . PdoBD::$_port, PdoBD::$_user, PdoBD::$_mdp);
        PdoBD::$_monPdo->query("SET CHARACTER SET utf8");
    }

    public function _destruct() {
        PdoBD::$_monPdo = null;
    }

    public static function getInstance() {
        if (PdoBD::$_instance == null) {
            PdoBD::$_instance = new PdoBD();
        }
        return PdoBD::$_instance;
    }

    public static function getMonPdo() {
        return self::$_monPdo;
    }

}
