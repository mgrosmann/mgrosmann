#!/bin/bash
apt install perl
wget https://github.com/glpi-project/glpi-agent/releases/download/1.7.1/glpi-agent-1.7.1-linux-installer.pl
perl glpi-agent-1.7.1-linux-installer.pl -s http://192.168.1.207/front/inventory.php --runnow --install
systemctl enable glpi-agent
