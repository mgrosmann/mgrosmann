#!/bin/bash

# S'assurer que le script est exécuté avec les privilèges d'administrateur
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté avec les privilèges d'administrateur." >&2
  exit 1
fi

# Définir le fichier de rapport
rapport="/tmp/rapport.txt"
echo "Rapport de Virtualisation - $(date)" > "$rapport"
echo "-------------------------------------------------" >> "$rapport"

# Mise à jour des paquets et installation des dépendances
echo "Mise à jour des paquets..." | tee -a "$rapport"
apt update && apt upgrade -y | tee -a "$rapport"

# Installation des outils de virtualisation
echo "Installation de VirtualBox..." | tee -a "$rapport"
apt install -y virtualbox virtualbox-ext-pack | tee -a "$rapport"

echo "Installation de KVM, QEMU et libvirt..." | tee -a "$rapport"
apt install -y qemu-kvm libvirt-bin bridge-utils virt-manager | tee -a "$rapport"

# Vérification de l'installation des outils
echo "Vérification de l'installation de VirtualBox..." | tee -a "$rapport"
if command -v virtualbox &> /dev/null
then
    echo "VirtualBox installé avec succès." | tee -a "$rapport"
else
    echo "VirtualBox n'a pas pu être installé." >&2 | tee -a "$rapport"
    exit 1
fi

echo "Vérification de l'installation de KVM..." | tee -a "$rapport"
if command -v kvm &> /dev/null
then
    echo "KVM installé avec succès." | tee -a "$rapport"
else
    echo "KVM n'a pas pu être installé." >&2 | tee -a "$rapport"
    exit 1
fi

# Vérification des capacités de virtualisation du CPU
echo "Vérification de la virtualisation matérielle..." | tee -a "$rapport"
egrep -c '(vmx|svm)' /proc/cpuinfo | tee -a "$rapport"
if [ $? -eq 0 ]; then
    echo "Votre processeur ne supporte pas la virtualisation matérielle." >&2 | tee -a "$rapport"
    exit 1
fi

# Création d'une machine virtuelle de test dans VirtualBox
echo "Création d'une machine virtuelle de test avec VirtualBox..." | tee -a "$rapport"
vboxmanage createvm --name "TestVM" --register | tee -a "$rapport"
vboxmanage modifyvm "TestVM" --memory 1024 --acpi on --boot1 dvd --nic1 nat | tee -a "$rapport"
vboxmanage createhd --filename "/var/lib/virtualbox/HardDisks/TestVM.vdi" --size 10240 | tee -a "$rapport"
vboxmanage storagectl "TestVM" --name "SATA Controller" --add sata --controller IntelAhci | tee -a "$rapport"
vboxmanage storageattach "TestVM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/var/lib/virtualbox/HardDisks/TestVM.vdi" | tee -a "$rapport"

# Convertir la machine virtuelle VirtualBox en format OVF pour tester la convertibilité
echo "Conversion de la machine virtuelle VirtualBox en format OVF..." | tee -a "$rapport"
vboxmanage export "TestVM" --output "/tmp/TestVM.ovf" | tee -a "$rapport"

# Importer le fichier OVF dans KVM
echo "Importation de la machine virtuelle OVF dans KVM..." | tee -a "$rapport"
virt-v2v -i /tmp/TestVM.ovf -o libvirt -n "TestVM_KVM" | tee -a "$rapport"

# Vérification du redimensionnement dynamique des disques avec VirtualBox
echo "Test du redimensionnement dynamique des disques dans VirtualBox..." | tee -a "$rapport"
vboxmanage modifyhd "/var/lib/virtualbox/HardDisks/TestVM.vdi" --resize 20480 | tee -a "$rapport"
if [ $? -eq 0 ]; then
    echo "Redimensionnement du disque réussi dans VirtualBox." | tee -a "$rapport"
else
    echo "Le redimensionnement du disque a échoué dans VirtualBox." >&2 | tee -a "$rapport"
    exit 1
fi

# Vérification du redimensionnement dynamique des disques avec KVM
echo "Test du redimensionnement dynamique des disques dans KVM..." | tee -a "$rapport"
qemu-img resize /var/lib/libvirt/images/TestVM.qcow2 +10G | tee -a "$rapport"
if [ $? -eq 0 ]; then
    echo "Redimensionnement du disque réussi dans KVM." | tee -a "$rapport"
else
    echo "Le redimensionnement du disque a échoué dans KVM." >&2 | tee -a "$rapport"
    exit 1
fi

# Tests sur Hyper-V et ESXi (partie manuelle)
echo "Test avec Hyper-V et ESXi non automatisé. Consultez la documentation pour les tests manuels." | tee -a "$rapport"

# Nettoyage des fichiers temporaires et de la machine virtuelle de test
echo "Suppression des fichiers temporaires et de la machine virtuelle de test..." | tee -a "$rapport"
vboxmanage unregistervm "TestVM" --delete | tee -a "$rapport"
rm -f /tmp/TestVM.ovf | tee -a "$rapport"
virsh undefine "TestVM_KVM" --remove-all-storage | tee -a "$rapport"

echo "Mission de virtualisation terminée avec succès." | tee -a "$rapport"
echo "Rapport complet disponible dans $rapport"
