#!/bin/bash

set -euo pipefail

SA_NAME=${1:-default}

echo "=== logging in as ${SA_NAME}"

SA_TOKEN=$(kubectl get secrets --context minikube -n vault-minikube -o json | \
            jq -r '.items[] |
                        select(.metadata.annotations["kubernetes.io/service-account.name"] == "'${SA_NAME}'") |
                        .data.token' | \
            base64 -d)

VAULT_TOKEN=$(
    vault write -address=${VAULT_ADDR} \
        auth/kubernetes/minikube/login \
        role=read-only \
        -format=json \
        jwt="${SA_TOKEN}" | \
    jq -r '.auth.client_token')
vault login -address=${VAULT_ADDR} ${VAULT_TOKEN}
