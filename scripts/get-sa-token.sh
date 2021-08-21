#!/bin/bash

set -euo pipefail

SA_NAME=${1:-default}
kubectl get secrets --context minikube -n vault-minikube -o json | \
            jq -r '.items[] |
                        select(.metadata.annotations["kubernetes.io/service-account.name"] == "'${SA_NAME}'") |
                        .data.token' | \
            base64 -d
