#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
PINK='\033[1;35m'
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
BROWN='\033[0;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
NC='\033[0m'
echo -e "${RED}1)${NC} Créer un nouveau ${GREEN}conteneur${NC} avec l'image ${BLUE}HTTPD${NC} ou en modifier un ${GREEN}existant${NC}"
echo -e "${RED}2)${NC} Installer le ${GREEN}conteneur${NC} multi-service (${PINK}MySQL${NC}, ${RED}phpMyAdmin${NC}, ${ORANGE}FTP${NC}, ${LIGHT_BLUE}APACHE${NC})"
echo -e "${RED}3)${NC} Se connecter à un ${GREEN}conteneur${NC}"
echo -e "${RED}4)${NC} Démarrer tous les ${GREEN}conteneurs${NC}"
echo -e "${RED}5)${NC} Arrêter tous les ${GREEN}conteneurs${NC}"
echo -e "${RED}6)${NC} Installer ${BLUE}nano${NC} et ${YELLOW}wget${NC} sur un ${GREEN}conteneur${NC}"
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
