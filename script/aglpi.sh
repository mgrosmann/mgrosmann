#!/bin/bash
wget https://github.com/glpi-project/glpi-agent/releases/download/1.11/glpi-agent-1.11-linux-installer.pl
chmod +x glpi-agent-1.11-linux-installer.pl
sudo ./glpi-agent-1.11-linux-installer.pl
sudo bash -c 'echo "server = http://$IP_ADDRESS/glpi" > /etc/glpi-agent/glpi-agent.conf'
sudo systemctl start glpi-agent
sudo systemctl enable glpi-agent
