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
GRAY='\033[1;30m'
NC='\033[0m'
echo -e "${RED}1)${NC} Créer un nouveau ${GREEN}conteneur${NC} avec l'image ${BLUE}HTTPD${NC} ou en modifier un ${GREEN}existant${NC}"
echo -e "${RED}2)${NC} Installer le ${GREEN}conteneur${NC} multi-service (${PINK}MySQL${NC}, ${GRAY}phpMyAdmin${NC}, ${ORANGE}FTP${NC}, ${LIGHT_BLUE}APACHE${NC})"
echo -e "${RED}3)${NC} Se connecter à un ${GREEN}conteneur${NC}"
echo -e "${RED}4)${NC} Démarrer tous les ${GREEN}conteneurs${NC}"
echo -e "${RED}5)${NC} Arrêter tous les ${GREEN}conteneurs${NC}"
echo -e "${RED}6)${NC} Installer ${BLUE}nano${NC} et ${YELLOW}wget${NC} sur un ${GREEN}conteneur${NC}"
echo -e "${RED}7)${NC} Installer un ${GREEN}conteneur${NC} ${PINK}MySQL${NC} ou ${BLUE}HTTPD${NC} en ${GRAY}session interactive${NC} ou ${ORANGE}détaché${NC} "
read -p "Entrez le numéro de votre choix: " choix
if [ "$choix" -eq 1 ]; then
    bash /usr/local/bin/ct-httpd
elif [ "$choix" -eq 2 ]; then
    bash /usr/local/bin/ct-setup
elif [ "$choix" -eq 3 ]; then
    bash /usr/local/bin/ct-connect
elif [ "$choix" -eq 4 ]; then
    bash /usr/local/bin/ct-start
elif [ "$choix" -eq 5 ]; then
    bash /usr/local/bin/ct-stop
elif [ "$choix" -eq 6 ]; then
    bash /usr/local/bin/ct-linux
elif [ "$choix" -eq 7 ]; then
    bash /usr/local/bin/docker_all_in_one
else
    echo -e "${RED}Choix invalide. Veuillez réessayer.${NC}"
fi