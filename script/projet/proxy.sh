#!/bin/bash
echo 'Acquire::http::proxy  "http://192.168.151.254:3128/";' > /etc/apt/apt.conf
echo 'Acquire::https::proxy "http://192.168.151.254:3128/";' >> /etc/apt/apt.conf
export http_proxy="http://192.168.151.254:3128"
export https_proxy="http://192.168.151.254:3128"
git config --global http.proxy http://192.168.151.254:3128
git config --global https.proxy http://192.168.151.254:3128
mkdir -p /etc/systemd/system/docker.service.d
echo "[Service]" >> /etc/systemd/system/docker.service.d/http-proxy.conf
echo "Environment="HTTP_PROXY=http://192.168.152.254:3128/" "HTTPS_PROXY=http://192.168.152.254:3128/"" >> /etc/systemd/system/docker.service.d/http-proxy.conf
