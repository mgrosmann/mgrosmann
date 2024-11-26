#!/bin/bash

# Fonction pour désinstaller PHP sur Ubuntu/Debian
remove_php_ubuntu() {
    echo "Désinstallation de PHP et de ses extensions sur Ubuntu/Debian..."
    sudo apt-get purge -y 'php*'    # Supprime PHP et toutes les extensions
    sudo apt-get autoremove -y       # Supprime les dépendances inutilisées
    sudo apt-get clean               # Nettoie les fichiers inutiles
    echo "PHP et ses modules ont été supprimés."
}

# Fonction pour désinstaller PHP sur macOS (via Homebrew)
remove_php_macos() {
    echo "Désinstallation de PHP et de ses extensions sur macOS..."
    brew list | grep php | xargs brew uninstall --force  # Désinstalle toutes les versions de PHP
    brew cleanup                               # Nettoie les fichiers inutiles
    echo "PHP et ses modules ont été supprimés sur macOS."
}

# Vérification du système d'exploitation
OS=$(uname)

if [[ "$OS" == "Linux" ]]; then
    # Vérifier si le système est basé sur Ubuntu/Debian
    if [ -f /etc/os-release ]; then
        DISTRO=$(grep -i 'ubuntu\|debian' /etc/os-release)
        if [[ ! -z "$DISTRO" ]]; then
            remove_php_ubuntu
        else
            echo "Ce script est conçu pour Ubuntu/Debian. Distribution non supportée sur Linux."
        fi
    else
        echo "Impossible de déterminer la distribution Linux."
    fi
elif [[ "$OS" == "Darwin" ]]; then
    # Si le système est macOS
    remove_php_macos
else
    echo "Système d'exploitation non pris en charge. Ce script est conçu pour Linux (Ubuntu/Debian) et macOS."
fi

