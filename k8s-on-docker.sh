#!/bin/bash
set -e

cd binaries
bash docker.sh
bash k8s.sh
cd ..

cd bootstrap
bash prepare.sh
bash master.sh
