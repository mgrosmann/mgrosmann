#!/bin/bash
read -p "quel distribution linux avez vous ? 1 pour debian 2 pour ubuntu ? " linux
if [[ $linux == 1 ]]; then
  wget https://repo.zabbix.com/zabbix/7.2/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.2+debian12_all.deb
  dpkg -i zabbix-release_latest_7.2+debian12_all.deb
elif [[ $linux == 2 ]]; then
  wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu22.04_all.deb
  dpkg -i zabbix-release_latest_7.2+ubuntu22.04_all.deb
else
  echo "choix incorrect seuls debian et ubuntu sont pris en compte"
fi
apt update
apt install zabbix-agent
systemctl restart zabbix-agent
systemctl enable zabbix-agent
echo "pensez bien a effecutuez 'nano /etc/zabbix/zabbix_agentd.conf et remplacer (server=127.0.0.1) par (server=192.168.1.11)"
