#!/bin/bash
sudo apt update && sudo apt upgrade
sudo apt install -y autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.4 libgd-dev
sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz
tar xzf nagios-*.tar.gz
cd nagios-*
sudo ./configure --with-nagios-group=nagios --with-command-group=nagcmd
sudo make all
sudo make install
sudo make install-init
sudo make install-config
sudo make install-commandmode
sudo make install-webconf
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
sudo a2enmod rewrite cgi
sudo systemctl restart apache2
cd /tmp
wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
tar xzf nagios-plugins-*.tar.gz
cd nagios-plugins-*
sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
sudo make
sudo make install
echo "editer /usr/local/nagios/etc/nagios.cfg puis  /usr/local/nagios/etc/objects/commands.cfg  puis /usr/local/nagios/etc/objects/hosts.cfg puis /usr/local/nagios/etc/objects/services.cfg"