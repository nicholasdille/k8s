#!/bin/bash
set -e

# Install helm
# https://docs.helm.sh/using_helm/#installing-helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Install tiller
kubectl apply -f tiller.yml
helm init --service-account tiller