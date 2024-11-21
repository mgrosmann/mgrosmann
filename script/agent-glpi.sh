#!/bin/bash
echo -e "\e[33mAssurez-vous que le serveur GLPI est opérationnel et que l'installation sur l'interface web est finalisée.\e[0m"
read -p "Le serveur GLPI est-il prêt ? (y/n): " confirm
if [[ $confirm != "y" ]]; then
    echo "Veuillez finaliser l'installation du serveur GLPI avant de continuer."
    exit 1
fi
apt install perl
wget https://github.com/glpi-project/glpi-agent/releases/download/1.7.1/glpi-agent-1.7.1-linux-installer.pl
perl glpi-agent-1.7.1-linux-installer.pl -s http://192.168.1.78/glpi --runnow --install
systemctl enable glpi-agent
