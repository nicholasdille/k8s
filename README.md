# Introduction

My Kubernetes stuff

## Single-node cluster

Use the following user-data in Hetzner Cloud:

```bash
#!/bin/bash

export USER=root
export HOME=/root

git clone https://github.com/nicholasdille/k8s /tmp/k8s

cd /tmp/k8s
bash docker.sh
bash master.sh
kubectl apply -f traefik.yml
```

This will currently only work for Ubuntu 16.04.

## Helm

Install `helm`:

```bash
bash helm.sh
```

To install `traefik` using `helm`:

```bash
helm install stable/traefik --values helm-traefik-values.yml
```

## Completion

To enable completion for `kubectl` commands and cluster objects:

```bash
source <(kubectl completion bash)
```

## Testing

Open a proxy into your cluster:

```
kubectl proxy
curl http://127.0.0.1:8001/api/v1/namespaces/default/services/docker-registry-web:web/proxy/home
```