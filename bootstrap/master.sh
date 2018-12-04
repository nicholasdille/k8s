#!/bin/bash
set -e

# Init cluster
kubeadm config print-default > kubeadm.conf
patch kubeadm.conf < kubeadm.conf.patch
sed -i "s/advertiseAddress: 1.2.3.4/advertiseAddress: $(hostname -i)/" kubeadm.conf

if test -S /var/run/containerd.sock; then
    sed -i 's|criSocket: /var/run/dockershim.sock|criSocket: /var/run/containerd/containerd.sock|' kubeadm.conf
fi
kubeadm init --config ./kubeadm.conf

# Get connection data
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Enable scheduling on master
kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-

# Configure node ports
sed -i 's/- kube-apiserver/- kube-apiserver\n    - --service-node-port-range=1-65535/' /etc/kubernetes/manifests/kube-apiserver.yaml
service kubelet restart
