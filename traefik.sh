#!/bin/bash
set -e

test -n "${ACME_EMAIL}"
test -n "${DNS_DOMAIN}"
test -f ./auth

if test -n "${CLOUDFLARE_EMAIL}" && test -n "${CLOUDFLARE_API_KEY}"; then
    cat traefik-dns-secrets.yml | envsubst | kubectl apply -f -
    cat traefik-dns.yml | envsubst | kubectl apply -f -

else
    cat traefik-http.yml | envsubst | kubectl apply -f -
fi

kubectl apply -f traefik.yml
cat auth | grep groot > traefik-auth
kubectl create secret generic traefik-auth --from-file traefik-auth --namespace kube-system
cat traefik-ui.yml | envsubst | kubectl apply -f -
