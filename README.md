# Introduction

My Kubernetes stuff

## Single-node cluster

Use the following user-data in Hetzner Cloud:

```bash
#!/bin/bash

export USER=root
export HOME=/root

git clone https://github.com/nicholasdille/k8s /tmp/kubernetes

cd /tmp/kubernetes
bash master.sh
bash helm.sh
kubectl apply -f traefik.yml
```

This will currently only work for Ubuntu 16.04.
