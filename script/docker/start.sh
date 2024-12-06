#!/bin/bash
for file in *.yaml; do
  docker compose -f "$file" up -d
done
docker ps --format "{{.ID}} {{.Names}}" | while read container_id container_name; do
  networks=$(docker inspect --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}' "$container_id")
  for network in $networks; do
    if ! docker network ls | grep -qw "$network"; then
      docker network create "$network"
    fi
  done
  docker start "$container_id"
  echo "le conteneur $container_name est démarré"
done
