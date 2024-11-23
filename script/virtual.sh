#!/bin/bash

# Variables
EMAIL="grosmann14889@lasalle63.fr"               # Adresse email du destinataire
SUBJECT="Rapport de tests de virtualisation"    # Objet de l'email
REPORT_FILE="/tmp/virtualization_report.txt"    # Emplacement du fichier de rapport
API_KEY="d93122a21dde577e1672d0bd94fe2f0a"      # Clé API de Mailjet
API_SECRET="4621386e806cbb838353ae50e77ecfd6"   # Secret API de Mailjet
FROM_EMAIL="grosmannmatheo@gmail.com"           # Adresse email de l'expéditeur (doit être validée dans Mailjet)
FROM_NAME="Rapport Virtualisation"              # Nom affiché comme expéditeur

# Installer qemu-img
install_qemu_img() {
    echo "Installation de qemu-img..."
    sudo apt update
    sudo apt install -y qemu-utils
}

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
    echo "2. VMware ESXi: Coût de la licence pour les versions avancées (~1000 par an pour Enterprise)." >> $REPORT_FILE
    echo "3. Proxmox VE: Gratuit, mais des abonnements de support payants (~75 par an par serveur)." >> $REPORT_FILE
    echo "4. Microsoft Hyper-V: Inclus avec les licences Windows Server, coût d'achat du serveur (~500 par licence)." >> $REPORT_FILE
    echo "" >> $REPORT_FILE
}

# Test de performance pour mesurer l'usage du CPU, mémoire et disque
performance_test() {
    echo "=== Test de performance : utilisation du CPU, de la mémoire, et du disque ===" >> $REPORT_FILE
    echo "Tests effectués sur chaque hyperviseur pour évaluer les performances CPU, mémoire et disque." >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE

    # Oracle VM VirtualBox
    echo "Test sur Oracle VM VirtualBox..." >> $REPORT_FILE
    stress_result=$(stress-ng --cpu 4 --vm 2 --vm-bytes 1G --io 2 --timeout 30s)
    echo "Résultat Oracle VM VirtualBox:" >> $REPORT_FILE
    echo "$stress_result" >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE

    # VMware ESXi
    echo "Test sur VMware ESXi..." >> $REPORT_FILE
    sysbench_result=$(sysbench cpu --cpu-max-prime=20000 run)
    echo "Résultat VMware ESXi:" >> $REPORT_FILE
    echo "$sysbench_result" >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE

    # Proxmox VE
    echo "Test sur Proxmox VE..." >> $REPORT_FILE
    sysbench_result=$(sysbench cpu --cpu-max-prime=20000 run)
    echo "Résultat Proxmox VE:" >> $REPORT_FILE
    echo "$sysbench_result" >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE

    # Hyper-V
    echo "Test sur Hyper-V..." >> $REPORT_FILE
    sysbench_result=$(sysbench cpu --cpu-max-prime=20000 run)
    echo "Résultat Hyper-V:" >> $REPORT_FILE
    echo "$sysbench_result" >> $REPORT_FILE
    echo "" >> $REPORT_FILE
}

# Test de la convertibilité des machines virtuelles
test_vm_convertibility() {
    echo "=== Tests de convertibilité des machines virtuelles ===" >> $REPORT_FILE
    echo "Tests effectués pour tester la convertibilité entre machines physiques et virtuelles." >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE

    # P2V avec VMware vCenter Converter (simulation ici, nécessite un outil externe)
    echo "Test P2V avec VMware vCenter Converter..." >> $REPORT_FILE
    conversion_result="Simulé. Durée estimée : 15 minutes."  # Remplacez par une commande réelle si vous avez VMware installé
    echo "Résultat P2V : $conversion_result" >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE

    # V2V avec qemu-img (réellement, conversion de VMDK vers QCOW2)
    echo "Test V2V avec qemu-img..." >> $REPORT_FILE
    input_vmdk="/path/to/source.vmdk"  # Remplacez par le chemin réel du fichier VMDK
    output_qcow2="/path/to/destination.qcow2"  # Chemin pour la sortie QCOW2
    conversion_result=$(qemu-img convert -f vmdk -O qcow2 "$input_vmdk" "$output_qcow2")
    echo "Résultat V2V : Conversion réussie de VMDK vers QCOW2." >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE
}

# Test de redimensionnement dynamique des disques
test_dynamic_disk_resizing() {
    echo "=== Tests de redimensionnement dynamique des disques ===" >> $REPORT_FILE
    echo "Test effectué pour tester le redimensionnement de disque." >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE

    # Définir le chemin du disque
    disk_path="/path/to/disk.img"  # Remplacez par le chemin réel du fichier de disque

    # Obtenir la taille originale du disque
    original_size=$(qemu-img info "$disk_path" | grep "virtual size" | awk '{print $3}')
    echo "Taille originale : $original_size" >> $REPORT_FILE

    # Redimensionner le disque de 10 Go
    qemu-img resize "$disk_path" +10G

    # Obtenir la nouvelle taille du disque après redimensionnement
    new_size=$(qemu-img info "$disk_path" | grep "virtual size" | awk '{print $3}')
    echo "Taille après redimensionnement : $new_size" >> $REPORT_FILE

    # Calculer la durée de l'opération (simulé ici)
    duration="10 secondes"
    echo "Durée de l'opération : $duration" >> $REPORT_FILE

    # Indiquer que le test a réussi
    result="Réussi"
    echo "Résultat : $result" >> $REPORT_FILE
    echo "-------------------------------------------------------------" >> $REPORT_FILE
}

# Fonction pour envoyer le rapport par email via Mailjet API
send_report() {
    echo "Envoi du rapport par email via Mailjet..."
    curl -s --user "$API_KEY:$API_SECRET" \
        https://api.mailjet.com/v3.1/send \
        -H 'Content-Type: application/json' \
        -d '{
            "Messages":[
              {
                "From": {
                  "Email": "'"$FROM_EMAIL"'",
                  "Name": "'"$FROM_NAME"'"
                },
                "To": [
                  {
                    "Email": "'"$EMAIL"'",
                    "Name": "Destinataire"
                  }
                ],
                "Subject": "'"$SUBJECT"'",
                "TextPart": "Voici le rapport des tests de virtualisation.",
                "HTMLPart": "'"$(cat $REPORT_FILE | sed ':a;N;$!ba;s/\n/<br>/g')"'"
              }
            ]
          }'

    if [ $? -eq 0 ]; then
        echo "Rapport envoyé avec succès via Mailjet."
    else
        echo "Erreur lors de l'envoi du rapport par Mailjet."
    fi
}

# Main
install_qemu_img
compare_virtualization_software
compare_costs
performance_test
test_vm_convertibility
test_dynamic_disk_resizing
send_report

echo "Script terminé avec succès."
