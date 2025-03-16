#!/bin/bash
if ! command -v docker &> /dev/null
then
    wget https://mgdock.vercel.app/docker.sh
    wget https://mgdock.vercel.app/deb_docker.sh
    wget https://mgdock.vercel.app/install.sh
    bash install.sh
    rm docker.sh deb_docker.sh install.sh
else
    echo "docker est déjà installé."
fi
apt install curl
apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
install -y kubelet kubeadm kubectl
hostnamectl set-hostname "master-node"
exec bash
hostnamectl set-hostname "w-node1"
exec bash
cat <<EOF>> /etc/hosts
10.168.10.207 master-node
10.168.10.208 node1 W-node1
10.168.10.209 node2 W-node2
EOF
ufw allow 6443/tcp
ufw allow 2379/tcp
ufw allow 2380/tcp
ufw allow 10250/tcp
ufw allow 10251/tcp
ufw allow 10252/tcp
ufw allow 10255/tcp
ufw reload
ufw allow 10251/tcp
ufw allow 10255/tcp
ufw reload
swapoff -a
systemctl enable kubelet





