#!/bin/bash
read -p "besoin du jump ssh ? (1 pour non 2 pour oui)" jump
if [[ $jump == 1 ]]; then
    read -p "nom de l'utilisateur du serveur ssh distant" user
    read -p "hostname/Adresse ip du serveur ssh distant" host 
    if [ ! -f ~/.ssh/id_rsa.pub ]; then
        ssh-keygen -t rsa
        ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$host
    elif
        ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$host
elif [[ $jump == 2 ]]; then
    if [ ! -f ~/.ssh/id_rsa.pub ]; then
        ssh-keygen -t rsa
    fi
read -p "besoin de combien de jump ssh ?" juump
    for (( i=1; i<=$juump; i++ ))
    do
    read -p "nom de l'utilisateur du serveur ssh distant numero $i" user_$i
    read -p "hostname/Adresse ip du serveur ssh distant $i" host_$i
    echo "$user_$i@$host_$i" >> /root/host.txt
echo "effectuer ssh-copy-id -J user@host:port user@host avec les host presents dans /root/host.txt"
#echo "your key public" > ~/.ssh/authorized_keys
