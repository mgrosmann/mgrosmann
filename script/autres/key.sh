#!/bin/bash
USER="mgrosmann"
SERVER="sio.jbdelasalle.com"
PORT=1622
KEY_NAME="id_rsa"
REMOTE_DIR="/home/SIO/$USER/.ssh"
LOCAL_SSH_DIR="/root/.ssh"
ssh -p $PORT $USER@$SERVER << EOF
  mkdir -p $REMOTE_DIR
  chmod 700 $REMOTE_DIR
  if [ ! -f $REMOTE_DIR/$KEY_NAME ]; then
    ssh-keygen -t rsa -b 2048 -f $REMOTE_DIR/$KEY_NAME -q -N ""
    echo "Clé SSH générée avec succès sur le serveur."
  else
    echo "Clé SSH déjà existante sur le serveur, pas besoin de la régénérer."
  fi
EOF
scp -P $PORT $USER@$SERVER:$REMOTE_DIR/$KEY_NAME $LOCAL_SSH_DIR/
if [ $? -ne 0 ]; then
    echo "Erreur lors du téléchargement de la clé privée depuis le serveur."
    exit 1
fi
chmod 600 $LOCAL_SSH_DIR/$KEY_NAME
if ! eval "$(ssh-agent -s)"; then
    echo "Erreur lors du démarrage de ssh-agent."
    exit 1
fi
ssh-add $LOCAL_SSH_DIR/$KEY_NAME
if [ $? -ne 0 ]; then
    echo "Erreur lors de l'ajout de la clé privée à ssh-agent."
    exit 1
fi
ssh -p $PORT $USER@$SERVER << EOF
  cat $REMOTE_DIR/${KEY_NAME}.pub >> $REMOTE_DIR/authorized_keys
  chmod 600 $REMOTE_DIR/authorized_keys
EOF
ssh -i $LOCAL_SSH_DIR/$KEY_NAME -p $PORT $USER@$SERVER "echo 'Connexion SSH sans mot de passe réussie.'"
if [ $? -eq 0 ]; then
    echo "Les clés SSH ont été configurées avec succès pour une connexion sans mot de passe au serveur $SERVER."
else
    echo "Erreur : La connexion sans mot de passe a échoué. Vérifiez la configuration."
    exit 1
fi
