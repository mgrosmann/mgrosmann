#!/bin/bash
for file in *.yaml; do
  if [ -f "$file" ]; then
    docker compose -f "$file" start
  else
    echo "Aucun fichier .yaml trouvé."
  fi
done
