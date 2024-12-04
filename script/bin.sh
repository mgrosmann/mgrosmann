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
wget mgrosmann.vercel.app/script/cours/https.sh
wget mgrosmann.vercel.app/script/cours/site.sh
wget mgrosmann.vercel.app/script/docker/apocker.sh
wget mgrosmann.vercel.app/script/docker/compose.sh
wget mgrosmann.vercel.app/script/docker/ssh_ct.sh
wget mgrosmann.vercel.app/script/docker/start.sh
wget mgrosmann.vercel.app/script/docker/stop.sh
wget mgrosmann.vercel.app/script/docker/linux.sh
wget mgrosmann.vercel.app/script/docker/container.sh
dos2unix *.sh
cat https.sh > /usr/local/bin/https
cat site.sh > /usr/local/bin/site
cat apocker.sh > /usr/local/bin/ct-httpd
cat compose.sh > /usr/local/bin/ct-setup
cat ssh_ct.sh > /usr/local/bin/ct-connect
cat start.sh > /usr/local/bin/ct-start
cat stop.sh > /usr/local/bin/ct-stop
cat linux.sh > /usr/local/bin/ct-linux
cat container.sh > /usr/local/bin/container

cd /usr/local/bin
chmod +x *
