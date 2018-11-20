#!/bin/bash
set -e

export CICD_DNS_DOMAIN=go-nerd.de
export CICD_NAME_SUFFIX=.k8s

cat influxdb.yml | envsubst | kubectl apply -f -
kubectl apply -f telegraf.yml
cat grafana.yml | envsubst | kubectl apply -f -