#!/bin/bash
set -e

CONTAINERD_VERSION=1.2.0

curl -sL https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}.linux-amd64.tar.gz | tar -xz -C /usr/local/

curl -sL https://storage.googleapis.com/cri-containerd-release/cri-containerd-${CONTAINERD_VERSION}.linux-amd64.tar.gz | tar -xz -C / ./etc/systemd/system/containerd.service

apt-get update
apt-get -y install unzip tar apt-transport-https btrfs-tools libseccomp2 socat util-linux

mkdir -p /etc/systemd/system/kubelet.service.d/
cp 0-containerd.conf /etc/systemd/system/kubelet.service.d/

systemctl daemon-reload
