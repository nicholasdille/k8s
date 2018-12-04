#!/bin/bash
set -e

# Enable scheduling on master
kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-
