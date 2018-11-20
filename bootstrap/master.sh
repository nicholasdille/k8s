#!/bin/bash
set -e

# Instructions taken from https://kubernetes.io/docs/setup/independent/install-kubeadm/
# Changed installation directory for tools

# Install CNI plugins
CNI_VERSION="v0.6.0"
mkdir -p /opt/cni/bin
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz

# Install CRI tools
CRICTL_VERSION="v1.11.1"
curl -L "https://github.com/kubernetes-incubator/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz" | tar -C /usr/local/bin -xz

# Install kubernetes tools
RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
cd /usr/local/bin
curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/{kubeadm,kubelet,kubectl}
chmod +x {kubeadm,kubelet,kubectl}
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/kubelet.service" | sed "s:/usr/bin:/usr/local/bin:g" > /etc/systemd/system/kubelet.service
mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/10-kubeadm.conf" | sed "s:/usr/bin:/usr/local/bin:g" > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl enable kubelet
systemctl start kubelet

# Install packages
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
apt-get update
apt-get -y install ipvsadm ipset

# Init cluster
cd -
kubeadm config print-default > kubeadm.conf
patch kubeadm.conf < kubeadm.conf.patch
sed -i "s/advertiseAddress: 1.2.3.4/advertiseAddress: $(hostname -i)/" kubeadm.conf
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
