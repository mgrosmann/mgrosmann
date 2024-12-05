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
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
BROWN='\033[0;33m'
GRAY='\033[1;30m'
NC='\033[0m'

echo -e "${LIGHT_GREEN}1)${NC} Créer un conteneur interactif Apache HTTPD"
echo -e "${LIGHT_GREEN}2)${NC} Créer un conteneur interactif Apache HTTPD avec volume monté"
echo -e "${LIGHT_GREEN}3)${NC} Créer un conteneur interactif MySQL sans mot de passe"
echo -e "${LIGHT_GREEN}4)${NC} Créer un conteneur interactif MySQL avec mot de passe"
echo -e "${LIGHT_GREEN}5)${NC} Créer un conteneur détaché Apache HTTPD"
echo -e "${LIGHT_GREEN}6)${NC} Créer un conteneur détaché Apache HTTPD avec volume monté"
echo -e "${LIGHT_GREEN}7)${NC} Créer un conteneur détaché MySQL sans mot de passe"
echo -e "${LIGHT_GREEN}8)${NC} Créer un conteneur détaché MySQL avec mot de passe"

read -p "Entrez le numéro de votre choix: " choix

if [ "$choix" -eq 1 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    docker container run -it -p $port:80 --name $name httpd
elif [ "$choix" -eq 2 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    read -p "Entrez le nom du repertoire : " repertory
    docker container run -it -p $port:80 -v $repertory:/usr/local/apache2/htdocs --name $name httpd
elif [ "$choix" -eq 3 ]; then
    read -p "Entrez le port à utiliser  : " port
    read -p "Entrez le nom du conteneur : " name
    docker container run -it -p $port:3306 --name $name mysql
elif [ "$choix" -eq 4 ]; then
    read -p "Entrez le port à utiliser  : " port
    read -p "Entrez le nom du conteneur : " name
    read -p "Entrez le mot de passe root MySQL: " root_password
    docker container run -it -p $port:3306 --name $name -e MYSQL_ROOT_PASSWORD=$root_password mysql
elif [ "$choix" -eq 5 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    docker container run -d -p $port:80 --name $name httpd
elif [ "$choix" -eq 6 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    read -p "Entrez le nom du repertoire : " repertory
    docker container run -d -p $port:80 -v $repertory:/usr/local/apache2/htdocs --name $name httpd
elif [ "$choix" -eq 7 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    docker container run -d -p $port:3306 --name $name mysql
elif [ "$choix" -eq 8 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    read -p "Entrez le mot de passe root MySQL: " root_password
    docker container run -d -p $port:3306 --name $name -e MYSQL_ROOT_PASSWORD=$root_password mysql
else
    echo -e "${RED}Choix invalide. Veuillez réessayer.${NC}"
fi

