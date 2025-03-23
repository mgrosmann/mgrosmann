#!/bin/bash
read -p "entre le chemin du  script a executer a chaque demarrage  " path
chmod +x $path
cat << EOL > /etc/systemd/system/$path.service
[Unit]
Description=Exécution de $path au démarrage
After=network.target

[Service]
ExecStart=$path
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL
systemctl daemon-reload
systemctl enable mnt.service
systemctl start mnt.service
