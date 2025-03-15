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
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
apt install -y kubelet kubeadm kubectl
systemctl enable kubelet
kubeadm init --pod-network-cidr=<your-pod-network-cidr>
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml