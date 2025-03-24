#!/bin/bash
read -p  "quel numero: " numero
read -p  "quel password: " -s passwd
cat << EOF >> /etc/asterisk/pjsip.conf
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0

[$numero]
type=endpoint
context=sio
disallow=all
allow=ulaw
auth=${numero}auth
aors=${numero}aor

[${numero}auth]
type=auth
auth_type=userpass
username=$numero
password=$passwd

[${numero}aor]
type=aor
max_contacts=1
EOF
