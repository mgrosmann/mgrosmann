#!/bin/bash
read -p "nom de l'utilisateur du serveur ssh distant" user
read -p "hostname/Adresse ip du serveur ssh distant" host 
if [ ! -f ~/.ssh/id_rsa.pub   ]; then
    ssh-keygen -t rsa
    ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$host
elif
    ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$host
#ssh-copy-id -o ProxyJump=jumpuser@jumphost:2455 remoteuser@remotehost
#echo "enter key public" > /root/.ssh/authorized_keys
