#!/bin/bash
wget https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz
tar xzf prometheus-2.41.0.linux-amd64.tar.gz
mv prometheus-2.41.0.linux-amd64/ /usr/share/prometheus
useradd --no-create-home --shell /bin/false prometheus
mkdir -p /var/lib/prometheus/data
chown prometheus:prometheus /var/lib/prometheus/data
chown -R prometheus:prometheus /usr/share/prometheus
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=prometheus
Restart=on-failure
WorkingDirectory=/usr/share/prometheus
ExecStart=/usr/share/prometheus/prometheus --config.file=/usr/share/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/data

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
apt update
apt install -y gnupg2 curl software-properties-common dirmngr apt-transport-https lsb-release ca-certificates
curl https://packages.grafana.com/gpg.key | apt-key add -
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
apt update
apt -y install grafana
systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
tar -xvf node_exporter*.tar.gz
cd node_exporter*/
cp node_exporter /usr/local/bin
chown prometheus:prometheus /usr/local/bin/node_exporter
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
echo "Veuillez éditer le fichier '/usr/share/prometheus/prometheus.yml' et ajouter les configurations suivantes :"
echo "    scarpe_configs:"
echo "  - job_name: 'node_exporter'"
echo "    static_configs:"
echo "      - targets: ['localhost:9100']"
echo "Ensuite, redémarrez Prometheus avec : systemctl restart prometheus"
