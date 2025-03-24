#!/bin/bash
read -ps echo "quel password" passwd
read -p echo "quel numero" numero
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
auth=6001auth
aors=6001aor

[$numeroauth]
type=auth
auth_type=userpass
username=$numero
password=$passwd

[$numeroaor]
type=aor
max_contacts=1
EOF
