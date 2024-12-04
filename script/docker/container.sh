#!/bin/bash
echo "Que voulez-vous faire ?"
echo "1) Créer un  nouveau conteneur avec l'image HTTPD ou en modifier un existant"
echo "2) installer le conteneur multi-service (MySQL, phpMyAdmin, FTP, APACHE)"
echo "3) Se connecter à un conteneur"
echo "4) Démarrer tous les conteneurs"
echo "5) Arrêter tous les conteneurs"
echo "6) Installer nano et wget sur un conteneur"
read -p "Entrez le numéro de votre choix: " choix
case $choix in
    1)
        /usr/local/bin/ct-httpd
        ;;
    2)
        /usr/local/bin/ct-setup
        ;;
    3)
        /usr/local/bin/ct-connect
        ;;
    4)
        /usr/local/bin/ct-start
        ;;
    5)
        /usr/local/bin/ct-stop
        ;;
    6)
        /usr/local/bin/ct-linux
        ;;
    *)
        echo "Choix invalide. Veuillez réessayer."
        ;;
esac
