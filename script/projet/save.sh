SOURCE_DIR="/home/mgrosmann/desktop"
BACKUP_DIR="/home/mgrosmann/backup"
REMOTE_USER="mgrosmann"
REMOTE_HOST="192.168.1.45"
REMOTE_DIR="/home/mgrosmann/save"

# Sauvegarder le répertoire local vers le serveur distant
rsync -avz $SOURCE_DIR $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR

