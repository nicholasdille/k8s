#!/bin/bash

export CICD_DNS_DOMAIN=dille.io

cat shellinabox.yml | envsubst | kubectl apply -f -
cat theia.yml | envsubst | kubectl apply -f -