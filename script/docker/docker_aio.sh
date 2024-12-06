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
echo -e "${LIGHT_GREEN}5)${NC} Créer un conteneur intéractif PhpMyadmin"
echo -e "${LIGHT_GREEN}6)${NC} Créer un conteneur détaché Apache HTTPD"
echo -e "${LIGHT_GREEN}7)${NC} Créer un conteneur détaché Apache HTTPD avec volume monté"
echo -e "${LIGHT_GREEN}8)${NC} Créer un conteneur détaché MySQL sans mot de passe"
echo -e "${LIGHT_GREEN}9)${NC} Créer un conteneur détaché MySQL avec mot de passe"
echo -e "${LIGHT_GREEN}10)${NC} Créer un conteneur détaché PhpMyadmin"
echo -e "${LIGHT_GREEN}11)${NC} Créer un conteneur interactif Ubuntu SSH avec utilisateur et mot de passe"
echo -e "${LIGHT_GREEN}12)${NC} Créer un conteneur détaché Ubuntu SSH avec utilisateur et mot de passe"

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
    read -p "Entrez le por sql à utiliser : " port_sql
    read -p "Entrez le port pma à utiliser : " port_pma
    read -p "Entrez le mot de passe du root à utiliser : " mdp_root
    read -p "Entrez le nom du conteneur : " name
    docker network create network-$name
    docker run -d --name sql_$name --network network-$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_sql:3306 mysql
    docker run -it --name pma_$name --network network-$name -e PMA_HOST=sql_$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_pma:80 phpmyadmin/phpmyadmin
elif [ "$choix" -eq 6 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    docker container run -d -p $port:80 --name $name httpd
elif [ "$choix" -eq 7 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    read -p "Entrez le nom du repertoire : " repertory
    docker container run -d -p $port:80 -v $repertory:/usr/local/apache2/htdocs --name $name httpd
elif [ "$choix" -eq 8 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    docker container run -d -p $port:3306 --name $name mysql
elif [ "$choix" -eq 9 ]; then
    read -p "Entrez le port à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    read -p "Entrez le mot de passe root MySQL: " root_password
    docker container run -d -p $port:3306 --name $name -e MYSQL_ROOT_PASSWORD=$root_password mysql

elif [ "$choix" -eq 10 ]; then
    read -p "Entrez le por sql à utiliser : " port_sql
    read -p "Entrez le port pma à utiliser : " port_pma
    read -p "Entrez le mot de passe du root à utiliser : " mdp_root
    read -p "Entrez le nom du conteneur : " name
    docker network create network-$name
    docker run -d --name sql_$name --network network-$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_sql:3306 mysql
    docker run -d --name pma_$name --network network-$name -e PMA_HOST=sql_$name -e MYSQL_ROOT_PASSWORD=$mdp_root -p $port_pma:80 phpmyadmin/phpmyadmin
elif [ "$choix" -eq 11 ]; then
    read -p "Entrez le port SSH à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    read -p "Entrez le nom de l'utilisateur : " user
    read -p "Entrez le mot de passe : " password
    docker container run -it -p $port:22 --name $name rastasheep/ubuntu-sshd && \
    docker exec -it $name /bin/bash -c "adduser --disabled-password --gecos '' $user && echo '$user:$password' | chpasswd"
elif [ "$choix" -eq 12 ]; then
    read -p "Entrez le port SSH à utiliser : " port
    read -p "Entrez le nom du conteneur : " name
    read -p "Entrez le nom de l'utilisateur : " user
    read -p "Entrez le mot de passe : " password
    docker container run -d -p $port:22 --name $name rastasheep/ubuntu-sshd && \
    docker exec -it $name /bin/bash -c "adduser --disabled-password --gecos '' $user && echo '$user:$password' | chpasswd"
else
    echo -e "${RED}Choix invalide. Veuillez réessayer.${NC}"
fi