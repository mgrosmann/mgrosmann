killall dhclient
systemctl disable --now systemd-resolved
#zabbix_get -s 192.168.2.107 -k system.uptime #tester depuis le serveur si on acces a l'agent zabbix
#zabbix_get -s 192.168.2.107 -k agent.ping #tester depuis le serveur si on acces a l'agent zabbix
#sudo ss -tulpn | grep zabbix #tester sur la machine cliente si l'agent marche 
#telnet 192.168.2.107 10050 #tester le port
#pense a faire systemctl restart zabbix-agent apres avoir editer le fichier.conf
#killall dhclient #pour laisser en statique debian
#systemctl disable --now systemd-resolved #desactive conf dns auto ubuntu
