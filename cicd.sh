#!/bin/bash

if ! -f ./auth; then
    echo "Please create users using htpasswd in file auth"
    exit 1
fi

export CICD_DNS_DOMAIN=go-nerd.de
export CICD_NAME_SUFFIX=.k8s

# Install Docker registry
kubectl create secret generic registry-auth --from-file auth
cat registry.yml | envsubst | kubectl apply -f -
cat registry-web.yml | envsubst | kubectl apply -f -

# Install gitea
cat gitea.yml | envsubst | kubectl apply -f -

# Install drone server
cat drone.yml | envsubst | kubectl apply -f -
curl -Ls https://github.com/drone/drone-cli/releases/download/v0.8.6/drone_linux_amd64.tar.gz | tar -xvz -C /usr/local/bin

# Install drone agent
kubectl apply -f dind.yml
kubectl apply -f drone-agent.yml

# Install WebDAV
kubectl create configmap webdav-auth --from-file htpasswd=auth
kubectl apply -f webdav.yml