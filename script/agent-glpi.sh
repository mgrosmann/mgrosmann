#!/bin/bash
wget https://github.com/glpi-project/glpi-agent/releases/download/1.7.3/glpi-agent-1.7.3-linux-installer.pl
chmod +x glpi-agent-1.7.3-linux-installer.pl
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo -e "\e[31mVotre adresse IP est $IP_ADDRESS\e[0m"
sudo ./glpi-agent-1.7.3-linux-installer.pl
sudo bash -c "echo 'server = http://$IP_ADDRESS/glpi' > /etc/glpi-agent/glpi-agent.conf"
sudo systemctl start glpi-agent
sudo systemctl enable glpi-agent
