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
apt-get -y install socat ipvsadm ipset

# Disable swap
swapoff $(swapon --noheadings | cut -d' ' -f1)
