#!/bin/bash
set -e

cd binaries
bash runc.sh
bash crictl.sh
bash cni.sh
bash containerd.sh
bash k8s.sh
cd ..

cd runtime
bash containerd.sh
cd ..

cd bootstrap
bash prepare.sh
bash master.sh
bash untaint.sh
bash admin.sh
cd ..
