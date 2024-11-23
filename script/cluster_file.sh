#!/bin/bash

# Variables
NODES=("192.168.1.101" "192.168.1.102" "192.168.1.103") # Remplacez par les adresses IP de vos nœuds
USER="ubuntu"
VOLUME_NAME="data_volume"
MOUNT_POINT="/mnt/glusterfs"

# Installer GlusterFS sur tous les nœuds
install_glusterfs() {
    for NODE in "${NODES[@]}"; do
        ssh "$USER@$NODE" "sudo apt update && sudo apt install -y glusterfs-server"
        ssh "$USER@$NODE" "sudo systemctl start glusterd && sudo systemctl enable glusterd"
    done
}

# Configurer le cluster GlusterFS
setup_glusterfs_cluster() {
    # Ajouter les nœuds au cluster
    for NODE in "${NODES[@]:1}"; do
        ssh "$USER@${NODES[0]}" "sudo gluster peer probe $NODE"
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
install_glusterfs
setup_glusterfs_cluster
mount_glusterfs_volume

echo "Cluster GlusterFS configuré avec succès."
