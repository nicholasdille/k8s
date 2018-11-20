#!/bin/bash
set -e

RUNC_VERSION=1.0.0-rc5
curl -sL https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64 > /usr/local/bin/runc
chmod +x /usr/local/bin/runc
