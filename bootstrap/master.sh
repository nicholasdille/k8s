#!/bin/bash
set -e

# Init cluster
kubeadm config print init-defaults > kubeadm.conf
patch kubeadm.conf < kubeadm.conf.patch
sed -i "s/advertiseAddress: 1.2.3.4/advertiseAddress: $(hostname -i)/" kubeadm.conf
sed -i "s/token: abcdef.0123456789abcdef/token: $(kubeadm token generate)/" kubeadm.conf

if test -S /var/run/containerd/containerd.sock; then
    sed -i 's|criSocket: /var/run/dockershim.sock|criSocket: /var/run/containerd/containerd.sock|' kubeadm.conf
fi

kubeadm init --config ./kubeadm.conf --ignore-preflight-errors=NumCPU

rm kubeadm.conf

# Configure node ports
sed -i 's/- kube-apiserver/- kube-apiserver\n    - --service-node-port-range=1-65535/' /etc/kubernetes/manifests/kube-apiserver.yaml
