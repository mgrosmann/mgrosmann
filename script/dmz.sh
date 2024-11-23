#!/bin/bash
ALLOWED_IP="192.168.1.80"
iptables -F
iptables -X
iptables -A INPUT -p tcp --dport 22 -s $ALLOWED_IP -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -j DROP
iptables-save > /etc/iptables/rules.v4
sed -i '/^#PermitRootLogin/s/^#//' /etc/ssh/sshd_config
sed -i '/^PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
sed -i '/^#PasswordAuthentication/s/^#//' /etc/ssh/sshd_config
sed -i '/^PasswordAuthentication/s/yes/no/' /etc/ssh/sshd_config
echo "AllowUsers utilisateur@$ALLOWED_IP" >> /etc/ssh/sshd_config
systemctl restart sshd
echo "La configuration de la machine en DMZ  a été effectuée avec succès."
