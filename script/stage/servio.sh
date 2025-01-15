#!/bin/bash
apt update
apt install net-tools software-properties-common openjdk-11-jre default-jre ffmpeg dcraw wget -y
cd /opt
sudo wget http://download.serviio.org/releases/serviio-2.4-linux.tar.gz
sudo tar zxvf serviio-2.4-linux.tar.gz
sudo ln -s serviio-2.4 serviio
sudo chown -R root:root /opt
sudo rm serviio-2.4-linux.tar.gz
cat <<EOF > /lib/systemd/system/serviio.service
[Unit]
Description=Serviio Media Server
After=syslog.target local-fs.target network.target

[Service]
Type=simple
StandardOutput=null
ExecStart=/opt/serviio/bin/serviio.sh
ExecStop=/opt/serviio/bin/serviio.sh -stop
KillMode=mixed
TimeoutStopSec=30
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable serviio.service
sudo systemctl start serviio.service



ufw allow :44331
ufw allow 23423
ufw allow 23424
ufw allow 23523
ufw allow 23524 
ufw allow 8895