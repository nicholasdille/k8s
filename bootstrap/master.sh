#!/bin/bash
set -e

# Install packages
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
modprobe -- br_netfilter
sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.ipv4.ip_forward=1
apt-get update
apt-get -y install ipvsadm ipset

# Init cluster
kubeadm config print-default > kubeadm.conf
patch kubeadm.conf < kubeadm.conf.patch
sed -i "s/advertiseAddress: 1.2.3.4/advertiseAddress: $(hostname -i)/" kubeadm.conf
kubeadm init --config ./kubeadm.conf --ignore-preflight-errors=swap

# Get connection data
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Enable scheduling on master
kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-

# Configure node ports
sed -i 's/- kube-apiserver/- kube-apiserver\n    - --service-node-port-range=1-65535/' /etc/kubernetes/manifests/kube-apiserver.yaml
service kubelet restart
