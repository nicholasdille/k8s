# Introduction

My Kubernetes stuff

## Single-node cluster with containerd

Use the following user-data in Hetzner Cloud:

```bash
#!/bin/bash

export USER=root
export HOME=/root

git clone https://github.com/nicholasdille/k8s /tmp/k8s

cd /tmp/k8s/binaries
bash runc.sh
bash cni.sh
bash crictl.sh
bash containerd.sh

cd /tmp/k8s/bootstrap
bash master.sh
```

To bootstrap kubernetes based on Docker only run `bash docker.sh` from `binaries/`.

## Completion

To enable completion for `kubectl` commands and cluster objects:

```bash
source <(kubectl completion bash)
```

## Testing

Open a proxy into your cluster:

```bash
kubectl proxy
curl http://127.0.0.1:8001/api/v1/namespaces/default/services/docker-registry-web:web/proxy/home
```

## Templating

How to parameterize:

```bash
cat gitea.yml.envsubst | GITEA_IMAGE_TAG=1.5 PUBLISH_DOMAIN=gitea.k8s.go-nerd.de envsubst
```

Or use helm.

## Connect to cluster

```bash
kubectl config set-cluster kubernetes --server=https://1.2.3.4:6443 --certificate-authority=./ca.crt --embed-certs
kubectl config set-credentials cicd --client-key=user.key --client-certificate=user.crt --embed-certs
kubectl config set-context kubernetes-context --cluster=kubernetes --user=cicd --namespace=cicd
kubectl config use-context kubernetes-context
```

## Custom API users with certificate authentication

1. Create user certificates:

    ```bash
    kubectl create namespace cicd
    openssl genrsa -out cicd.key 2048
    openssl req -new -key cicd.key -out cicd.csr -subj "/CN=cicd/O=lab"
    openssl x509 -req -in cicd.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out cicd.crt -days 500
    ```

1. Create new context:

    ```bash
    kubectl config set-credentials cicd --client-certificate=/home/cicd/.certs/cicd.crt  --client-key=/home/cicd/.certs/cicd.key
    kubectl config set-context cicd-context --cluster="Kubernetes master" --namespace=cicd --user=cicd
    ```

1. Create role and rolebinding:

    ```bash
    kubectl apply -f - <<EOF
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1beta1
    metadata:
      namespace: cicd
      name: deployment-manager
    rules:
    - apiGroups: ["", "extensions", "apps"]
      resources: ["deployments", "replicasets", "pods"]
      verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
    ---
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1beta1
    metadata:
      name: deployment-manager-binding
      namespace: cicd
    subjects:
    - kind: User
      name: cicd
      apiGroup: ""
    roleRef:
      kind: Role
      name: deployment-manager
      apiGroup: ""
    EOF
    ```

More information about clusters and contexts: https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/

## Custom API users with token authentication

1. Create service account:

    ```bash
    kubectl create serviceaccount myuser
    ```

1. Create role and role binding:

    ```bash
    kubectl apply -f - <<EOF
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1beta1
    metadata:
      namespace: default
      name: deployment-manager
    rules:
    - apiGroups: ["", "extensions", "apps", "batch", "autoscaling"]
      resources: ["services", "deployments", "replicasets", "pods", "replicationcontrollers", "jobs", "cronjobs", "daemonsets", "statefulsets", "horizontalpodautoscalers"]
      verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
    ---
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1beta1
    metadata:
      name: deployment-manager-binding
      namespace: default
    subjects:
    - kind: ServiceAccount
      name: myuser
      apiGroup: ""
    roleRef:
      kind: Role
      name: deployment-manager
      apiGroup: ""
    EOF
    ```

1. Create kubeconfig:

    ```bash
    SECRET_NAME=$(kubectl get serviceaccount myuser -o json | jq --raw-output '.secrets[].name')
    kubectl get secrets ${SECRET_NAME} -o json | jq --raw-output '.data.token' | base64 -d
    kubectl config set-cluster kubernetes --server=https://1.2.3.4:6443 --certificate-authority=./ca.crt --embed-certs
    kubectl config set-credentials user --token=${TOKEN}
    kubectl config set-context my-context --cluster=kubernetes --namespace=default --user=myuser
    kubectl config use-context my-context
    ```
