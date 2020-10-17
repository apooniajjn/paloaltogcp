#!/bin/bash
set -e
echo "*****    Installing Nginx    *****"
apt update
apt install -y nginx

systemctl enable nginx
systemctl restart nginx

echo "*****   Installation Complteted!!   *****"

echo "Welcome to Google Compute VM Instance deployed using Terraform!!!" > /var/www/html

echo "*****   Startup script completes!!    *****"