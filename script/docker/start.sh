#!/bin/bash
for file in *.yaml; do
  docker compose -f "$file" start
done
docker ps -a -q | while read container_id; do
  networks=$(docker inspect --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}' "$container_id")
  for network in $networks; do
    if ! docker network ls | grep -qw "$network"; then
      docker network create "$network"
    fi
  done
  docker start "$container_id"
done