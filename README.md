# Introduction

My Kubernetes stuff

## Single-node cluster

Use the following user-data in Hetzner Cloud:

```bash
#!/bin/bash

git clone https://github.com/nicholasdille/kubernetes /tmp/kubernetes
bash /tmp/kubernetes/master.sh
```