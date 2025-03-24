#!/bin/bash
echo 'Acquire::http::Proxy "http://192.168.151.254:3128/";' > /etc/apt/apt.conf
echo 'Acquire::https::Proxy "http://192.168.151.254:3128/";' >> /etc/apt/apt.conf
echo "http_proxy  = http://192.168.151.254:3128/" > /root/.wgetrc
echo "https_proxy = http://192.168.151.254:3128/" >> /root/.wgetrc
apt update && apt upgrade
wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-22-current.tar.gz
tar xvfz asterisk-22-current.tar.gz
cd asterisk-22.2.0
./contrib/scripts/install_prereq install
./configure --with-pjproject-bundled
make
make install
make samples
core restart now
cat << EOF > /etc/asterisk/pjsip.conf
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0

[endpoint](!)
type=endpoint
context=sio
disallow=all
allow=ulaw

[auth](!)
type=auth
auth_type=userpass

[aor](!)
type=aor
max_contacts=1


[6001](endpoint)
auth=6001auth
aors=6001aor

[6001auth](auth)
username=6001
password=P@ssw0rd

[6001aor](aor)
EOF
reload
pjsip show aors
cat <<EOF | sudo tee -a /etc/asterisk/extensions.conf :
[sio]
exten = 100,1,Answer()
exten = 100,2,Wait(1)
exten = 100,3,Playback(hello-world)
exten = 100,4,Hangup()
exten = _6XXX,1,Dial(PJSIP/${EXTEN},20)
exten = _6XXX,2,Hangup()

Configurer le client VoIP (softphone) Zoiper :
Username / Login: 6001@192.168.151.205
Password: P@ssw0rd
EOF
