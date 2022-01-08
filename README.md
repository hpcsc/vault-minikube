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

### Render vault template

These make targets get service account `default` token, use that token to authenticate with vault k8s to get vault token and use that vault token to render different templates

```shell
make render-secret-templates    # this renders template for secrets from K-V engine
make render-aws-templates       # this renders template for aws temporary credentials
make render-pki-templates       # this renders template for pki certificate/private key
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

## Configure Okta auth backend

```shell
# deploy vault to kubernetes
make apply
# use terraform to create okta authorization server, okta application for vault and setup okta auth backend in vault
cd infra && make apply
# Go to okta, assign users to okta group created by terraform (`vault-minikube` by default)
# Go to vault, login using oidc role `read-only`
```
