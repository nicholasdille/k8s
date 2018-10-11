#!/bin/bash
set -e

# Install Docker
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
cat > /etc/apt/preference.d/docker <<EOF
Package: docker-ce
Pin: version 18.06.*
Pin-Priority: 1000
EOF
apt-get update
apt-get install -y docker-ce

# Install docker-compose
curl -Ls https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
