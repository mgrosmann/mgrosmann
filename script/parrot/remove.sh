#!/bin/bash

# Mettre à jour le système
sudo apt-get update && sudo apt-get upgrade -y

# Installer Prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Télécharger et extraire Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.31.1/prometheus-2.31.1.linux-amd64.tar.gz
tar -xvf prometheus-2.31.1.linux-amd64.tar.gz
cd prometheus-2.31.1.linux-amd64
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo cp prometheus.yml /etc/prometheus

# Changer les permissions
sudo chown -R prometheus:prometheus /etc/prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

# Créer le service systemd pour Prometheus
sudo bash -c 'cat <<EOT > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/

[Install]
WantedBy=multi-user.target
EOT'

# Démarrer et activer Prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

echo "Installation et configuration de Prometheus terminées avec succès."

