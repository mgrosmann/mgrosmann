#!/bin/bash

# Définir le fichier de rapport
rapport="/tmp/rapport_comparaison_virtualisation.txt"
echo "Rapport de Comparaison des Logiciels de Virtualisation - $(date)" > "$rapport"
echo "-------------------------------------------------" >> "$rapport"

# Vérification de l'installation des outils
echo "Vérification des outils installés..." >> "$rapport"
vb_installed=false
kvm_installed=false
esxi_installed=false

if command -v virtualbox &> /dev/null; then
    vb_installed=true
else
    echo "Erreur : VirtualBox manquant !" >> "$rapport"
fi

if command -v kvm &> /dev/null; then
    kvm_installed=true
else
    echo "Erreur : KVM manquant !" >> "$rapport"
fi

if command -v govc &> /dev/null; then
    esxi_installed=true
else
    echo "Attention : govc (ESXi) manquant ! Les tests ESXi seront ignorés." >> "$rapport"
fi

# Test de création d'une VM avec VirtualBox
if [ "$vb_installed" = true ]; then
    echo "Test avec VirtualBox..." >> "$rapport"
    start_time=$(date +%s)
    vboxmanage createvm --name "VM_VirtualBox" --register &> /dev/null
    vboxmanage modifyvm "VM_VirtualBox" --memory 1024 --acpi on --boot1 dvd --nic1 nat &> /dev/null
    vboxmanage createhd --filename "/tmp/VM_VirtualBox.vdi" --size 10240 &> /dev/null
    vboxmanage storagectl "VM_VirtualBox" --name "SATA Controller" --add sata --controller IntelAhci &> /dev/null
    vboxmanage storageattach "VM_VirtualBox" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/tmp/VM_VirtualBox.vdi" &> /dev/null
    end_time=$(date +%s)
    echo "VirtualBox - Temps de création : $(($end_time - $start_time)) secondes" >> "$rapport"
else
    echo "VirtualBox non testé car non installé." >> "$rapport"
fi

# Test de création d'une VM avec KVM
if [ "$kvm_installed" = true ]; then
    echo "Test avec KVM..." >> "$rapport"
    start_time=$(date +%s)
    virt-install --name VM_KVM --memory 1024 --vcpus 1 --disk path=/tmp/VM_KVM.qcow2,size=10 --cdrom /dev/cdrom --network bridge=br0 --graphics none --os-type linux --os-variant ubuntu20.04 --noautoconsole &> /dev/null
    end_time=$(date +%s)
    echo "KVM - Temps de création : $(($end_time - $start_time)) secondes" >> "$rapport"
else
    echo "KVM non testé car non installé." >> "$rapport"
fi

# Test de création d'une VM avec ESXi
if [ "$esxi_installed" = true ]; then
    echo "Test avec ESXi..." >> "$rapport"
    start_time=$(date +%s)
    govc vm.create -cpu 1 -mem 1024 -disk 10 -name VM_ESXi -folder "/Datacenter/vm" -network "VM Network" &> /dev/null
    end_time=$(date +%s)
    echo "ESXi - Temps de création : $(($end_time - $start_time)) secondes" >> "$rapport"
else
    echo "ESXi non testé car govc est manquant." >> "$rapport"
fi

# Test de redimensionnement dynamique
echo "Test du redimensionnement des disques..." >> "$rapport"

# Redimensionnement avec VirtualBox
if [ "$vb_installed" = true ]; then
    if vboxmanage modifyhd "/tmp/VM_VirtualBox.vdi" --resize 20480 &> /dev/null; then
        echo "VirtualBox - Redimensionnement disque : Réussi" >> "$rapport"
    else
        echo "VirtualBox - Redimensionnement disque : Échec" >> "$rapport"
    fi
else
    echo "VirtualBox - Redimensionnement non testé." >> "$rapport"
fi

# Redimensionnement avec KVM
if [ "$kvm_installed" = true ]; then
    if qemu-img resize /tmp/VM_KVM.qcow2 +10G &> /dev/null; then
        echo "KVM - Redimensionnement disque : Réussi" >> "$rapport"
    else
        echo "KVM - Redimensionnement disque : Échec" >> "$rapport"
    fi
else
    echo "KVM - Redimensionnement non testé." >> "$rapport"
fi

# Test de convertibilité des machines virtuelles
echo "Test de convertibilité des machines virtuelles..." >> "$rapport"

# Conversion VirtualBox -> KVM
if [ "$vb_installed" = true ] && [ "$kvm_installed" = true ]; then
    echo "Conversion de VirtualBox vers KVM..." >> "$rapport"
    if qemu-img convert -f vdi -O qcow2 /tmp/VM_VirtualBox.vdi /tmp/VM_VirtualBox_to_KVM.qcow2 &> /dev/null; then
        echo "Conversion VirtualBox -> KVM : Réussi" >> "$rapport"
    else
        echo "Conversion VirtualBox -> KVM : Échec" >> "$rapport"
    fi
else
    echo "Conversion VirtualBox -> KVM non testé (outils manquants)." >> "$rapport"
fi

# Conversion KVM -> VirtualBox
if [ "$kvm_installed" = true ] && [ "$vb_installed" = true ]; then
    echo "Conversion de KVM vers VirtualBox..." >> "$rapport"
    if qemu-img convert -f qcow2 -O vdi /tmp/VM_KVM.qcow2 /tmp/VM_KVM_to_VirtualBox.vdi &> /dev/null; then
        echo "Conversion KVM -> VirtualBox : Réussi" >> "$rapport"
    else
        echo "Conversion KVM -> VirtualBox : Échec" >> "$rapport"
    fi
else
    echo "Conversion KVM -> VirtualBox non testé (outils manquants)." >> "$rapport"
fi

# Nettoyage des machines virtuelles de test
echo "Nettoyage des environnements de test..." >> "$rapport"
if [ "$vb_installed" = true ]; then
    vboxmanage unregistervm "VM_VirtualBox" --delete &> /dev/null
    rm -f /tmp/VM_VirtualBox.vdi /tmp/VM_VirtualBox_to_KVM.qcow2
fi
if [ "$kvm_installed" = true ]; then
    rm -f /tmp/VM_KVM.qcow2 /tmp/VM_KVM_to_VirtualBox.vdi
fi
if [ "$esxi_installed" = true ]; then
    govc vm.destroy -vm "VM_ESXi" &> /dev/null
fi

# Résumé
echo "Tests terminés avec succès. Résultats ci-dessus." >> "$rapport"
echo "Rapport disponible dans $rapport"
