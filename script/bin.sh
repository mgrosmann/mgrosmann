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
wget mgrosmann.vercel.app/script/docker/docker_aio.sh
wget mgrosmann.vercel.app/script/docker/pma.sh
mv https.sh /usr/local/bin/https
mv site.sh /usr/local/bin/site
mv apocker.sh /usr/local/bin/ct-httpd
mv compose.sh /usr/local/bin/ct-setup
mv ssh_ct.sh /usr/local/bin/ct-connect
mv start.sh /usr/local/bin/ct-start
mv stop.sh /usr/local/bin/ct-stop
mv linux.sh /usr/local/bin/ct-linux
mv container.sh /usr/local/bin/container
mv docker_aio.sh /usr/local/bin/docker_aio
mv pma.sh /usr/local/bin/pma
wget mgrosmann.vercel.app/script/docker/remove.sh
mv remove.sh /usr/local/bin/remove
wget mgrosmann.vercel.app/script/docker/network.sh
mv network.sh /usr/local/bin/network
chmod +x /usr/local/bin/*
dos2unix /usr/local/bin/*