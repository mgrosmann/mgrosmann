#!/bin/bash

# Variables
EMAIL="grosmann14889@lasalle63.fr"
SUBJECT="Rapport de tests de virtualisation"
REPORT_FILE="/tmp/virtualization_report.txt"

# Fonction pour comparer les logiciels de virtualisation
compare_virtualization_software() {
    echo "=== Comparaison des logiciels de virtualisation ===" > $REPORT_FILE
    echo "1. Oracle VM VirtualBox: Gratuit, bonne performance, simplicité d'utilisation." >> $REPORT_FILE
    echo "2. VMware ESXi: Coût élevé, excellente performance, complexité modérée." >> $REPORT_FILE
    echo "3. Proxmox VE: Gratuit (open source), bonne performance, flexibilité élevée." >> $REPORT_FILE
    echo "4. Microsoft Hyper-V: Inclus avec Windows Server, bonne performance, simplicité pour les environnements Windows." >> $REPORT_FILE
    echo "" >> $REPORT_FILE
}

# Comparaison des coûts des logiciels de virtualisation
compare_costs() {
    echo "=== Comparaison des coûts des logiciels de virtualisation ===" >> $REPORT_FILE
    echo "1. Oracle VM VirtualBox: Gratuit (open source)." >> $REPORT_FILE
    echo "2. VMware ESXi: Coût de la licence pour les versions avancées (~$1000 par an pour Enterprise)." >> $REPORT_FILE
    echo "3. Proxmox VE: Gratuit, mais des abonnements de support payants (~$75 par an par serveur)." >> $REPORT_FILE
    echo "4. Microsoft Hyper-V: Inclus avec les licences Windows Server, coût d'achat du serveur (~$500 par licence)." >> $REPORT_FILE
    echo "" >> $REPORT_FILE
}

# Test de performance pour mesurer l'usage du CPU et de la mémoire
performance_test() {
    echo "=== Test de performance : utilisation du CPU et de la mémoire ===" >> $REPORT_FILE
    echo "Test sur Oracle VM VirtualBox..." >> $REPORT_FILE
    # Exemple avec stress-ng pour tester la consommation CPU
    stress-ng --cpu 4 --timeout 30s
    echo "Test sur VMware ESXi..." >> $REPORT_FILE
    # Exécutez un test de performance similaire sur VMware (par exemple avec sysbench)
    sysbench --test=cpu --cpu-max-prime=20000 run
    echo "Test sur Proxmox VE..." >> $REPORT_FILE
    sysbench --test=cpu --cpu-max-prime=20000 run
    echo "Test sur Hyper-V..." >> $REPORT_FILE
    sysbench --test=cpu --cpu-max-prime=20000 run
    echo "" >> $REPORT_FILE
}

# Fonction pour tester la convertibilité des machines virtuelles
test_vm_convertibility() {
    echo "=== Tests de convertibilité des machines virtuelles ===" >> $REPORT_FILE
    echo "Test de conversion P2V avec VMware vCenter Converter..." >> $REPORT_FILE
    # Commande d'exemple pour convertir une machine physique en machine virtuelle (P2V)
    echo "Test de conversion V2V avec qemu-img..." >> $REPORT_FILE
    # Exemple de conversion V2V (Virtual to Virtual) avec qemu-img
    qemu-img convert -f vmdk -O qcow2 /path/to/source.vmdk /path/to/destination.qcow2
    echo "Conversion V2V terminée." >> $REPORT_FILE
    echo "" >> $REPORT_FILE
}

# Fonction pour tester le redimensionnement dynamique des disques
test_dynamic_disk_resizing() {
    echo "=== Tests de redimensionnement dynamique des disques ===" >> $REPORT_FILE
    echo "Test de redimensionnement avec qemu-img..." >> $REPORT_FILE
    original_size=$(qemu-img info /path/to/disk.img | grep "virtual size" | awk '{print $3}')
    qemu-img resize /path/to/disk.img +10G
    new_size=$(qemu-img info /path/to/disk.img | grep "virtual size" | awk '{print $3}')
    echo "Taille originale: $original_size, Taille après redimensionnement: $new_size" >> $REPORT_FILE
    echo "Redimensionnement terminé." >> $REPORT_FILE
    echo "" >> $REPORT_FILE
}

# Fonction pour envoyer le rapport par email
send_report() {
    echo "Envoi du rapport par email à $EMAIL..."
    mail -s "$SUBJECT" $EMAIL < $REPORT_FILE
    echo "Rapport envoyé."
}

# Main
compare_virtualization_software
compare_costs
performance_test
test_vm_convertibility
test_dynamic_disk_resizing
send_report

echo "Script terminé avec succès."
