#!/bin/bash
ip=`hostname -I | cut -f1 -d' '`
kubeadm init
kubeadm token create --print-join-command
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl get nodes
sudo kubectl get pods --all-namespaces
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubeadm join $ip --token v9qxex.i6jant8m2r0zxhhk     --discovery-token-ca-cert-hash sha256:b0cda6d2e64a8a65ad5f439e06c3cb489c3d7f6f4e0c094ebb2556037153dc4b
kubectl get nodes
kubectl label node w-node1 node-role.kubernetes.io/worker=worker







