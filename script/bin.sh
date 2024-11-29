#!/bin/bash
if ! command -v apache2 &> /dev/null
then
    echo "apache2 n'est pas installé. Installation en cours..."
    sudo apt-get update
    sudo apt-get install -y apache2
else
    echo "apache2 est déjà installé."
fi
if ! command -v dos2unix &> /dev/null
then
    echo "dos2unix n'est pas installé. Installation en cours..."
    sudo apt-get install -y dos2unix
else
    echo "dos2unix est déjà installé."
fi
wget mgrosmann.vercel.app/script/https.sh
wget mgrosmann.vercel.app/script/site.sh
dos2unix *.sh
cat https.sh > /usr/local/bin/https
cat site.sh > /usr/local/bin/site
cd /usr/local/bin
chmod +x https
chmod +x site
