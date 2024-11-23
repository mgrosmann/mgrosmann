#!/bin/bash

# Variables
EMAIL="grosmann14889@lasalle63.fr"
SUBJECT="Rapport de tests de virtualisation"
REPORT_FILE="/tmp/virtualization_report.txt"
API_KEY="d93122a21dde577e1672d0bd94fe2f0a"
API_SECRET="4621386e806cbb838353ae50e77ecfd6"
FROM_EMAIL="anonyme@example.com"
FROM_NAME="grosmann14889@lasalle63.fr"

# Créer un rapport fictif
echo "=== Rapport de tests de virtualisation ===" > $REPORT_FILE
echo "Les tests se sont déroulés correctement." >> $REPORT_FILE

# Envoyer le mail via Mailjet API
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

echo "Rapport envoyé via Mailjet."
























