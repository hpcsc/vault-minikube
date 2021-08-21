# vault-minikube

Kustomize configs to deploy vault with kubernetes authentication into minikube for testing

## Run

```shell
make apply
```

## Test

```shell
make login-as-default-sa # login as default service account in vault-minikube namespace
make get-secret SECRET=secret/read-only/test-secret         # accessible
make get-secret SECRET=secret/another-test-secret         # inaccessible
```

## Configure AWS secret engine

```shell
# this credential must have policy to assume `my-role` role below
vault write aws/config/root \
    access_key=${AWS_ACCESS_KEY} \
    secret_key=${AWS_SECRET_KEY} \
    region=${REGION}

# this role must have trust policy to allow above user to assume role
vault write aws/roles/my-role \
    role_arns=arn:aws:iam::my-account:role/my-role \
    credential_type=assumed_role
```
