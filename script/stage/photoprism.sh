#!/bin/bash
read -p "Entrez le chemin du volume de données pour PhotoPrism : " data_path
docker volume create photoprism
docker run -d \
  --name photoprism \
  -p 2342:2342 \
  -v photoprism:/photoprism/storage \
  -v "$data_path:/photoprism/originals" \
  -e PHOTOPRISM_ADMIN_PASSWORD="root" \
  photoprism/photoprism:latest

echo "Le conteneur PhotoPrism a été créé et lancé."
echo "Accédez à PhotoPrism à l'adresse : http://localhost:2342"