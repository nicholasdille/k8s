#!/bin/bash

test -n "${ACME_EMAIL}"
test -n "${DNS_DOMAIN}"

if test -n "${CLOUDFLARE_EMAIL}" && test -n "${CLOUDFLARE_API_KEY}"; then
    cat traefik-dns-secrets.yml | envsubst | kubectl apply -f -
    cat traefik-dns.yml | envsubst | kubectl apply -f -

else
    cat traefik-http.yml | envsubst | kubectl apply -f -
fi

kubectl apply -f traefik.yml
cat traefik-ui.yml | envsubst | kubectl apply -f -