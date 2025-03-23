#!/bin/bash
a2dismod mpm_event
a2enmod mpm_prefork
a2enmod php8.2
systemctl restart apache2
