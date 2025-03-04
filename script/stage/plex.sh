#!/bin/bash
sudo wget -O- https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | sudo tee /usr/share/keyrings/plex.gpg
echo deb [signed-by=/usr/share/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt install apt-transport-https
sudo apt update
sudo apt install plexmediaserver
sudo mkdir -p /opt/plexmediaserver/{movies,series,photos}
sudo chown -R $USER: /opt/plexmediaserver 
sudo chmod 755 -R /opt/plexmediaserver
ufw allow 32400