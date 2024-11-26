#!/bin/bash
USER="mgrosmann"
HOST="192.168.1.110"
PASSWORD="password"
COMMAND="hostname -I"
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o BatchMode=no "$USER@$HOST" "$COMMAND"