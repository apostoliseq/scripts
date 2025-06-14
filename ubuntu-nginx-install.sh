#!/bin/bash

set -e

sudo apt update -y
sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

if ! gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg | grep -q "573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62"; then
    echo "Error: nginx signing key fingerprint verification failed"
    exit 1
fi

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx

sudo apt update -y
sudo apt install -y nginx

sudo systemctl start nginx
sudo systemctl enable nginx
