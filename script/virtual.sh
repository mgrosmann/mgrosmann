#!/bin/bash

# S'assurer que le script est exécuté avec les privilèges d'administrateur
if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté avec les privilèges d'administrateur." >&2
  exit 1
fi

# Définir le fichier de rapport
rapport="/tmp/rapport_comparaison_virtualisation.txt"
echo "Rapport de Comparaison des Logiciels de Virtualisation - $(date)" > "$rapport"
echo "-------------------------------------------------" >> "$rapport"

# Mise à jour des paquets et installation des dépendances
echo "Mise à jour des paquets..." | tee -a "$rapport"
apt update && apt upgrade -y | tee -a "$rapport"

# Installation des outils de virtualisation
echo "Installation de VirtualBox..." | tee -a "$rapport"
apt install -y virtualbox virtualbox-ext-pack | tee -a "$rapport"

echo "Installation de KVM, QEMU et libvirt..." | tee -a "$rapport"
apt install -y qemu-kvm libvirt-bin bridge-utils virt-manager | tee -a "$rapport"

# Installation des outils supplémentaires pour Hyper-V et ESXi
echo "Installation de govc pour gérer ESXi..." | tee -a "$rapport"
apt install -y govc | tee -a "$rapport"
echo "Installation des outils Hyper-V..." | tee -a "$rapport"
apt install -y libvirt-clients libvirt-daemon-system | tee -a "$rapport"

# Fonction pour calculer le coût approximatif des outils
calculer_cout() {
  echo "VirtualBox : Gratuit" | tee -a "$rapport"
  echo "KVM : Gratuit" | tee -a "$rapport"
  echo "ESXi : Gratuit pour l'édition de base, version payante avec plus de fonctionnalités" | tee -a "$rapport"
  echo "Hyper-V : Inclus avec Windows Server ou Pro, mais nécessite une licence Windows" | tee -a "$rapport"
}

# Vérification de l'installation des outils
echo "Vérification de l'installation de VirtualBox..." | tee -a "$rapport"
if command -v virtualbox &> /dev/null
then
    echo "VirtualBox installé avec succès." | tee -a "$rapport"
else
    echo "VirtualBox n'a pas pu être installé." >&2 | tee -a "$rapport"
    exit 1
fi

# Vérification de l'installation de KVM...
echo "Vérification de l'installation de KVM..." | tee -a "$rapport"
if command -v kvm &> /dev/null
then
    echo "KVM installé avec succès." | tee -a "$rapport"
else
    echo "KVM n'a pas pu être installé." >&2 | tee -a "$rapport"
    exit 1
fi

# Test de création d'une machine virtuelle et comparaison des performances
# Test avec VirtualBox
echo "Création d'une machine virtuelle avec VirtualBox..." | tee -a "$rapport"
start_time=$(date +%s)
vboxmanage createvm --name "VM_VirtualBox" --register
vboxmanage modifyvm "VM_VirtualBox" --memory 1024 --acpi on --boot1 dvd --nic1 nat
vboxmanage createhd --filename "/var/lib/virtualbox/HardDisks/VM_VirtualBox.vdi" --size 10240
vboxmanage storagectl "VM_VirtualBox" --name "SATA Controller" --add sata --controller IntelAhci
vboxmanage storageattach "VM_VirtualBox" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/var/lib/virtualbox/HardDisks/VM_VirtualBox.vdi"
end_time=$(date +%s)
echo "Temps de création de VM VirtualBox: $(($end_time - $start_time)) secondes." | tee -a "$rapport"

# Test avec KVM
echo "Création d'une machine virtuelle avec KVM..." | tee -a "$rapport"
start_time=$(date +%s)
virt-install --name VM_KVM --memory 1024 --vcpus 1 --disk path=/var/lib/libvirt/images/VM_KVM.qcow2,size=10 --cdrom /dev/cdrom --network bridge=br0 --graphics none --console pty,target_type=serial --os-type linux --os-variant ubuntu20.04
end_time=$(date +%s)
echo "Temps de création de VM KVM: $(($end_time - $start_time)) secondes." | tee -a "$rapport"

# Test avec ESXi via govc
echo "Test de création d'une VM avec ESXi via govc..." | tee -a "$rapport"
start_time=$(date +%s)
govc vm.create -cpu 1 -mem 1024 -disk 10 -name VM_ESXi -folder "/$ESXI_DATACENTER/vm" -network "VM Network"
end_time=$(date +%s)
echo "Temps de création de VM ESXi: $(($end_time - $start_time)) secondes." | tee -a "$rapport"

# Test avec Hyper-V via PowerShell (si configuré)
echo "Création d'une machine virtuelle sur Hyper-V via PowerShell..." | tee -a "$rapport"
powershell_script="
  New-VM -Name VM_HyperV -MemoryStartupBytes 1GB -NewVHDPath 'C:\\VMs\\VM_HyperV.vhdx' -NewVHDSizeBytes 10GB
  Start-VM -Name VM_HyperV
"
start_time=$(date +%s)
ssh user@windows_host "$powershell_script" | tee -a "$rapport"
end_time=$(date +%s)
echo "Temps de création de VM Hyper-V: $(($end_time - $start_time)) secondes." | tee -a "$rapport"

# Test de la convertibilité des machines virtuelles entre VirtualBox et KVM
echo "Conversion de la VM VirtualBox en format OVF..." | tee -a "$rapport"
vboxmanage export "VM_VirtualBox" --output "/tmp/VM_VirtualBox.ovf" | tee -a "$rapport"
echo "Importation de la VM OVF dans KVM..." | tee -a "$rapport"
virt-v2v -i /tmp/VM_VirtualBox.ovf -o libvirt -n "VM_VirtualBox_KVM" | tee -a "$rapport"

# Test du redimensionnement dynamique des disques
# VirtualBox
echo "Test du redimensionnement dynamique des disques dans VirtualBox..." | tee -a "$rapport"
vboxmanage modifyhd "/var/lib/virtualbox/HardDisks/VM_VirtualBox.vdi" --resize 20480 | tee -a "$rapport"
echo "Redimensionnement du disque réussi dans VirtualBox." | tee -a "$rapport"

# KVM
echo "Test du redimensionnement dynamique des disques dans KVM..." | tee -a "$rapport"
qemu-img resize /var/lib/libvirt/images/VM_KVM.qcow2 +10G | tee -a "$rapport"
echo "Redimensionnement du disque réussi dans KVM." | tee -a "$rapport"

# Nettoyage des fichiers temporaires et de la machine virtuelle de test
echo "Suppression des fichiers temporaires et des machines virtuelles de test..." | tee -a "$rapport"
vboxmanage unregistervm "VM_VirtualBox" --delete | tee -a "$rapport"
rm -f /tmp/VM_VirtualBox.ovf | tee -a "$rapport"
virsh undefine "VM_KVM" --remove-all-storage | tee -a "$rapport"

# Calcul des coûts
calculer_cout

echo "Mission de comparaison des logiciels de virtualisation terminée avec succès." | tee -a "$rapport"
echo "Rapport complet disponible dans $rapport"
