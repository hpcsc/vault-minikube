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
