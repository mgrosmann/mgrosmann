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

# Fonction pour tester la convertibilité des machines virtuelles
test_vm_convertibility() {
    echo "=== Tests de convertibilité des machines virtuelles ===" >> $REPORT_FILE
    echo "Test de conversion P2V avec VMware vCenter Converter..." >> $REPORT_FILE
    # Ajoutez ici les commandes pour tester la conversion P2V
    echo "Test de conversion V2V avec Microsoft Virtual Machine Converter..." >> $REPORT_FILE
    # Ajoutez ici les commandes pour tester la conversion V2V
    echo "" >> $REPORT_FILE
}

# Fonction pour tester le redimensionnement dynamique des disques
test_dynamic_disk_resizing() {
    echo "=== Tests de redimensionnement dynamique des disques ===" >> $REPORT_FILE
    echo "Test de redimensionnement avec `qemu-img resize`..." >> $REPORT_FILE
    # Exemple de commande pour redimensionner un disque avec qemu-img
    qemu-img resize /path/to/disk.img +10G
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
test_vm_convertibility
test_dynamic_disk_resizing
send_report

echo "Script terminé avec succès."
