#!/bin/bash
set -e

patch /etc/systemd/system/kubelet.service.d/10-kubeadm.conf < 10-kubeadm.conf
systemctl daemon-reload
