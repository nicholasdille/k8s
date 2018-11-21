#!/bin/bash
set -e

mkdir -p /opt/cni/bin /etc/cni/net.d

CNI_VERSION="v0.6.0"
curl -sL "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz

CNI_PLUGIN_VERSION="0.7.4"
curl -sL https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGIN_VERSION}/cni-plugins-amd64-v${CNI_PLUGIN_VERSION}.tgz | tar -C /opt/cni/bin -xz

cp bridge.conf /etc/cni/net.d/
