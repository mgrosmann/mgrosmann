#!/bin/bash
echo -e "\e[33mAssurez-vous que le serveur GLPI est opérationnel, que l'installation sur l'interface web a été finalisée et que l'inventaire a été activé.\e[0m"
read -p "Le serveur GLPI est-il prêt ? (y/n): " confirm
if [[ $confirm = "y" ]]; then
    read -p "veuillez entrez l'adresse ip du serveur glpi: " server
    apt install perl -y
    wget https://github.com/glpi-project/glpi-agent/releases/download/1.7.1/glpi-agent-1.7.1-linux-installer.pl
    perl glpi-agent-1.7.1-linux-installer.pl -s http://$server/glpi --runnow --install
    systemctl enable glpi-agent
    #glpi-agent --server http://$server/glpi --force
    #seulement si ca marche pas, sinon laissez en commentaire
elif [[ $confirm = "n" ]]; then
    echo "Veuillez finaliser l'installation du serveur GLPI avant de continuer."
else
    echo "choix non pris en compte"
fi
