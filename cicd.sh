#!/bin/bash

# Install Docker registry
kubectl apply -f registry.yml
kubectl apply -f registry-web.yml

# Install gitea
kubectl apply -f gitea.yml

# Install drone server
kubectl apply -f drone.yml
curl -Ls https://github.com/drone/drone-cli/releases/download/v0.8.6/drone_linux_amd64.tar.gz | tar -xvz -C /usr/local/bin

# Install drone agent
kubectl apply -f dind.yml
kubectl apply -f drone-agent.yml

# XXX
kubectl create namespace cicd
openssl genrsa -out cicd.key 2048
openssl req -new -key cicd.key -out cicd.csr -subj "/CN=cicd/O=lab"
openssl x509 -req -in cicd.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out cicd.crt -days 500
useradd --create-home --shell /bin/bash cicd
mkdir ~cicd/.certs
mv cicd.* ~cicd/.certs/
kubectl config set-credentials cicd --client-certificate=/home/cicd/.certs/cicd.crt  --client-key=/home/cicd/.certs/cicd.key
kubectl config set-context cicd-context --cluster="Kubernetes master" --namespace=cicd --user=cicd
kubectl apply -f cicd.yml