#!/bin/bash
wget https://github.com/MediaBrowser/Emby.Releases/releases/download/4.8.10.0/emby-server-deb_4.8.10.0_amd64.deb
dpkg -i emby-server-deb_4.8.10.0_amd64.deb
ufw allow 8096