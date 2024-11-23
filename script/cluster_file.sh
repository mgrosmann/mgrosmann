#!/bin/bash

# Variables
EMAIL="grosmann14889@lasalle63.fr"
SUBJECT="Alerte GlusterFS"
NODES=("192.168.1.101" "192.168.1.102" "192.168.1.103") # Remplacez par les adresses IP de vos nœuds
USER="ubuntu"
VOLUME_NAME="data_volume"
MOUNT_POINT="/mnt/glusterfs"
REPORT_FILE="/tmp/glusterfs_report.txt"

# Vérification de l'existence des disques
check_disks() {
    for NODE in "${NODES[@]}"; do
        ssh "$USER@$NODE" "df -h | grep -q '$MOUNT_POINT' || { echo 'Volume non monté sur $NODE'; exit 1; }"
    done
}

# Installer GlusterFS sur tous les nœuds
install_glusterfs() {
    for NODE in "${NODES[@]}"; do
        ssh "$USER@$NODE" "dpkg -l | grep glusterfs-server || sudo apt update && sudo apt install -y glusterfs-server"
        ssh "$USER@$NODE" "sudo systemctl start glusterd && sudo systemctl enable glusterd"
    done
}

# Configurer le cluster GlusterFS
setup_glusterfs_cluster() {
    # Ajouter les nœuds au cluster
    for NODE in "${NODES[@]:1}"; do
        ssh "$USER@${NODES[0]}" "sudo gluster peer probe $NODE"
    done

    # Créer les répertoires de brick
    for NODE in "${NODES[@]}"; do
        ssh "$USER@$NODE" "sudo mkdir -p /data/brick1"
    done

    # Créer un volume GlusterFS
    ssh "$USER@${NODES[0]}" "sudo gluster volume create $VOLUME_NAME replica 3 ${NODES[0]}:/data/brick1 ${NODES[1]}:/data/brick1 ${NODES[2]}:/data/brick1 force"
    ssh "$USER@${NODES[0]}" "sudo gluster volume start $VOLUME_NAME"
}

# Monter le volume GlusterFS sur tous les nœuds
mount_glusterfs_volume() {
    for NODE in "${NODES[@]}"; do
        ssh "$USER@$NODE" "sudo mkdir -p $MOUNT_POINT"
        ssh "$USER@$NODE" "sudo mount -t glusterfs ${NODES[0]}:$VOLUME_NAME $MOUNT_POINT"
    done
}

# Main
echo "=== Début de la configuration GlusterFS ===" > $REPORT_FILE
install_glusterfs
setup_glusterfs_cluster
mount_glusterfs_volume
check_disks
echo "=== Cluster GlusterFS configuré avec succès. ===" >> $REPORT_FILE

# Envoi du rapport par email
echo "Envoi du rapport par email à $EMAIL..."
mail -s "$SUBJECT" $EMAIL < $REPORT_FILE
