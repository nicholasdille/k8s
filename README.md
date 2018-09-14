# Introduction

My Kubernetes stuff

## Single-node cluster

Use the following user-data in Hetzner Cloud:

```bash
#!/bin/bash

export USER=root
export HOME=/root
git clone https://github.com/nicholasdille/kubernetes /tmp/kubernetes
bash /tmp/kubernetes/master.sh
```

This will currently only work for Ubuntu 16.04.