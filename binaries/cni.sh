#!/bin/bash
set -e

CNI_VERSION="v0.6.0"
mkdir -p /opt/cni/bin
curl -sL "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz
