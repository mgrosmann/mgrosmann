#!/bin/bash

# Variables
EMAIL="grosmann14889@lasalle63.fr"
SUBJECT="Alerte RAID"
RAID1_DEVICES="/dev/sda /dev/sdb /dev/sdc /dev/sdd"  # Disques pour RAID 1 (niveau inférieur du RAID 15)
RAID5_DEVICES="/dev/sde /dev/sdf /dev/sdg /dev/sdh"  # Disques pour RAID 5 (niveau inférieur du RAID 51)
RAID15="/dev/md15"  # Nom du RAID 15
RAID51="/dev/md51"  # Nom du RAID 51

# Fonction pour vérifier l'état du RAID
check_raid_status() {
    local raid_device=$1
    local raid_name=$2

    if [ -e "$raid_device" ]; then
        status=$(mdadm --detail "$raid_device" | grep 'State :' | awk '{print $3}')
        if [ "$status" != "clean" ]; then
            echo "RAID $raid_name ($raid_device) est en état $status" | mail -s "$SUBJECT" $EMAIL
        else
            echo "RAID $raid_name ($raid_device) est en bon état (clean)."
        fi
    else
        echo "RAID $raid_name ($raid_device) n'existe pas. Vérifiez la configuration." | mail -s "$SUBJECT" $EMAIL
    fi
}

# Comparaison des RAID
compare_raid() {
    echo "=== Comparaison des RAID ==="
    if [ -e "$RAID15" ]; then
        echo "RAID 15 ($RAID15):"
        mdadm --detail "$RAID15"
    else
        echo "RAID 15 ($RAID15) n'est pas configuré."
    fi

    if [ -e "$RAID51" ]; then
        echo "RAID 51 ($RAID51):"
        mdadm --detail "$RAID51"
    else
        echo "RAID 51 ($RAID51) n'est pas configuré."
    fi
}

# Création des RAID
create_raid() {
    echo "Création des ensembles RAID imbriqués..."

    # Création des RAID 1 pour RAID 15
    echo "Création du RAID 1 pour RAID 15..."
    mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 $RAID1_DEVICES

    # Création du RAID 5 pour RAID 15 (en combinant RAID 1 existant)
    echo "Création du RAID 5 imbriqué (RAID 15)..."
    mdadm --create --verbose "$RAID15" --level=5 --raid-devices=4 /dev/md1

    # Création des RAID 5 pour RAID 51
    echo "Création du RAID 5 pour RAID 51..."
    mdadm --create --verbose /dev/md5 --level=5 --raid-devices=4 $RAID5_DEVICES

    # Création du RAID 1 pour RAID 51 (en combinant RAID 5 existant)
    echo "Création du RAID 1 imbriqué (RAID 51)..."
    mdadm --create --verbose "$RAID51" --level=1 --raid-devices=2 /dev/md5
}

# Mise en place des alertes email
setup_email_alerts() {
    echo "Mise en place des alertes RAID par email..."
    check_raid_status "$RAID15" "RAID 15"
    check_raid_status "$RAID51" "RAID 51"
}

# Main
echo "=== Début de la configuration RAID ==="
create_raid
compare_raid
setup_email_alerts
echo "=== Script RAID terminé avec succès ==="
