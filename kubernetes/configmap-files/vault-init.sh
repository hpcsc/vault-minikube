#!/bin/sh

set -euo pipefail

TIMEOUT_PERIOD=30
DELAY=2

function wait_for() {
    set +e
    local t=$TIMEOUT_PERIOD

    vault status
    until [ $? = 0 ]  ; do
        t=$((t - DELAY))
        if [[ $t -eq 0 ]]; then
            echo "=== vault is not up after $TIMEOUT_PERIOD seconds"
            set -e
            exit 1
        fi

        echo "=== vault is not up yet, remaining time: $t seconds"
        sleep $DELAY
        vault status
    done

    echo "=== vault is up"
    set -e
}

function configure_k8s_auth() {
    if [ -z "$(vault auth list | grep kubernetes)" ]; then
        SA_JWT_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
        SA_CA_CRT=$(cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt)
        SA_ISSUER=$( wget --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
                        --no-check-certificate \
                        -qO- https://kubernetes.default:443/.well-known/openid-configuration |
                    sed 's/.*"issuer":"\([^"]*\)".*/\1/g')

        vault auth enable -path=kubernetes/minikube kubernetes
        vault write auth/kubernetes/minikube/config \
            token_reviewer_jwt="${SA_JWT_TOKEN}" \
            kubernetes_host=https://kubernetes.default \
            kubernetes_ca_cert="${SA_CA_CRT}" \
            disable_local_ca_jwt=true \
            issuer="${SA_ISSUER}" # required for k8s 1.21
    fi
    vault policy write read-only /vault-init-config/policy.hcl
    vault write auth/kubernetes/minikube/role/read-only \
        bound_service_account_names=default \
        bound_service_account_namespaces=* \
        policies=read-only \
        ttl=1h
}

function configure_aws_secret_engine() {
    if [ -z "$(vault secrets list | grep aws)" ]; then
        vault secrets enable aws
    fi
}

function configure_pki_secret_engine() {
    if [ -z "$(vault secrets list | grep pki)" ]; then
        vault secrets enable pki
        vault write pki/root/generate/internal common_name=vault-minikube.com
        vault write pki/config/urls \
            issuing_certificates="${VAULT_ADDR}/v1/pki/ca" \
            crl_distribution_points="${VAULT_ADDR}/v1/pki/crl"
    fi

    vault write pki/roles/vault-minikube \
        allowed_domains=vault-minikube.com \
        allow_subdomains=true \
        max_ttl=72h
}

wait_for

vault kv put secret/read-only/test-secret key1=value1 key2=vaue2
vault kv put secret/another-test-secret key=value
configure_k8s_auth
configure_aws_secret_engine
configure_pki_secret_engine
