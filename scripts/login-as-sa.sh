#!/bin/bash

set -euo pipefail

SA_NAME=${1:-default}

echo "=== logging in as ${SA_NAME}"

SA_TOKEN=$(./scripts/get-sa-token.sh ${SA_NAME})

VAULT_TOKEN=$(
    vault write -address=${VAULT_ADDR} \
        auth/kubernetes/minikube/login \
        role=read-only \
        -format=json \
        jwt="${SA_TOKEN}" | \
    jq -r '.auth.client_token')
vault login -address=${VAULT_ADDR} ${VAULT_TOKEN}
