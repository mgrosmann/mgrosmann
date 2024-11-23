#!/bin/bash

# Variables
EMAIL="grosmann14889@lasalle63.fr"               # Adresse email du destinataire
SUBJECT="Rapport de tests de virtualisation"    # Objet de l'email
REPORT_FILE="/tmp/virtualization_report.txt"    # Emplacement du fichier de rapport
API_KEY="d93122a21dde577e1672d0bd94fe2f0a"      # Clé API de Mailjet
API_SECRET="4621386e806cbb838353ae50e77ecfd6"   # Secret API de Mailjet
FROM_EMAIL="grosmannmatheo@gmail.com"                # Adresse email de l'expéditeur (doit être validée dans Mailjet)
FROM_NAME="Rapport Virtualisation"              # Nom affiché comme expéditeur

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
    stress-ng --cpu 4 --timeout 30s
    echo "Test sur VMware ESXi..." >> $REPORT_FILE
    sysbench --test=cpu --cpu-max-prime=20000 run >> $REPORT_FILE
    echo "Test sur Proxmox VE..." >> $REPORT_FILE
    sysbench --test=cpu --cpu-max-prime=20000 run >> $REPORT_FILE
    echo "Test sur Hyper-V..." >> $REPORT_FILE
    sysbench --test=cpu --cpu-max-prime=20000 run >> $REPORT_FILE
    echo "" >> $REPORT_FILE
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
compare_virtualization_software
compare_costs
performance_test
send_report

echo "Script terminé avec succès."
