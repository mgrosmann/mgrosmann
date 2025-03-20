#!/bin/bash
apt-get install blksnap -y
apt-get remove --purge veeam veeam-nosnap -y
apt-get autoremove -y
apt-get autoclean
apt-get update
apt-get install veeam -y
