#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
docker volume create portainer_data
docker volume inspect portainer_data 
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
