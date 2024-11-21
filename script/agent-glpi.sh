wget https://github.com/glpi-project/glpi-agent/releases/download/1.11/glpi-agent-1.11-with-snap-linux-installer.pl
chmod +x glpi-agent-1.11-with-snap-linux-installer.pl
sudo ./glpi-agent-1.11-with-snap-linux-installer.pl
sudo systemctl enable glpi-agent
