#!/bin/bash

# Variables
NODES=("192.168.1.110" "192.168.1.111" "192.168.1.112")  # Liste des nœuds du cluster (adresse IP)
USER="mgrosmann"                            # Utilisateur SSH
PASSWORD="password"                         # Mot de passe SSH pour toutes les machines
VOLUME_NAME="data_volume"                   # Nom du volume GlusterFS
MOUNT_POINT="/mnt/glusterfs"                 # Point de montage local
REPORT_FILE="/tmp/glusterfs_report.txt"     # Fichier de rapport
DISK_PREFIX="/dev/sd"                       # Préfixe des disques à chercher
DISK_LABEL="brick"                          # Label pour identifier les disques vides

# Fonction pour formater et partitionner un disque
format_disk() {
    local node=$1
    local disk=$2
    echo "Formatage et partitionnement du disque $disk sur $node..."

    # Créer une table de partition GPT et partitionner
    sshpass -p "$PASSWORD" ssh "$USER@$node" "sudo parted $disk mklabel gpt -s"
    sshpass -p "$PASSWORD" ssh "$USER@$node" "sudo parted -a optimal $disk mkpart primary ext4 0% 100%"

    # Formater la partition en ext4
    sshpass -p "$PASSWORD" ssh "$USER@$node" "sudo mkfs.ext4 ${disk}1"

    # Créer le répertoire pour le brick GlusterFS
    sshpass -p "$PASSWORD" ssh "$USER@$node" "sudo mkdir -p /data/brick1"
    sshpass -p "$PASSWORD" ssh "$USER@$node" "sudo mount ${disk}1 /data/brick1"

    echo "Disque $disk formaté et monté sur /data/brick1 sur $node"
}

# Fonction pour ajouter un brick à GlusterFS
add_brick_to_gluster() {
    local node=$1
    echo "Ajout du brick à GlusterFS sur $node..."

    # Ajouter le brick à GlusterFS
    sshpass -p "$PASSWORD" ssh "$USER@$node" "sudo gluster volume add-brick $VOLUME_NAME ${USER}@${NODES[0]}:/data/brick1"
    if [ $? -ne 0 ]; then
        echo "Erreur lors de l'ajout du brick sur $node" >> $REPORT_FILE
        exit 1
    fi
}

# Fonction pour configurer le cluster GlusterFS
setup_glusterfs_cluster() {
    echo "Configuration du cluster GlusterFS..."

    # Ajouter les nœuds au cluster
    for NODE in "${NODES[@]:1}"; do
        sshpass -p "$PASSWORD" ssh "$USER@${NODES[0]}" "sudo gluster peer probe $NODE"
    done

    # Créer le volume GlusterFS
    sshpass -p "$PASSWORD" ssh "$USER@${NODES[0]}" "sudo gluster volume create $VOLUME_NAME replica 3 ${NODES[0]}:/data/brick1 ${NODES[1]}:/data/brick1 ${NODES[2]}:/data/brick1 force"
    sshpass -p "$PASSWORD" ssh "$USER@${NODES[0]}" "sudo gluster volume start $VOLUME_NAME"

    echo "Volume GlusterFS $VOLUME_NAME créé et démarré."
}

# Fonction pour monter le volume GlusterFS sur chaque machine
mount_glusterfs_volume() {
    echo "Montage du volume GlusterFS sur chaque nœud..."
    for NODE in "${NODES[@]}"; do
        sshpass -p "$PASSWORD" ssh "$USER@$NODE" "sudo mkdir -p $MOUNT_POINT"
        sshpass -p "$PASSWORD" ssh "$USER@$NODE" "sudo mount -t glusterfs ${NODES[0]}:$VOLUME_NAME $MOUNT_POINT"
    done
}

# Fonction pour rechercher un disque vide sur chaque nœud
find_empty_disk() {
    local node=$1
    echo "Recherche d'un disque vide sur $node..."

    # Vérifier les disques disponibles (on cherche les disques qui ne sont pas utilisés)
    for disk in /dev/sd?; do
        # Si le disque n'est pas déjà partitionné, il est considéré comme "vide"
        if ! sshpass -p "$PASSWORD" ssh "$USER@$node" "lsblk | grep ${disk}"; then
            echo "Disque vide trouvé: $disk sur $node"
            format_disk $node $disk
            break
        fi
    done
}

# Fonction principale pour configurer le cluster et les disques
main() {
    echo "=== Début de la configuration du cluster GlusterFS ===" > $REPORT_FILE

    # Installer GlusterFS et configurer le cluster sur chaque machine
    for NODE in "${NODES[@]}"; do
        echo "Vérification de la configuration de GlusterFS sur $NODE..."
        sshpass -p "$PASSWORD" ssh "$USER@$NODE" "dpkg -l | grep glusterfs-server || sudo apt update && sudo apt install -y glusterfs-server"
        sshpass -p "$PASSWORD" ssh "$USER@$NODE" "sudo systemctl start glusterd && sudo systemctl enable glusterd"
        find_empty_disk $NODE
    done

    # Configurer le cluster GlusterFS
    setup_glusterfs_cluster

    # Monter le volume GlusterFS sur chaque nœud
    mount_glusterfs_volume

    # Vérifier l'état du cluster
    echo "Vérification de l'état du volume GlusterFS..." >> $REPORT_FILE
    sshpass -p "$PASSWORD" ssh "$USER@${NODES[0]}" "sudo gluster volume info $VOLUME_NAME" >> $REPORT_FILE

    echo "=== Cluster GlusterFS configuré avec succès ===" >> $REPORT_FILE
}

# Exécuter la fonction principale
main
