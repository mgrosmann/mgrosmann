#!/bin/bash

# Variables
EMAIL="grosmann14889@lasalle63.fr"
SUBJECT="Alerte Cluster"
RAID5_DEVICES="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf"
RAID1_DEVICES="/dev/sdg /dev/sdh"
NODES=("192.168.1.101" "192.168.1.102" "192.168.1.103")
USER="ubuntu"
SSH_KEY="$HOME/.ssh/id_rsa"
MPI_HOSTFILE="/etc/mpi_hostfile"
SERVICE_NAME="apache2"  # Exemple de service à exécuter (par défaut Apache)

# Fonction pour vérifier l'état du service
check_service_status() {
    local node=$1
    local service=$2

    echo "Vérification du service $service sur $node..."
    ssh -i "$SSH_KEY" "$USER@$node" "systemctl is-active --quiet $service"
    if [ $? -ne 0 ]; then
        echo "$service n'est pas actif sur $node" | mail -s "$SUBJECT" $EMAIL
    else
        echo "$service est actif sur $node."
    fi
}

# Test de la connexion SSH sans mot de passe
check_ssh_connection() {
    for NODE in "${NODES[@]}"; do
        ssh -i "$SSH_KEY" "$USER@$NODE" "exit"
        if [ $? -ne 0 ]; then
            echo "Échec de la connexion SSH sans mot de passe à $NODE" | mail -s "$SUBJECT" $EMAIL
            exit 1
        fi
    done
}

# Installer et démarrer le service
install_and_start_service() {
    local node=$1
    local service=$2

    echo "Installation et démarrage du service $service sur $node..."
    ssh -i "$SSH_KEY" "$USER@$node" "sudo apt update && sudo apt install -y $service"
    if [ $? -ne 0 ]; then
        echo "Erreur lors de l'installation du service $service sur $node" | mail -s "$SUBJECT" $EMAIL
        exit 1
    fi
    ssh -i "$SSH_KEY" "$USER@$node" "sudo systemctl start $service"
    ssh -i "$SSH_KEY" "$USER@$node" "sudo systemctl enable $service"
}

# Configuration du fichier hostfile pour MPI
setup_mpi_hostfile() {
    echo "Configuration du fichier MPI hostfile..."
    sudo bash -c "cat > $MPI_HOSTFILE" <<EOF
localhost slots=$(nproc)
$(for NODE in "${NODES[@]}"; do echo "$NODE slots=$(nproc)"; done)
EOF
    sudo chmod 644 $MPI_HOSTFILE
}

# Test de la communication entre les nœuds du cluster
test_cluster_communication() {
    echo "Test de la communication entre les nœuds du cluster..."
    mpirun --hostfile $MPI_HOSTFILE hostname
}

# Exécution d'une application parallèle
run_parallel_application() {
    echo "Exécution de l'application parallèle sur le cluster..."
    echo -e "#include <mpi.h>\n#include <stdio.h>\n\nint main(int argc, char** argv) {\n    MPI_Init(&argc, &argv);\n    int world_size;\n    MPI_Comm_size(MPI_COMM_WORLD, &world_size);\n    int world_rank;\n    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);\n    char processor_name[MPI_MAX_PROCESSOR_NAME];\n    int name_len;\n    MPI_Get_processor_name(processor_name, &name_len);\n    printf(\"Hello from processor %s, rank %d out of %d processors\\n\", processor_name, world_rank, world_size);\n    MPI_Finalize();\n    return 0;\n" > hello_mpi.c
    mpicc -o hello_mpi hello_mpi.c
    mpirun --hostfile $MPI_HOSTFILE -np 6 ./hello_mpi
}

# Fonction principale
main() {
    # Vérifier la connexion SSH sans mot de passe
    check_ssh_connection

    # Installer et démarrer les services
    for NODE in "${NODES[@]}"; do
        install_and_start_service "$NODE" "$SERVICE_NAME"
    done

    # Configuration du fichier hostfile pour MPI
    setup_mpi_hostfile

    # Test de la communication entre les nœuds
    test_cluster_communication

    # Exécution de l'application parallèle
    run_parallel_application

    # Vérification du service sur chaque nœud
    for NODE in "${NODES[@]}"; do
        check_service_status "$NODE" "$SERVICE_NAME"
    done

    echo "Cluster configuré et applications lancées avec succès."
}

# Exécution du script principal
main