#!/bin/bash

# Variables
EMAIL="grosmann14889@lasalle63.fr"
SUBJECT="Alerte RAID"
RAID15="/dev/md15"  # Nom du RAID 15
RAID51="/dev/md51"  # Nom du RAID 51
REPORT_FILE="/tmp/raid_report.txt"

# Vérification de l'existence des disques
check_disks() {
    RAID1_DEVICES=()
    RAID5_DEVICES=()

    # Recherche de tous les disques /dev/sdX (ajustez selon votre besoin)
    for disk in /dev/sd?; do
        # Exclure les disques déjà utilisés pour RAID 1 ou RAID 5
        if [[ ! " ${RAID1_DEVICES[@]} " =~ " ${disk} " ]] && [[ ! " ${RAID5_DEVICES[@]} " =~ " ${disk} " ]]; then
            if [ ${#RAID1_DEVICES[@]} -lt 4 ]; then
                RAID1_DEVICES+=("$disk")
            elif [ ${#RAID5_DEVICES[@]} -lt 4 ]; then
                RAID5_DEVICES+=("$disk")
            fi
        fi
    done

    # Vérification de l'existence des disques
    for disk in "${RAID1_DEVICES[@]}" "${RAID5_DEVICES[@]}"; do
        if [ ! -e "$disk" ]; then
            echo "Erreur: Le disque $disk n'existe pas." | mail -s "$SUBJECT" $EMAIL
            exit 1
        fi
    done
}

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
    echo "=== Comparaison des RAID ===" > $REPORT_FILE
    if [ -e "$RAID15" ]; then
        echo "RAID 15 ($RAID15):" >> $REPORT_FILE
        mdadm --detail "$RAID15" >> $REPORT_FILE
    else
        echo "RAID 15 ($RAID15) n'est pas configuré." >> $REPORT_FILE
    fi

    if [ -e "$RAID51" ]; then
        echo "RAID 51 ($RAID51):" >> $REPORT_FILE
        mdadm --detail "$RAID51" >> $REPORT_FILE
    else
        echo "RAID 51 ($RAID51) n'est pas configuré." >> $REPORT_FILE
    fi
}

# Création des RAID
create_raid() {
    echo "Création des ensembles RAID imbriqués..." > $REPORT_FILE

    # Création des RAID 1 pour RAID 15
    echo "Création du RAID 1 pour RAID 15..." >> $REPORT_FILE
    mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 "${RAID1_DEVICES[@]:0:2}"
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du RAID 1" | mail -s "$SUBJECT" $EMAIL
        exit 1
    fi

    # Création du RAID 5 pour RAID 15 (en combinant RAID 1 existant)
    echo "Création du RAID 5 imbriqué (RAID 15)..." >> $REPORT_FILE
    mdadm --create --verbose "$RAID15" --level=5 --raid-devices=4 /dev/md1
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du RAID 15" | mail -s "$SUBJECT" $EMAIL
        exit 1
    fi

    # Création des RAID 5 pour RAID 51
    echo "Création du RAID 5 pour RAID 51..." >> $REPORT_FILE
    mdadm --create --verbose /dev/md5 --level=5 --raid-devices=4 "${RAID5_DEVICES[@]:0:4}"
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du RAID 5" | mail -s "$SUBJECT" $EMAIL
        exit 1
    fi

    # Création du RAID 1 pour RAID 51 (en combinant RAID 5 existant)
    echo "Création du RAID 1 imbriqué (RAID 51)..." >> $REPORT_FILE
    mdadm --create --verbose "$RAID51" --level=1 --raid-devices=2 /dev/md5
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du RAID 51" | mail -s "$SUBJECT" $EMAIL
        exit 1
    fi
}

# Mise en place des alertes email
setup_email_alerts() {
    echo "Mise en place des alertes RAID par email..." >> $REPORT_FILE
    check_raid_status "$RAID15" "RAID 15"
    check_raid_status "$RAID51" "RAID 51"
}

# Main
echo "=== Début de la configuration RAID ==="
check_disks
create_raid
compare_raid
setup_email_alerts
echo "=== Script RAID terminé avec succès ===" >> $REPORT_FILE
