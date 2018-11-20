#!/bin/bash
set -e

CRICTL_VERSION="v1.11.1"
curl -sL "https://github.com/kubernetes-incubator/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz" | tar -C /usr/local/bin -xz
