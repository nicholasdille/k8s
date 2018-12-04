#!/bin/bash
set -e

patch /etc/systemd/system/kubelet.service.d/10-kubeadm.conf < 10-kubeadm.conf.patch

mkdir -p /etc/systemd/system/kubelet.service.d/
cp 0-containerd.conf /etc/systemd/system/kubelet.service.d/

systemctl daemon-reload

echo "runtime-endpoint: unix:///run/containerd/containerd.sock" > /etc/crictl.yaml
